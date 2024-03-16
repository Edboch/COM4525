window.UTIL = (function($) {
  var mod = {};

  mod.getMetaData = function(name) {
    return $(`meta[name='${name}']`).attr('content');
  }

  mod.wireupPillFoldout = function(jqList, q_card, q_card_body) {
    jqList.find(q_card).each(function() {
      const card = $(this);
      const cardID = card.attr('id');

      card.on('click', function(evt) {
        let target = $(evt.target);

        let isOpen = jqList.find('.open')
                           .toArray()
                           .some((el) => $(el).attr('id') === cardID);

        // If we are the card that was selected
        // only close if the body or card itself was clicked so
        // that clicking on a button or input field doesn't close the
        // card
        if (isOpen) {
          if (!(target.is(card) || target.is(card.find(q_card_body))))
            return;

          card.removeClass('open');
          return;
        }

        jqList.find(q_card).removeClass('open');
        card.addClass('open');
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
