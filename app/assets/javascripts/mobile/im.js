var IM = {
  call: function(caller,  callee, reservation_id, callee_phone) {

      console.log("caller is " + caller, "callee is " + callee);
      $('#loadingToast').show();
      $.post('/background_jobs/call.json', {
        caller: caller,
        callee: callee,
        reservation_id: reservation_id,
        callee_phone: callee_phone,
      }, function(data){
        $('#loadingToast').hide();
      })
  },

  call_support: function(caller, callee, reservation_id, callee_phone){
      console.log("caller is " + caller, "callee is " + callee);
      $('#loadingToast').show();
      $.post('/background_jobs/call_support.json', {
        caller: caller,
        callee: callee,
        reservation_id: reservation_id,
        callee_phone: callee_phone
      }, function(data){
        $('#loadingToast').hide();
      })
  },

  send_sms: function(){

  },

  cancel: function(){
    $.post('/background_jobs/cancel_reservation.json', {
      reservation_id: reservation_id
    }, function(data){
      $('#loadingToast').hide();
      window.location.href = '/my/patients/reservations'
    })
  }
};
