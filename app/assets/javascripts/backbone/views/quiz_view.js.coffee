class KanjiDrill.Views.QuizView extends Backbone.View
  events:
    'click button.show':   'clickShow'
    'click button.next':   'clickNext'
    'click button.answer': 'clickAnswer'

  statsTemplate: JST['backbone/templates/stats']

  initialize: ->
    @btnGrp = $('.btn-grp')

    @checks = new KanjiDrill.Collections.ChecksCollection()
    @checks.on('sync', @showStats)

  startQuiz: ->
    $('body').keyup(@keyup)
    @showGlyph()

  showGlyph: ->
    random_index = Math.floor(Math.random()*@collection.length)
    @kanji = @collection.at(random_index)
    glyph = @kanji.get('glyph')
    @$('.glyph').text(glyph)

    @btnGrp.html($('<button class="btn show">Show</button>'))

  clickShow: ->
    # show the meaning
    meaning = @kanji.get('meaning')
    @$('.meaning').text(meaning)

    # ask the user how well they remembered (also, clear out .btn-grp)
    @btnGrp.html($('<p class="remember">How well did you remember?</p>'))

    # render answer buttons
    for answer in ['Again', 'Hard', 'Normal', 'Easy']
      answerClass = answer.toLowerCase()
      @btnGrp.append($("<button class='btn answer #{answerClass}'>#{answer}</button>"))

  clickAnswer: (ev) =>
    @checks.create(
      result: $(ev.target).text().toLowerCase()
      kanji_id: @kanji.get('id')
    )

  showStats: (_, response) =>
    @$('.stats').html(@statsTemplate(response))
    @$('.stats .timeago').timeago()

    @btnGrp.html($('<button class="btn next">Next</button>'))

  clickNext: ->
    $('.meaning, .stats').empty()
    @showGlyph()

  keyup: (e) =>
    switch e.which
      when 32 then $('button.show, button.next').click() # space
      when 49 then $('button.again').click()             # 1
      when 50 then $('button.hard').click()              # 2
      when 51 then $('button.normal').click()            # 3
      when 52 then $('button.easy').click()              # 4

