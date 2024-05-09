window.UTIL = (function($) {
  var mod = {};

  mod.getMetaData = function(name) {
    return $(`meta[name='${name}']`).attr('content');
  }

  mod.fromTemplate = function(query) {
    return $($('template' + query).contents()[1]);
  };

  mod.jsonDup = function(obj) { return JSON.parse(JSON.stringify(obj)); };

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
  // TODO Update Docs
  mod.wireupPillFoldout = function(jq_list, q_pill, q_blockElems,
                                   fn_onFoldChange = function() {}) {
    jq_list.find(q_pill).each(function() {
      const card = $(this);
      card.find(q_blockElems).on('click', evt => evt.stopPropagation());

      const cardID = card.attr('id');

      card.off('click.foldout');
      card.on('click.foldout', function(evt) {
        let target = $(evt.target);

        let isOpen = jq_list.find('.pf-open')
                            .toArray()
                            .some((el) => $(el).attr('id') === cardID);

        // If we are the card that was selected
        // only close if the body or card itself was clicked so
        // that clicking on a button or input field doesn't close the
        // card
        if (isOpen) {
          // if (!(target.is(card) || target.is(card.find(q_pill_body))))
          //   return;

          card.removeClass('pf-open');
          fn_onFoldChange(card, false);
          return;
        }

        let cards = jq_list.find(q_pill);
        cards.toArray()
             .filter((card) => $(card).hasClass('pf-open'))
             .forEach(function(elem) {
                fn_onFoldChange($(elem), false);
                elem.classList.remove('pf-open');
              });

        card.addClass('pf-open');
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
   * @param {function(jQ, Object): jQ} fn_createEntry
   *       Creates an entry from the result given
   *    @param {jQ} - The container of the live search
   *    @param {Object} - The object to create an entry for
   */

  // TODO: New Documentation
  mod.wireupLiveSearch = function(liveSearchName, fn_createEntry,
                                  maxOptionsWhenEmpty = 10) {
    const liveSearch = $(`.live-search-${liveSearchName}`);
    const searchFields = liveSearch.domData('search-fields');
    let varName = liveSearch.domData('search-data-var');
    if (varName === undefined)
      return;

    const searchOptions = LIVE_SEARCH[varName];

    const emptyOptionsCount = Math.min(maxOptionsWhenEmpty, searchOptions.length);

    $(`input[name='live-search-${liveSearchName}']`)
      .on('input', function() {
      const search = $(this);
      const container = search.parent();
      const results = container.find('.live-search-dropdown');
      results.empty();

      const makeEntry = function (option) {
        let entry = fn_createEntry(container, option);
        results.append(entry);
      };

      const query = search.val().toLowerCase();
      if (query === '') {
        for (let i = 0; i < emptyOptionsCount; i++)
          makeEntry(searchOptions[i]);
        return;
      }

      const regex = new RegExp(query);
      let matches = searchOptions.flatMap(function (option) {
        for (let field of searchFields) {
          let result = regex.exec(option[field].toLowerCase());
          if (result == null) continue;

          let newObj = structuredClone(option);
          newObj.resultField = field;
          return [ newObj ];
        }

        return [];
      });

      if (matches.length == 0)
        return;

      matches.forEach(makeEntry);
    });

    const dropdown = liveSearch.find('.live-search-dropdown');
    $(window).on('click', function() { dropdown.empty(); });

  };

  // TODO Documentation
  mod.createLiveSearchEntry = function(container, option, defaultOnClick = true) {
    const searchFields = container.domData('search-fields');

    let string = '';
    if (searchFields.length == 1) {
      let field = searchFields[0];
      string = option[field];
    }
    else {
      let strOtherFields =
        searchFields
          .flatMap(
            (field) => field === option.resultField ? [] : [ option[field] ])
          .join(', ');


      string =
        option.resultField
        ? `${option[option.resultField]} | ${strOtherFields}`
        : strOtherFields;
    }

    let entryHTML = string;
    let entry = $('<div class="live-search-entry"></div>');
    entry.text(entryHTML);

    if (defaultOnClick)
      entry.on('click', function() {
        let input = container.find('input');
        input.val(
          option.resultField
          ? option[option.resultField]
          : $(this).text()
        );

        container.domData(option);
      });

    entry.on('click', () => container.find('.live-search-dropdown').empty());

    return entry;
  };

  return mod;
}(window.$));
