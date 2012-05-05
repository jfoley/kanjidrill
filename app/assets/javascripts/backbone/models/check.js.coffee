class KanjiDrill.Models.Check extends Backbone.Model
  paramRoot: 'check'

class KanjiDrill.Collections.ChecksCollection extends Backbone.Collection
  model: KanjiDrill.Models.Check
  url: '/checks'
