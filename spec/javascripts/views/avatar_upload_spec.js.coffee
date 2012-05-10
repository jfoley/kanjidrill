//= require jquery.fileupload/vendor/jquery.ui.widget
//= require jquery.fileupload/jquery.fileupload
//= require jquery.fileupload/jquery.fileupload-ui
//= require jquery.fileupload/jquery.iframe-transport
//= require backbone/kanji_drill

AvatarUploadView = KanjiDrill.Views.AvatarUploadView

describe 'AvatarUploadView', ->
  beforeEach ->
    loadFixtures('avatar_upload')
    @view = new AvatarUploadView(el: $('#avatar_upload'))

  #it 'calls setupS3Form on intialization', ->
    #setupStub = sinon.spy(@view, 'setupS3Form')
    #@view.initialize()

    #expect(setupStub).toHaveBeenCalled()

  describe '.setupS3Form', ->
    it 'sets up the S3 upload form', ->
      fileuploadStub = sinon.spy(@view.$el, 'fileupload')
      @view.initialize()

      expect(fileuploadStub).toHaveBeenCalled()

    it 'calls fileupload with the correct arguments', ->
      fileuploadStub = sinon.spy(@view.$el, 'fileupload')
      @view.initialize()
      fileuploadArgs =
        forceIframeTransport: true
        autoUpload: true

        add: @view.submitToS3
        done: @view.submittedToS3

      expect(fileuploadStub).toHaveBeenCalledWith(fileuploadArgs)

  describe '.submitToS3', ->
    beforeEach ->
      @dataStub =
        submit: ->

    it 'sets the avatar to a loading image', ->
      @view.submitToS3(null, @dataStub)

      expect($('img.avatar.profile').attr('src')).toEqual('/loading.gif')

    it 'gets a S3 policy from the server', ->
      sinon.spy(@view, 'getS3Policy')
      @view.submitToS3(null, @dataStub)

      expect(@view.getS3Policy).toHaveBeenCalled()

    it 'submits the data', ->
      sinon.spy(@dataStub, 'submit')
      @view.submitToS3(null, @dataStub)

      expect(@dataStub.submit).toHaveBeenCalled()
