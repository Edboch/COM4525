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

  return mod;
}(window.$));
