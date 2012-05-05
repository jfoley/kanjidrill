$ ->
  $('form#sign_in').on('ajax:success', (e, response) ->
    if(response.success)
      window.location.href = response.redirect_path
    else
      error = $('<div class="alert alert-error">Login failed</div>')
      $('#flash').html(error)
      $('#user_email').focus()
  )
