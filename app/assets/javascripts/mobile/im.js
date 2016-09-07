var IM = {
  call: function(caller,  callee, reservation_id, callee_phone) {

      console.log("caller is " + caller, "callee is " + callee);

      $.post('/background_jobs/call.json', {
        caller: caller,
        callee: callee,
        reservation_id: reservation_id,
        callee_phone: callee_phone,
      }, function(data){

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

  }


};
