App.reservation = App.cable.subscriptions.create "ReservationChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log 'yeah, connected'

  disconnected: ->
    # Called when the subscription has been terminated by the server
    console.log 'oh, no, disconnected'

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log(data.message)

    # just simply reload the pages

    if $('.reservations_public').length > 0
      window.location.reload()

    if $('.patients_reservations_index, .patients_reservations_show').length > 0
      window.location.reload()
