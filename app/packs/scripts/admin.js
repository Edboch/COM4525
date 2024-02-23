let BUTTON_VIEWS = {};

let POP_TOTAL;
let POP_AVGM;
let POP_AVGW;

let USER_CARDS;

const Q_CONTROL_BUTTON = '#control-panel > button';

async function updatePopularity() {
  const response = await SERVER.fetch('popularity');
  // const text = await response.text();
  // console.log(text);
  const json = await response.json();

  POP_TOTAL.html(json['total']);
  POP_AVGM.html(json['avgm']);
  POP_AVGW.html(json['avgw']);
}

async function populateUsers() {
  const response = await SERVER.fetch('get-users');
  const json = await response.json();

  let userCard = $('template.user-card').contents()[1];

  function addCard(user) {
    let card = $(userCard).clone();
    card.find('[name="name"]').val(user.name);
    card.find('[name="email"]').val(user.email);

    user.roles.forEach(function(role) {
      let tickbox = card.find('input:checkbox[name="' + role + '"]');
      if (tickbox) {
        console.log(tickbox);
        tickbox.prop('checked', true);
      }
    });
    // if (user.roles.includes('player'))
    //   card.find('[type="checkbox",name="player"]').prop('checked', true);
    // if (user.roles.includes('manager'))
    //   card.find('[type="checkbox",name="player"]').prop('checked', true);
    // if (user.roles.includes('site-admin'))
    //   card.find('[type="checkbox",name="site-admin"]').prop('checked', true);

    USER_CARDS.append(card);
  }

  // Players then managers then site admins
  // This will be configurable
  json.players.forEach(addCard);
  json.managers.forEach(addCard);
  json.site_admins.forEach(addCard);
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
  populateUsers();
});

