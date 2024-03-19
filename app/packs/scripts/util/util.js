window.UTIL = (function($) {
  var mod = {};

  mod.getMetaData = function(name) {
    return $(`meta[name='${name}']`).attr('content');
  }

  return mod;
}(window.$));
