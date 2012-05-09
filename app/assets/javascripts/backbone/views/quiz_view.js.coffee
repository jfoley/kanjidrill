class KanjiDrill.Views.QuizView extends Backbone.View
  events:
    'click button.show': 'clickShow'
    'click button.answer': 'clickAnswer'
    #'click button.no': 'clickNo'
    #'click button.maybe': 'clickMaybe'
    #'click button.yes': 'clickYes'
    #'click button.next': 'clickNext'

  initialize: ->
    #$(document).keyup(@keyup)
    @checks = new KanjiDrill.Collections.ChecksCollection()
    @btnGrp = $('.btn-grp')
    #@checks.on('sync', @showStats)

  startQuiz: ->
    @showGlyph()

  showGlyph: ->
    random_index = Math.floor(Math.random()*@collection.length)
    @kanji = @collection.at(random_index)
    glyph = @kanji.get('glyph')
    @$('.glyph').text(glyph)

    @renderShowButton()

  createButton: (text) ->
    className = text.toLowerCase()
    $("<button class='btn #{className}'>#{text}</button>")

  renderShowButton: ->
    @btnGrp.html(@createButton('Show'))

  clickShow: ->
    # show the meaning
    meaning = @kanji.get('meaning')
    @$('.meaning').text(meaning)

    # ask the user how well they remembered (also, clear out .btn-grp)
    @btnGrp.html($('<p class="remember">How well did you remember?</p>'))

    # render answer buttons
    for answer in ['Again', 'Hard', 'Normal', 'Easy']
      @btnGrp.append($("<button class='btn answer'>#{answer}</button>"))

  clickAnswer: ->
    answer = $(@).text()
    @checks.create(
      result: answer
    )

  #renderAnswerButtons: ->
    #@btnGrp.html($('<p class="remember">Did you Remember?</p>'))
    #buttons = ['no', 'maybe', 'yes']
    #@btnGrp.append(@createButton(text)) for text in buttons

  #renderNextButton: ->
    #@btnGrp.html(@createButton('next'))

  #showMeaning: =>
    #@$('button.show').remove()
    #meaning = @kanji.get('meaning')
    #@$('.flashcard .meaning').text(meaning)
    #@renderAnswerButtons()

  #showStats: (model, response) =>
    #time = "<time class='timeago' datetime='#{response.last_seen}'>#{response.last_seen}</time>"
    #last_seen = $("<dt>Last Seen</dt><dd>#{time}</dd>")
    #no_count = $("<dt>Hard</dt><dd>#{response.hard_count}</dd>")
    #maybe_count = $("<dt>Normal</dt><dd>#{response.normal_count}</dd>")
    #yes_count = $("<dt>Easy</dt><dd>#{response.easy_count}</dd>")

    #def_list = $('<dl class="dl-horizontal"></dl>')
    #def_list.append(last_seen)
      #.append(no_count)
      #.append(maybe_count)
      #.append(yes_count)

    #@$('.stats').html(def_list)
    #@$('.timeago').timeago()
    #@btnGrp.empty()
    #@renderNextButton()

  #clickNo: ->
    #@createCheck('no')

  #clickMaybe: ->
    #@createCheck('maybe')

  #clickYes: ->
    #@createCheck('yes')

  #clickNext: ->
    #@$('.stats').empty()
    #@$('.meaning').empty()
    #@$('.glyph').empty()
    #@showKanji()

  #createCheck: (result) ->
    #@checks.create(result: result, kanji_id: @kanji.get('id'))

  #keyup: (e) ->
    #switch e.which
      #when 32 then $('button.show, button.next').click() # space
      #when 49 then $('button.no').click()                # 1
      #when 50 then $('button.maybe').click()             # 2
      #when 51 then $('button.yes').click()               # 3
