var IM = {
  call: function(caller,  callee, reservation_id) {

      alert("caller is " + caller, "callee is " + callee);

      $.post('/background_jobs/call.json', {
        caller: caller,
        callee: callee,
        reservation_id: reservation_id
      }, function(data){
         
      })
  },

  send_sms: function(){

  }


};

