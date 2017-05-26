$.ajaxSetup({
  beforeSend: function(jqXHR){
    $('#loadingToast').fadeIn(100);
  },
  complete: function(jqXHR){
    setTimeout(function () {
      $('#loadingToast').hide(100);
    }, 1200);
  }
});

var IM = {

  call: function(caller,  callee, reservation_id, caller_phone, callee_phone) {

      console.log("caller is " + caller, "callee is " + callee);
      $.post('/background_jobs/call.json', {
        caller: caller,
        callee: callee,
        reservation_id: reservation_id,
        caller_phone: caller_phone,
        callee_phone: callee_phone
      })
  },

  call_support: function(caller, callee, reservation_id, callee_phone){
      console.log("caller is " + caller, "callee is " + callee);
      $.post('/background_jobs/call_support.json', {
        caller: caller,
        callee: callee,
        reservation_id: reservation_id,
        callee_phone: callee_phone
      })
  },

  send_sms: function(){

  },

  cancel: function(reservation_id){
    $.post('/background_jobs/cancel_reservation.json', {
      reservation_id: reservation_id
    }, function(data){
      window.location.href = '/patients/reservations'
    })
  }
};
