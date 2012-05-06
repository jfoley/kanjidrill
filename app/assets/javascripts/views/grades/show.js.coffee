//= require backbone/kanji_drill

$ ->
  raw_kanji = JSON.parse($('#bootstrapKanji').text())
  kanji = new KanjiDrill.Collections.KanjiCollection(raw_kanji)
  quiz_view = new KanjiDrill.Views.QuizView(el: $('#quiz'), collection: kanji)
