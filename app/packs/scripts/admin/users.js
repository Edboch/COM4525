document.addEventListener('DOMContentLoaded', function() {
  let EDIT_USER = JSON.parse(JSON.stringify(USER));

  const checkChange = function() {
    let changesMade = JSON.stringify(USER) === JSON.stringify(EDIT_USER);

    $('button.save, button.revert').prop('disabled', changesMade);
  }

  const onLeaveTeamClick = function() {
    let dom_team = $(this).parent();
    let id = dom_team.domData('id');

    delete EDIT_USER.teams[id];
    dom_team.remove();

    checkChange();
  }

  UTIL.wireupLiveSearch(
    'new-team',
    function(container, team) {
      if (team.id in EDIT_USER.teams)
        return;

      return UTIL.createLiveSearchEntry(container, team);
    });

  UTIL.wireupLiveSearch('new-team-roles', ADMIN.createRoleSearchEntry);

  $('#add-team .add').on('click', function() {
    let dom_team = $('.live-search-new-team');
    let dom_roles = $('.live-search-new-team-roles');

    let roles = dom_roles.domData('roles');
    if (roles.length == 0)
      return;

    let id = dom_team.domData('id');
    let team = {
      name: dom_team.domData('name'),
      location_name: dom_team.domData('location-name'),
      roles: roles
    };

    EDIT_USER.teams[id] = team;

    dom_team.find('input').val('');
    dom_roles.find('input').val('');
    dom_roles.siblings('.roles-selected').empty();

    let teamSlot = UTIL.fromTemplate('.team');
    teamSlot.domData('id', id);
    teamSlot.find('.team-name').text(team.name);
    teamSlot.find('.team-location').text(team.location_name);
    teamSlot.find('.leave').on('click', onLeaveTeamClick);

    $('#teams-block').append(teamSlot);
    checkChange();
  });

  $('.au-team .leave').on('click', onLeaveTeamClick);

  $('input[name="usr-name"]').on('input', function() {
    let value = $(this).val();
    EDIT_USER.name = value;

    checkChange();
  });

  $('input[name="usr-email"]').on('input', function() {
    let value = $(this).val();
    EDIT_USER.email = value;

    checkChange();
  });

  $('input[name="usr-admin"]').on('change', function() {
    let value = $(this).val();
    EDIT_USER.isAdmin = value;

    checkChange();
  });
});
