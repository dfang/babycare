$(function(){
  console.log('validate ....');
  $('form.parsley-validate').length > 0 && $('form.parsley-validate').parsley({ uiEnabled: true, errorsWrapper: '' }).on('field:error', function() {
        $(this.$element)
          .parents('.weui-cell')
          .addClass('validation_error');
      }).on('field:success', function() {
        $(this.$element)
          .parents('.weui-cell')
          .removeClass('validation_error');
      });
});
