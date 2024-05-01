window.SERVER = (function($) {
  var mod = {};

  function getMetaContent(name) {
    return $(`meta[name='${name}']`).attr('content')
  }

  function getHeaders() {
    let headers = new Headers();
    headers.append("X-CSRF-Token", getMetaContent('csrf-token'));
    return headers;
  }

  mod.fetch = async function(metaName) {
    const url = UTIL.getMetaData(metaName);
    return await fetch(
      url,
      {
        method: 'POST', headers: getHeaders()
      }
    );
  };

  mod.send = async function(metaName, body) {
    const url = UTIL.getMetaData(metaName);
    return await fetch(
      url,
      {
        method: 'POST', headers: getHeaders(),
        body: new URLSearchParams(body),
        dataType: 'json', keepalive: true
      }
    );
  };

  mod.sendUrl = async function(url, body) {
    return await fetch(
      url,
      {
        method: 'POST', headers: getHeaders(),
        body: new URLSearchParams(body),
        dataType: 'json', keepalive: true
      }
    );
  };

  return mod;
}(window.$));

