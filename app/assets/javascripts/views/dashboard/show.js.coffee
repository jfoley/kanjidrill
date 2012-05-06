//= require jquery.fileupload/vendor/jquery.ui.widget
//= require jquery.fileupload/jquery.fileupload
//= require jquery.fileupload/jquery.fileupload-ui
//= require jquery.fileupload/jquery.iframe-transport
//= require backbone/kanji_drill

$ ->
  new KanjiDrill.Views.AvatarUploadView(el: $('#avatar_upload'))
