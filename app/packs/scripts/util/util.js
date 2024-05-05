window.UTIL = (function($) {
  var mod = {};

  mod.getMetaData = function(name) {
    return $(`meta[name='${name}']`).attr('content');
  }

  /**
   * Sets up pill foldout functionality. Only always you to fold
   * the pill back in when the event target is `q_pill_body`.
   *
   * @param {jQ} jq_list -
   *       A jqUery Object for the parent of the pills
   * @param {String} q_pill -
   *       The query to find the pill element
   * @param {String} q_pill_body -
   *       The query to find the pill body, that will be the event target
   *       for folding the pill back in
   * @param {function(jQ, boolean)} fn_onFoldChange -
   *       A callback for the change of the state of a pill. Takes a jQuery
   *       Object for the pill element and boolean on whether on not it is
   *       open
   */
  mod.wireupPillFoldout = function(jq_list, q_pill, q_pill_body,
                                   fn_onFoldChange = function() {}) {
    jq_list.find(q_pill).each(function() {
      const card = $(this);
      const cardID = card.attr('id');

      card.on('click', function(evt) {
        let target = $(evt.target);

        let isOpen = jq_list.find('.open')
                            .toArray()
                            .some((el) => $(el).attr('id') === cardID);

        // If we are the card that was selected
        // only close if the body or card itself was clicked so
        // that clicking on a button or input field doesn't close the
        // card
        if (isOpen) {
          if (!(target.is(card) || target.is(card.find(q_pill_body))))
            return;

          card.removeClass('open');
          fn_onFoldChange(card, false);
          return;
        }

        let cards = jq_list.find(q_pill);
        cards.toArray()
             .filter((card) => $(card).hasClass('open'))
             .forEach(function(elem) {
                fn_onFoldChange($(elem), false);
                elem.classList.remove('open');
              });

        card.addClass('open');
        fn_onFoldChange(card, true);
      });
    });
  };

  /**
   * Wires up a live search box that populates a results box based on a query
   *
   * @param {jQ} jq_inpSearch -
   *       A jQuery Object for the input field of the search box
   * @param {function(jQ): jQ} fn_getResultsBox -
   *       Given a search input field, get the results box
   * @param {Array<Object<string, string>>} resultsOptions -
   *       An array of objects to be searched
   * @param {Array<string>} searchableKeys -
   *       The keys to be searched in resultsOptions
   * @param {function(jQ, Object<string, string>): jQ} fn_createEntry
   *       Creates an entry from the result given, also passes in the related
   *       search bo
   */
  mod.createSearchBox = function(jq_inpSearch, fn_getResultsBox,
                                 resultsOptions, searchableKeys, fn_createEntry) {
    jq_inpSearch.on('input', function() {
      const thisInput = $(this);
      const resultsBox = fn_getResultsBox(thisInput);
      resultsBox.empty();

      const query = thisInput.val().toLowerCase();
      if (query === '')
        return;

      const regex = new RegExp(query);
      let matches = resultsOptions.filter(function (option) {
        for (let key of searchableKeys) {
          let result = regex.exec(option[key].toLowerCase());
          if (result != null)
            return true;
        }

        return false;
      });

      if (matches.length == 0)
        return;

      matches.forEach(function (option) {
        let entry = fn_createEntry(thisInput, option);
        resultsBox.append(entry);
      });
    });
  };

  return mod;
}(window.$));

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
