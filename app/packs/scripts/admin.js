let BUTTON_VIEWS = {};

let POP_TOTAL;
let POP_AVGM;
let POP_AVGW;

let USER_CARDS;

let IDX_OPEN_CARD = -1;

const Q_CONTROL_BUTTON = '#control-panel > button';

/**
  * Pulls popularity data from the database and uses it
  * to fill the appropriate fields
  */
async function updatePopularity() {
  const response = await SERVER.fetch('popularity');
  const json = await response.json();

  POP_TOTAL.html(json['total']);
  POP_AVGM.html(json['avgm']);
  POP_AVGW.html(json['avgw']);
}

/**
 * Wires up the functionality of the user cards on the page
 *
 * Configures the cards so that they can open and close upon
 * clicking on them.
 * Adds functionality to the cards' save button so the data
 * can be sent to the server.
 */
function wireupUserCards() {
  let idxCard = 0;
  USER_CARDS.children().each(function() {
    let card = $(this);
    const index = idxCard; // Necessary due to closures
    card.on('click', function(evt) {
      let target = $(evt.target);
      if (IDX_OPEN_CARD == index) {
        if (!(target.is(card) || target.is(card.find('.uc-enlarge'))))
          return;

        card.removeClass('open');
        IDX_OPEN_CARD = -1;
        return;
      }

      if (IDX_OPEN_CARD > -1)
        USER_CARDS.children().eq(IDX_OPEN_CARD).removeClass('open');

      card.addClass('open');
      IDX_OPEN_CARD = index;
    });

    card.find('button.pwreset').on('click', function() {
      // TODO: Reset password
    });

    card.find('button.save').on('click', function() {
      let id = card.attr('id').split('-')[2];
      let name = card.find('[name="name"]').val();
      let email = card.find('[name="email"]').val();
      SERVER.send('update-user', { 'id': id, 'name': name, 'email': email });
    });
    idxCard++;
  });
}

function mkfn_selectInfoView(target) {
  return function() {
    for (let [id, domView] of Object.entries(BUTTON_VIEWS)) {
      let button = $(Q_CONTROL_BUTTON + '#' + id);
      let view = $(domView);
      if (id === target) {
        button.addClass('selected');
        view.show();
      }
      else {
        button.removeClass('selected');
        view.hide();
      }
    }
  };
}

document.addEventListener('DOMContentLoaded', function() {
  POP_TOTAL = $('#gnrl-popularity .total .value');
  POP_AVGM = $('#gnrl-popularity .avgm .value');
  POP_AVGW = $('#gnrl-popularity .avgw .value');

  USER_CARDS = $('#users .card-list');

  let buttons = $(Q_CONTROL_BUTTON).toArray();
  let infoViews = $('#info-block > *').toArray();

  function mkfn_findViewByID(id) {
    return (view) => $(view).attr('id') === id;
  }

  let foundSelectedView = false;
  buttons.forEach(function(btn) {
    let jqBtn = $(btn);
    let btnID = jqBtn.attr('id');

    let view = infoViews.find(mkfn_findViewByID(jqBtn.attr('id')));
    BUTTON_VIEWS[btnID] = view;

    jqBtn.on('click', mkfn_selectInfoView(btnID));

    if (!foundSelectedView && jqBtn.hasClass('selected')) {
      foundSelectedView = true;
      $(view).show();
    }
    else {
      jqBtn.removeClass('selected');
      $(view).hide();
    }
  });

  if (!foundSelectedView) {
    let first = Object.keys(BUTTON_VIEWS)[0];
    $(Q_CONTROL_BUTTON + '#' + first).addClass('selected');
    $(BUTTON_VIEWS[first]).show();
  }

  updatePopularity();
  wireupUserCards();
});

