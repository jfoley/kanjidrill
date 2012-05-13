//= require backbone/kanji_drill

QuizView = KanjiDrill.Views.QuizView
KanjiCollection = KanjiDrill.Collections.KanjiCollection
ChecksCollection = KanjiDrill.Collections.ChecksCollection

rawKanji = [
  { glyph: "一", grade_id: 1, id: 1, meaning: "one" },
  { glyph: "二", grade_id: 1, id: 2, meaning: "two" },
  { glyph: "三", grade_id: 1, id: 3, meaning: "three" }
]

describe 'QuizView', ->
  beforeEach ->
    loadFixtures('quiz_view.html')
    @collection = new KanjiCollection(rawKanji)
    @view = new QuizView(el: $('#quiz'), collection: @collection)

    @response =
      last_seen: "2012-05-05T18:35:58Z"
      easy_count: 1
      hard_count: 1
      normal_count: 0

  it 'can be created', ->
    expect(@view).toBeDefined()

  it 'manages a collection of checks', ->
    expect(@view.checks.constructor).toBe(ChecksCollection)

  it 'sets a shortcut to the .btn-grp element', ->
    expect(@view.btnGrp).toExist()

  describe 'hot keys', ->
    it 'calls click on Show when spacebar is pressed', ->
      sinon.spy(@view, 'clickShow')
      @view.startQuiz()
      @view.delegateEvents()

      event = $.Event('keyup')
      event.which = 32 # spacebar
      $('body').trigger(event)

      expect(@view.clickShow).toHaveBeenCalled()

    it 'calls click on Next when spacebar is pressed', ->
      sinon.spy(@view, 'clickNext')
      @view.startQuiz()
      @view.showStats(null, @response)
      @view.delegateEvents()

      event = $.Event('keyup')
      event.which = 32 # spacebar
      $('body').trigger(event)

      expect(@view.clickNext).toHaveBeenCalled()

    it 'calls click on Again when 1 is pressed', ->
      sinon.spy(@view, 'clickAnswer')
      @view.startQuiz()
      @view.clickShow()
      @view.delegateEvents()

      event = $.Event('keyup')
      event.which = 49 # 1
      $('body').trigger(event)

      expect(@view.clickAnswer).toHaveBeenCalled()

    it 'calls click on Hard when 2 is pressed', ->
      sinon.spy(@view, 'clickAnswer')
      @view.startQuiz()
      @view.clickShow()
      @view.delegateEvents()

      event = $.Event('keyup')
      event.which = 50 # 2
      $('body').trigger(event)

      expect(@view.clickAnswer).toHaveBeenCalled()

    it 'calls click on Normal when 3 is pressed', ->
      sinon.spy(@view, 'clickAnswer')
      @view.startQuiz()
      @view.clickShow()
      @view.delegateEvents()

      event = $.Event('keyup')
      event.which = 51 # 3
      $('body').trigger(event)

      expect(@view.clickAnswer).toHaveBeenCalled()

    it 'calls click on Easy when 4 is pressed', ->
      sinon.spy(@view, 'clickAnswer')
      @view.startQuiz()
      @view.clickShow()
      @view.delegateEvents()

      event = $.Event('keyup')
      event.which = 52 # 4
      $('body').trigger(event)

      expect(@view.clickAnswer).toHaveBeenCalled()

  describe '.startQuiz', ->
    it 'calls showGlyph', ->
      sinon.spy(@view, 'showGlyph')
      @view.delegateEvents()

      @view.startQuiz()
      expect(@view.showGlyph).toHaveBeenCalled()

  describe '.showGlyph', ->
    beforeEach ->
      @view.showGlyph()

    it 'shows the glyph for the current kanji', ->
      expect(@collection.pluck('glyph')).toContain(@view.$('.glyph').text())

    it 'shows a show button', ->
      expect(@view.$('.btn-grp button.show')).toExist()

    it 'responds to a click on the show button', ->
      sinon.spy(@view, 'clickShow')
      @view.delegateEvents()

      @view.$('.btn-grp button.show').click()

      expect(@view.clickShow).toHaveBeenCalled()

  describe '.clickShow', ->
    beforeEach ->
      @view.startQuiz()
      @view.clickShow()

    it 'shows the meaning of the kanji', ->
      expect(@collection.pluck('meaning')).toContain(@view.$('.meaning').text())

    it 'asks the user how well they remembered', ->
      expect(@view.$('.remember')).toExist()

    it 'shows the user four buttons to rate how well they remembered', ->
      expect(@view.$('button.answer').length).toEqual(4)

      # kinda gross, but this ensures that each answer is present
      @view.$('button.answer').each (_, elem) ->
        expect(['Again', 'Hard', 'Normal', 'Easy']).toContain($(elem).text())

      #expect these arrays to be the same ~=
      # expect(answers).toEqual($(elem).text())


  describe '.clickAnswer', ->
    beforeEach ->
      @view.startQuiz()
      @view.clickShow()

    it "gets called when an answer button is clicked", ->
      sinon.spy(@view, 'clickAnswer')
      @view.delegateEvents()

      @view.$('button.answer').click()
      expect(@view.clickAnswer).toHaveBeenCalled()

    it 'creates a check object and adds it to the collection', ->
      @view.$('button.answer').first().click()

      expect(@view.checks.length).toEqual(1)

    it 'shows the stats for the kanji once the collection syncs', ->
      server = sinon.fakeServer.create()
      server.respondWith("POST", '/checks',
        [
          200,
          { "Content-Type": "application/json" },
          JSON.stringify(@response)
        ]
      )
      sinon.spy(@view, 'showStats')
      @view.initialize() # reinitialize the view so that the spy is bound
      @view.delegateEvents()

      @view.$('button.answer').first().click()
      server.respond()

      expect(@view.showStats).toHaveBeenCalled()

  describe '.showStats', ->
    it 'renders a <time> element', ->
      @view.showStats(null, @response)

      expect(@view.$('time')).toExist()

    it 'renders "Never" if last_seen is null', ->
      noTime = @response
      noTime.last_seen = null

      @view.showStats(null, noTime)
      expect(@view.$('time').text()).toEqual('Never')

    it 'renders a <dl> element that contains all the stats', ->
      @view.showStats(null, @response)

      expect(@view.$('dl')).toExist()

    it 'renders a <dt> and <dd> element for each answer plus one for the time last seen', ->
      @view.showStats(null, @response)

      expect(@view.$('dl dt').length).toEqual(5)
      expect(@view.$('dl dd').length).toEqual(5)

    it 'calls timeago on the time element', ->
      timeagoStub = sinon.spy($.fn, 'timeago')
      @view.showStats(null, @response)

      expect(timeagoStub).toHaveBeenCalled()

    it 'renders the next button', ->
      @view.showStats(null, @response)

      expect(@view.$('button.next')).toExist()

    it 'responds to a click on the next button', ->
      sinon.spy(@view, 'clickNext')
      @view.delegateEvents()

      @view.showStats(null, @response)
      @view.$('button.next').click()

      expect(@view.clickNext).toHaveBeenCalled()

  describe 'clickNext', ->
    beforeEach ->
      @view.showStats()

      # manually put something in the each element
      @view.$('.meaning, .stats').text('clear me out!')
      @view.clickNext()

    it 'clears out the meaning element', ->
      expect(@view.$('.meaning').text()).toEqual('')

    it 'clears out the stats element', ->
      expect(@view.$('.stats').text()).toEqual('')

    it 'calls showGlyph', ->
      sinon.spy(@view, 'showGlyph')
      @view.clickNext()

      expect(@view.showGlyph).toHaveBeenCalled()

