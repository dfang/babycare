var IM = {
  call: function(caller,  callee, reservation_id, reservation_phone) {

      console.log("caller is " + caller, "callee is " + callee);

      $.post('/background_jobs/call.json', {
        caller: caller,
        callee: callee,
        reservation_id: reservation_id,
        reservation_phone: reservation_phone,
      }, function(data){

      })
  },

  send_sms: function(){

  }


};
