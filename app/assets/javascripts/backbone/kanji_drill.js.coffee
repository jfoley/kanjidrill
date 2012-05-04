#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.KanjiDrill =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

$ ->
  raw_kanji = JSON.parse($('#bootstrapKanji').text())
  kanji = new KanjiDrill.Collections.KanjiCollection(raw_kanji)
  quiz_view = new KanjiDrill.Views.QuizView(el: $('#quiz'), collection: kanji)
