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

  describe '.getS3Policy', ->
    it 'calls $.ajax with the correct arguments', ->
      sinon.spy($, 'ajax')
      @view.getS3Policy()
      params =
        url: '/s3_policy'
        type: 'GET'
        dataType: 'json'
        data: null
        async: false
        success: @view.writeS3Policy

      expect($.ajax).toHaveBeenCalledWith(params)
      $.ajax.restore()

  describe '.writeS3Policy', ->
    it 'puts the key, policy, and signature in the form', ->
      s3_credentials =
        key: 'S3_KEY'
        policy: 'S3_POLICY'
        signature: 'S3_SIGNATURE'

      @view.writeS3Policy(s3_credentials)

      expect(@view.$('input[name=key]').val()).toBe('S3_KEY')
      expect(@view.$('input[name=policy]').val()).toBe('S3_POLICY')
      expect(@view.$('input[name=signature]').val()).toBe('S3_SIGNATURE')

  describe '.submittedToS3', ->
    beforeEach ->
      @data =
        files: [ { name: 'remote_filename.png' } ]

    it 'sends the remote URL to the server to notify it to process', ->
      sinon.spy($, 'ajax')
      params =
        url: '/fetch_avatar'
        type: 'POST'
        dataType: 'json'
        data: { remote_url: 'AWS_UPLOAD_URL/uploads/remote_filename.png' }

      @view.submittedToS3(null, @data)


      expect($.ajax).toHaveBeenCalledWith(params)
      $.ajax.restore()

    it 'sets a timeout that checks S3 for the processed image', ->
      sinon.spy(window, 'setTimeout')
      @view.submittedToS3(null, @data)

      expect(@view.timeout).toBeDefined()
      expect(window.setTimeout).toHaveBeenCalledWith(@view.pollForImage, 1000)
      window.setTimeout.restore()

  describe '.pollForImage', ->
    it 'makes an AJAX call to see if the image is done processing', ->
      sinon.spy($, 'ajax')
      params =
        url: '/poll_avatar'
        type: 'POST'
        dataType: 'json'
        data: null
        async: false
        success: @view.imagePoll

      @view.pollForImage()
      expect($.ajax).toHaveBeenCalledWith(params)
      $.ajax.restore()

  describe '.imagePoll', ->
    it 'updates the avatars on the page if the response has the new URLs', ->
      @view.imagePoll(profile: 'profile_url.png', thumb: 'thumb_url.png')

      expect($('img.avatar.profile').attr('src')).toEqual('profile_url.png')
      expect($('img.avatar.thumb').attr('src')).toEqual('thumb_url.png')

    it 'resets the timeout if the response is empty', ->
      sinon.spy(window, 'setTimeout')
      @view.imagePoll({})

      expect(@view.timeout).toBeDefined()
      expect(window.setTimeout).toHaveBeenCalledWith(@view.pollForImage, 1000)
      window.setTimeout.restore()

