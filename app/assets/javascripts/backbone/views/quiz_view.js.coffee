class KanjiDrill.Views.QuizView extends Backbone.View
  events:
    'click button.show': 'showMeaning'
    'click button.no': 'clickNo'
    'click button.maybe': 'clickMaybe'
    'click button.yes': 'clickYes'
    'click button.next': 'clickNext'

  btnGrp: $('.btn-grp')

  initialize: ->
    $(document).keyup(@keyup)
    @checks = new KanjiDrill.Collections.ChecksCollection()
    @checks.on('sync', @showStats)
    @showKanji()

  showKanji: ->
    random_index = Math.floor(Math.random()*@collection.length)
    @kanji = @collection.at(random_index)
    glyph = @kanji.get('glyph')

    @$('.flashcard .glyph').text(glyph)
    @renderShowButton()

  createButton: (text) ->
    className = text.toLowerCase()
    $("<button class='btn #{className}'>#{text}</button>")

  renderShowButton: ->
    @btnGrp.html(@createButton('Show'))

  renderAnswerButtons: ->
    @btnGrp.html($('<p class="remember">Did you Remember?</p>'))
    buttons = ['no', 'maybe', 'yes']
    @btnGrp.append(@createButton(text)) for text in buttons

  renderNextButton: ->
    @btnGrp.html(@createButton('next'))

  showMeaning: =>
    @$('button.show').remove()
    meaning = @kanji.get('meaning')
    @$('.flashcard .meaning').text(meaning)
    @renderAnswerButtons()

  showStats: (model, response) =>
    time = "<time class='timeago' datetime='#{response.last_seen}'>#{response.last_seen}</time>"
    last_seen = $("<dt>Last Seen</dt><dd>#{time}</dd>")
    no_count = $("<dt>No</dt><dd>#{response.no_count}</dd>")
    maybe_count = $("<dt>Maybe</dt><dd>#{response.maybe_count}</dd>")
    yes_count = $("<dt>Yes</dt><dd>#{response.yes_count}</dd>")

    def_list = $('<dl class="dl-horizontal"></dl>')
    def_list.append(last_seen)
      .append(no_count)
      .append(maybe_count)
      .append(yes_count)

    @$('.stats').html(def_list)
    @$('.timeago').timeago()
    @btnGrp.empty()
    @renderNextButton()

  clickNo: ->
    @createCheck('no')


  clickMaybe: ->
    @createCheck('maybe')

  clickYes: ->
    @createCheck('yes')

  clickNext: ->
    @$('.stats').empty()
    @$('.meaning').empty()
    @$('.glyph').empty()
    @showKanji()

  createCheck: (result) ->
    @checks.create(result: result, kanji_id: @kanji.get('id'))

  keyup: (e) ->
    switch e.which
      when 32 then $('button.show, button.next').click() # space
      when 49 then $('button.no').click()                # 1
      when 50 then $('button.maybe').click()             # 2
      when 51 then $('button.yes').click()               # 3
