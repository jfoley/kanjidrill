class KanjiDrill.Views.AvatarUploadView extends Backbone.View
  initialize: ->
    @setupS3Form()

  setupS3Form: ->
    @$el.fileupload(
      forceIframeTransport: true,
      autoUpload: true,

      add: @submitToS3
      done: @submittedToS3

      # TODO: figure out why this is failing (but not actually?)
      failed: @submittedToS3
    )

  submitToS3: (event, data) =>
    # set avatar to a loading spinner
    $('img.avatar.profile').attr('src', '/loading.gif')

    @getS3Policy()
    data.submit()

  getS3Policy: =>
    $.ajax(
      url: '/s3_policy'
      type: 'GET'
      dataType: 'json'
      data: null
      async: false
      success: @writeS3Policy
    )

  writeS3Policy: (s3_credentials) =>
    @$('input[name=key]').val(s3_credentials.key)
    @$('input[name=policy]').val(s3_credentials.policy)
    @$('input[name=signature]').val(s3_credentials.signature)

  submittedToS3: (event, data) =>
    ## since we cant just get this out of the response headers, we have to infer it ourselves :/
    filename = escape(data.files[0].name)
    remote_url = "#{@$el.attr('action')}/uploads/#{filename}"

    # tell the server where to go get the new file
    $.ajax(
      url: '/fetch_avatar'
      type: 'POST'
      dataType: 'json'
      data: { remote_url: remote_url }
    )

    # check back for the processed image
    @timeout = setTimeout(@pollForImage, 1000)

  ## TODO: see if there is a more elegant way to accomplish this
  ## websockets?
  pollForImage: =>
    $.ajax(
      url: '/poll_avatar'
      type: 'POST'
      dataType: 'json'
      data: null
      async: false
      success: @imagePoll
    )

  imagePoll: (response) =>
    if response.profile? && response.thumb?
      $('img.avatar.profile').attr('src', response.profile)
      $('img.avatar.thumb').attr('src', response.thumb)
    else
      @timeout = setTimeout(@pollForImage, 1000)
