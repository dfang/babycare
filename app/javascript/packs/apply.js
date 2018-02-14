import $ from 'jquery'

$(function(){
  // 输入手机号后获取验证码按钮可用
  $(document).on(
    'keyup',
    '.weui-input.request-captcha',
    function(e) {
      var charCode = e.charCode || e.keyCode;
      // numbers
      if (96 <= charCode <= 105) {
        var mobile_phone = $(
          '.weui-input.request-captcha'
        ).val();
        if (mobile_phone.length == 11) {
          $('button.weui-vcode-btn.get-code')
            .removeAttr('disabled')
            .attr('style', 'width:110px;');
        } else {
          $('button.weui-vcode-btn.get-code')
            .attr('disabled', true)
            .attr(
              'style',
              'color:inherit;width:110px;'
            );
        }
      }
    }
  );

  // 请求获取验证码
  $(document).on(
    'click',
    'button.weui-vcode-btn',
    function(e) {
      e.preventDefault();
      var mobile_phone = $(
        '.weui-input.request-captcha'
      ).val();
      $.post(
        '/simple_captcha/request_captcha',
        { mobile_phone: mobile_phone },
        function(data) {
          console.log(mobile_phone);
        }
      );

      // 倒计时60秒
      $('button.weui-vcode-btn.get-code').hide();
      $('#J_second').html('60');
      $('button.weui-vcode-btn.reset-code').show();
      var second = 60;
      var timer = null;
      timer = setInterval(function() {
        second -= 1;
        if (second > 0) {
          $('#J_second').html(second);
        } else {
          clearInterval(timer);
          $('button.weui-vcode-btn.get-code').html(
            '重新获取'
          );
          $('button.weui-vcode-btn.get-code').show();
          $('button.weui-vcode-btn.reset-code').hide();
        }
      }, 1000);
    }
  );

  // 验证验证码when focusOut
  $(document).on(
    'keyup',
    '.weui-input.captcha',
    function(e) {
      var charCode = e.charCode || e.keyCode;
      // numbers
      if (96 <= charCode <= 105) {
        var mobile_phone = $(
          '.weui-input.request-captcha'
        ).val();
        var captcha = $('.weui-input.captcha').val();
        if (
          mobile_phone.length == 11 &&
          captcha.length == 6
        ) {
          $.ajax({
            url:
              '/simple_captcha/simple_captcha_valid.json',
            data: {
              mobile_phone: mobile_phone,
              captcha: captcha
            },
            type: 'POST'
          }).always(function(data) {
            if (data.result == 'success') {
              $('.weui-cell.simple-captcha')
                .find('.weui-cell__ft')
                .html(
                  '<i class="weui-icon-success"></i>'
                );
              $('.weui-btn-area .weui-btn_disabled')
                .removeClass('weui-btn_disabled')
                .removeAttr('disabled');
            } else {
              // 错误
              $('.weui-cell.simple-captcha')
                .find('.weui-cell__ft')
                .html(
                  '<i class="weui-icon-cancel"></i>'
                );
            }
          });
        } else {
          $('.weui-cell.simple-captcha')
            .find('.weui-cell__ft')
            .html('<i class="weui-icon-cancel"></i>');
          $('.weui-btn-area input')
            .addClass('weui-btn_disabled')
            .attr('disabled', 'disabled');
        }
      }
    }
  );

  $('form#new_doctor')
    .parsley({ uiEnabled: true, errorsWrapper: '' })
    .on('field:error', function() {
      $(this.$element)
        .parents('.weui-cell')
        .addClass('validation_error');
    })
    .on('field:success', function() {
      $(this.$element)
        .parents('.weui-cell')
        .removeClass('validation_error');
    });
})
