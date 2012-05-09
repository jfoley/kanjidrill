#= require backbone/kanji_drill
QuizView = KanjiDrill.Views.QuizView

describe 'QuizView', ->
  it 'can be created', ->
    @view = new QuizView
    expect(@view).toBeDefined()
