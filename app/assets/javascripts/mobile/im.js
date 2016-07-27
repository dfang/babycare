var IM = {
  call: function(caller,  callee) {

      alert("caller is " + caller, "callee is " + callee);

      $.post('/background_jobs/call.json', {
        caller: caller,
        callee: callee
      }, function(data){

      })
  }

};

