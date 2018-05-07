const util = {
  isWeiXin: () => {
    let ua = window.navigator.userAgent.toLowerCase();
    return ua.match(/MicroMessenger/i) == 'micromessenger';
  },

  isAndroid: () => {
    let ua = navigator.userAgent.toLowerCase();
    return ua.indexOf('android') > -1; //&& ua.indexOf("mobile");
  }
};

export default util;
