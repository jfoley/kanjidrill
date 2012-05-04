class KanjiDrill.Views.QuizView extends Backbone.View
  initialize: ->
    @renderKanji()

  renderKanji: ->
    random_index = Math.floor(Math.random()*@collection.length)
    kanji = @collection.at(random_index)
    glyph = kanji.get('glyph')

    @$el.text(glyph)
