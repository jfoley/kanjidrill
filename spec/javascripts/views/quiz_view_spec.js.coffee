#= require backbone/kanji_drill

QuizView = KanjiDrill.Views.QuizView
KanjiCollection = KanjiDrill.Collections.KanjiCollection

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

  it 'can be created', ->
    expect(@view).toBeDefined()

  it 'manages a collection of checks', ->
    expect(@view.checks).toBeDefined()

  it 'sets a shortcut to the .btn-grp element', ->
    expect(@view.btnGrp).toExist()

  describe '#startQuiz', ->
    it 'calls showGlyph', ->
      spyOn(@view, 'showGlyph')
      @view.delegateEvents()

      @view.startQuiz()
      expect(@view.showGlyph).toHaveBeenCalled()

  describe '#showGlyph', ->
    beforeEach ->
      @view.showGlyph()

    it 'shows the glyph for the current kanji', ->
      expect(@collection.pluck('glyph')).toContain(@view.$('.glyph').text())

    it 'shows a show button', ->
      expect(@view.$('.btn-grp button.show')).toExist()

    it 'responds to a click on the show button', ->
      spyOn(@view, 'clickShow')
      @view.delegateEvents()

      @view.$('.btn-grp button.show').click()

      expect(@view.clickShow).toHaveBeenCalled()

  describe '#clickShow', ->
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


  describe '#clickAnswer', ->
    beforeEach ->
      @view.startQuiz()
      @view.clickShow()

    it "gets called when an answer button is clicked", ->
      spyOn(@view, 'clickAnswer')
      @view.delegateEvents()

      @view.$('button.answer').click()
      expect(@view.clickAnswer).toHaveBeenCalled()

    it 'creates a check object and adds it to the collection', ->
      @view.$('button.answer').first().click()

      expect(@view.checks.length).toEqual(1)
