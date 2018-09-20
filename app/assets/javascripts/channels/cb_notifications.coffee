App.cb_notifications = App.cable.subscriptions.create "CBNotificationsChannel",
  connected: ->
    # console.log 'connected'
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # alert('Connection closed')
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#notifications').append "<pre>#{JSON.stringify(data['message'], undefined, 2)}</pre>"
