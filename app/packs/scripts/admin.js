const { map } = require("jquery");

let BUTTON_VIEWS = {};

let POP_ELEMS = {};
let DATE_RANGES = {};

let USER_CARDS;

let IDX_OPEN_CARD = -1;

const Q_CONTROL_BUTTON = '#control-panel > button';

const GENERATED_PASSWORD_LENGTH = 8;

// TODO Email format validation

/**
 * Checks the tickboxes of the roles in the passed in parent
 * Returns a string with a character for each role ticked
 */
function getRoles(parent) {
  let roles = '';
  if (parent.find('[name="site-admin"]').prop('checked'))
    roles += 's';
  return roles;
}

/**
 * Wires up the functionality of the date range feature
 */
function setupDateRange() {
  const popRange = $('#gnrl-pop-range');
  let start = popRange.find('[name="start-date"]');
  let end = popRange.find('[name="end-date"]');
  let btnSend = popRange.find('button.send');
  let output = popRange.find('.output');

  start.on('change', function() {
    let strValue = $(this).val();
    let valDate = Date.parse(strValue);
    let endDate = Date.parse(end.val());

    end.attr('min', strValue);
    if (valDate > endDate)
      end.val(strValue);
  });
  end.on('change', function() {
    let strValue = $(this).val();
    let valDate = Date.parse(strValue);
    let startDate = Date.parse(start.val());

    start.attr('max', strValue);
    if (valDate < startDate)
      start.val(strValue);
  });

  btnSend.on('click', async function() {
    let strStart = start.val();
    let strEnd = end.val();

    let quit = false;
    if (strStart === '') {
      console.error('Start Date is empty');
      quit = true;
    }
    if (strEnd === '') {
      console.error('End Date is empty');
      quit = true;
    }

    if (quit) return;

    let dateStart = Date.parse(strStart);
    let dateEnd = Date.parse(strEnd);
    if (dateStart > dateEnd) {
      console.error('Start Date is later than End Date');
      return;
    }

    const timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    const response = await SERVER.send(
      'pop-date-range',
      { 'start': dateStart, 'end': dateEnd, 'time_zone': timeZone }
    );
    const json = await response.json();

    output.html(json.total);
  });
}

async function setupPopularityView() {
  /**
    * Pulls popularity data from the database and uses it to fill
    * the appropriate fields to the refresh button
    */
  $('#gnrl-popularity button.refr').on('click', async function() {
    const response = await SERVER.fetch('popularity');
    const json = await response.json();

    for (const [name, jq] of Object.entries(POP_ELEMS))
      jq.html(json[name]);
  });

  setupDateRange();
}

/**
 * Wires up the functionality of the create new user dialogue box
 */
async function wireUpCreateNewUser() {
  const domNewUser = $('#new-user');
  let inp_password = domNewUser.find('[name="password"]');

  // Generates a random string for the password
  domNewUser.find('#new-user-regen-pw').on('click', function() {
    let generated = '';
    for (let i = 0; i < GENERATED_PASSWORD_LENGTH; i++) {
      if (Math.random() < 0.5) {
        let ascii = 97 + Math.floor(Math.random() * 26);
        generated += String.fromCharCode(ascii);
      }
      else {
        let number = Math.floor(Math.random() * 10);
        generated += number.toString();
      }
    }

    inp_password.val(generated);
  });

  let inp_name = domNewUser.find('[name="name"]');
  let inp_email = domNewUser.find('[name="email"]');
  let inp_admin = domNewUser.find('[name="site-admin"]');

  domNewUser.find('#new-user-submit').on('click', async function() {
    // Checks to see the name, email and password fields are not empty
    if (inp_name.val() === '') {
      console.error('NEW USER No name provided');
      return;
    }
    if (inp_email.val() === '') {
      console.error('NEW USER No email provided');
      return;
    }
    if (inp_password.val() === '') {
      console.error('NEW USER No password provided');
      return;
    }

    const response = await SERVER.send('new-user', {
      name: inp_name.val(), email: inp_email.val(),
      password: inp_password.val(), site_admin: inp_admin.prop('checked')
    });

    // TODO Update the page with the new user

    inp_name.val('');
    inp_email.val('');
    inp_password.val('');
    inp_admin.prop('checked', false);
  });
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
  UTIL.wireupPillFoldout($('.user-list'), '.user-card', 'input, button');
  USER_CARDS.children().each(function() {
    let card = $(this);
    const index = idxCard; // Necessary due to closures

    let id = card.attr('id').split('-')[2];
    let inp_name = card.find('[name="name"]');
    let inp_email = card.find('[name="email"]');
    let inp_admin = card.find('[name="site-admin"]');

    card.find('button.pwreset').on('click', function() {
      // TODO: Reset password
    });

    card.find('button.save').on('click', function() {
      let name = inp_name.val();
      let email = inp_email.val();
      // TODO 'Are you sure' alert if a role change is detected
      // If site admin is changed also ask for password confirmation
      let admin = inp_admin.prop('checked');

      let url = $(this).domData('url');
      SERVER.sendUrl(url, { name: name, email: email, site_admin: admin });
    });

    card.find('button.remove').on('click',function(){
      let name = inp_name.val();
      let email = inp_email.val();
      let url = $(this).domData('url');
      SERVER.sendUrl(url, { 'id': id, 'name': name, 'email': email });
    })

    idxCard++;
  });
}

/**
 * Wires up the functionality of the teams view
 *
 * Enabling the pills to fold in and out
 * Wiring up the search bars with a live dropdown feature, as well as
 * defining the entry generation functions
 */
function wireupTeamsView() {
  let teams = $('.teams-list');
  UTIL.wireupPillFoldout(
    teams, '.team-card', 'input, button, .live-search, .tc-new-member .role-list, .tc-member',
    jq_pill => jq_pill.find('.live-search-dropdown').empty()
  );

  UTIL.wireupPillFoldout(
    $('.tc-member-list'), '.tc-member', 'input, button, .live-search',
    jq_pill => jq_pill.find('.live-search-dropdown').empty()
  );

  UTIL.wireupLiveSearch(
    'owner',
    function(container, user) {
      let currentOwnerID = parseInt(container.domData('owner-id'));
      if (user.id == currentOwnerID)
        return;

      return UTIL.createLiveSearchEntry(container, user);
    });

  $('button.tc-save').on('click', async function() {
    let body = $(this).parent('.tc-body');

    let name = body.find('input[name="team-name"]').val();
    let location = body.find('input[name="team-location"]').val();
    let owner = body.find('.live-search-owner').domData('id');

    let url = body.parent('.team-card').domData('url');
    const response = await SERVER.sendUrl(url, { name: name, location_name: location, owner_id: owner });
  });
}

async function wireUpCreateNewTeam() {
  const domNewTeam = $('#new-team');
  let inp_teamname = domNewTeam.find('[name="team_name"]');
  let inp_location = domNewTeam.find('[name="location_name"]');
  let inp_owneremail = domNewTeam.find('[name="live-search-first-owner"]');

  domNewTeam.find('#new-team-submit').on('click', async function() {
    if (inp_teamname.val() === '') {
      console.error('NEW TEAM No team name provided');
      return;
    }
    if (inp_location.val() === '') {
      console.error('NEW TEAM No location name provided');
      return;
    }
    if (inp_owneremail.val() === '') {
      console.error("NEW TEAM Manager's email not provided");
      return;
    }
    const response = await SERVER.send('new-team', {
      team_name: inp_teamname.val(), location_name: inp_location.val(), owner_email: inp_owneremail.val()
    });
    inp_teamname.val('');
    inp_location.val('');
    inp_owneremail.val('');
    
  });

  UTIL.wireupLiveSearch(
    'first-owner',
    function(container, user) {
      let entry = UTIL.createLiveSearchEntry(container, user);
      return entry;},
    maxOptionsWhenEmpty = 0
  );
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
    total: k_popularity.find('.total p'),
    past_week: k_popularity.find('.pastw .value'),
    past_month: k_popularity.find('.pastm .value'),
    past_year: k_popularity.find('.pasty .value'),
    avg_week: k_popularity.find('.avgw .value'),
    avg_month: k_popularity.find('.avgm .value'),
    avg_year: k_popularity.find('.avgy .value'),
  };

  USER_CARDS = $('#users .user-list');

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

  wireupTeamsView();
  wireupUserCards();
  setupPopularityView();

  wireUpCreateNewUser();
  wireUpCreateNewTeam();
});

