import $ from 'jquery';

class IM {
  static call(caller,  callee, reservation_id, caller_phone, callee_phone) {
      console.log('caller is ' + caller, 'callee is ' + callee);
      $.post('/background_jobs/call.json', {
        caller: caller,
        callee: callee,
        reservation_id: reservation_id,
        caller_phone: caller_phone,
        callee_phone: callee_phone
      })
  }

  static call_support(caller, callee, reservation_id, callee_phone){
      console.log('caller is ' + caller, 'callee is ' + callee);
      $.post('/background_jobs/call_support.json', {
        caller: caller,
        callee: callee,
        reservation_id: reservation_id,
        callee_phone: callee_phone
      })
  }

  send_sms(){

  }

  static cancel(reservation_id){
    $.post('/background_jobs/cancel_reservation.json', {
      reservation_id: reservation_id
    }, function(data){
      window.location.href = '/patients/reservations'
    })
  }
}

export default IM;
