let BUTTON_VIEWS = {};

let POP_ELEMS = {};

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

  for (const [name, jq] of Object.entries(POP_ELEMS))
    jq.html(json[name]);

  // POP_ELEMS.total.html(json['total']);
  // POP_ELEMS.avgw.html(json['avgw']);
  // POP_ELEMS.avgm.html(json['avgm']);
  // POP_ELEMS.avgy.html(json['avgy']);
  // POP_ELEMS.pastw.html(json['pastw']);
  // POP_ELEMS.pastm.html(json['pastm']);
  // POP_ELEMS.pasty.html(json['pasty']);
}

async function populateUsers() {
  const response = await SERVER.fetch('get-users');
  const json = await response.json();

  let userCard = $('template.user-card').contents()[1];
  let idxCard = 0;

  function addCard(user) {
    let card = $(userCard).clone();
    card.attr('id', 'user-' + user.id);

    const index = idxCard;
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

    card.find('.email').text(user.email);
    let inpName = card.find('[name="name"]');
    inpName.val(user.name);
    let inpEmail = card.find('[name="email"]');
    inpEmail.val(user.email);

    let roleList = card.find('.role-list span');
    user.roles.forEach(function(role, idx) {
      let tickbox = card.find('input:checkbox[name="' + role + '"]');

      let text = roleList.text();
      if (idx != 0)
        text += " | ";
      roleList.text(text + role);

      if (tickbox) {
        tickbox.prop('checked', true);
      }
    });

    card.find('button.save').on('click', function() {
      let name = inpName.val();
      let email = inpEmail.val();
      SERVER.send('update-user', { 'id': user.id, 'name': name, 'email': email });
    });

    USER_CARDS.append(card);
    idxCard++;
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
  const k_popularity = $('#gnrl-popularity');
  POP_ELEMS = {
    'total': k_popularity.find('.total p'),
    'pastw': k_popularity.find('.pastw .value'),
    'pastm': k_popularity.find('.pastm .value'),
    'pasty': k_popularity.find('.pasty .value'),
    'avgw': k_popularity.find('.avgw .value'),
    'avgm': k_popularity.find('.avgm .value'),
    'avgy': k_popularity.find('.avgy .value'),
  };

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

  // TODO: some sort of reload button
  // updatePopularity();
  populateUsers();
});

