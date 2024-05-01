import $ from 'jquery';

window.$ = (function(jQuery) {

  function processAttrib(attrib) {
    if (attrib.isJSON())
      return JSON.parse(attrib);

    let int = parseInt(attrib);
    if (int == NaN)
      return int;

    return attrib;
  }

  function getData(jQ) {
    let data = {};
    $.each(jQ[0].attributes, function() {
      if (!this.name.startsWith('data-'))
        return;

      let nameParts = this.name.split('-');
      let name = '';
      for (let i = 1; i < nameParts.length; i++) {
        if (i == 1)
          name += nameParts[i];
        else
          name += nameParts[i].capitalise();
      }

      console.log(name);
      data[name] = processAttrib(this.value);
    });
    return data;
  }

  // TODO: Documentation
  jQuery.prototype.domData = function() {
    switch (arguments.length) {
      case 0:
        // Get the data attributes as a JSON object
        return getData(this);
      case 1:
        // Get the data attribute that matches the passed in string
        if (typeof arguments[0] == 'string' || arguments[0] instanceof String) {
          let value = this.attr(`data-${arguments[0]}`);
          if (value !== undefined)
            return processAttrib(value);
        }
        else {
          let obj = arguments[0];
          for (let key in obj) {
            console.log(key.asHTMLToken());
            let attribName = 'data-' + key.asHTMLToken();
            this.attr(attribName, JSON.stringify(obj[key]));
          }
        }
        break;
      default:
        // The first two arguments correspong to the data attribute key and value
        let key = arguments[0];
        let value = arguments[1];
        this.attr(`data-${key}`, JSON.stringify(value));
        break;
    }
  };

  return jQuery;
}($));
