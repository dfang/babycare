// https://gist.github.com/kares/825641
/**
 * Very handly (not just) for Rails :
 *
 * 1. setup RoR input method naming convention :
 *
 *   $.fn.changeFormMethod.inputName = '_method';
 *
 * 2. Any time You need to change Your forms method :
 *    (e.g. re-using forms new forms for edit-ation)
 *
 *   $('form.user-form').changeFormMethod('PUT');
 *
 * @author Karol Bucek
 * @license Apache License, Version 2.0
 * @version 0.1
 */
$.fn.changeFormMethod = function(method) {
    // dealing with GET/POST only friendly browsers if
    // this is set the form's method is not changed but
    // is kept POST and the <input>'s value is updated
    var inputName = $.fn.changeFormMethod.inputName;
    
    if (method) {
        method = $.trim(method).toLowerCase();
        return this.each( function() {
            var $form = $(this);
            if ( method !== 'get' && method !== 'head' && inputName ) {
                var $input = $form.attr('method', 'post')
                                  .find('input[name="'+ inputName +'"]');
                if ($input.length) $input.val(method);
                else {
                    $form.prepend('<input type="hidden" name="'+ inputName +'" value="'+ method +'"/>');
                }
            }
            else {
                $form.attr('method', method); // assuming it's a form
            }
        });
    }
    else {
        return this;
    }
};