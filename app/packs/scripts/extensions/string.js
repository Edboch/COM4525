/**
 * Source: https://www.tutorialstonight.com/javascript-string-format
 *
 * Formats a string. The placeholders take the form of `{X}` where
 * `X` is any positive integer.
 */
String.prototype.format = function() {
  let args = arguments;
  return this.replace(/{([0-9]+)}/g,
                      (match, index) =>
                        index >= args.length ? match : args[index]
  );
};

// TODO: Documentation

String.prototype.capitalise = function() { return this.charAt(0).toUpperCase() + this.slice(1); };

String.prototype.asHTMLToken = function() {
  let out = '';
  return this.split('')
    .flatMap(function(char) {
      if (char === char.toUpperCase())
        return [ '-', char.toLowerCase() ];

      return [ char ];
    }).join('');
}

/**
  * Source: https://stackoverflow.com/questions/9804777/how-to-test-if-a-string-is-json-or-not
  */
String.prototype.isJSON = function() {
  try {
    JSON.parse(this);
  } catch (e) {
    return false;
  }

  return true;
};
