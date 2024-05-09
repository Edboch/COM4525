document.addEventListener('DOMContentLoaded', function() {
  let EDIT_USER = JSON.parse(JSON.stringify(USER));

  const checkChange = function() {
    let changesMade = JSON.stringify(USER) === JSON.stringify(EDIT_USER);

    $('button.save, button.revert').prop('disabled', changesMade);
  };

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
    EDIT_USER.is_admin = value;

    checkChange();
  });

  UTIL.wireupLiveSearch(
    'team-role',
    function(container, tr) {
      let roles = container.domData('roles');
      if (roles.includes(tr.id))
        return;

      const teamRoleID = tr.id;
      const teamID = container.domData('team-id');

      let entry = UTIL.createLiveSearchEntry(container, tr);
      entry.on('click', function() {
        EDIT_USER.teams[teamID].roles.push(teamRoleID);

        let roleEntry = UTIL.fromTemplate('.role');
        roleEntry.find('.re-name').text(tr.name);
        roleEntry.find('.re-type').text(tr.type);
        let rolesContainer = container.siblings('.roles');
        rolesContainer.append(roleEntry);

        checkChange();
      });
      return entry;
    });

  $('button.revert').on('click', () => location.reload());

  $('button.save').on('click', async function() {
    // I think the fact that the keys in the teams field is causing issues
    // on the server side
    let siteUser = JSON.parse(JSON.stringify(EDIT_USER));
    siteUser.teams = [];
    for (let tID in EDIT_USER.teams) {
      let team = structuredClone(EDIT_USER.teams[tID]);
      team.id = tID;
      siteUser.teams.push(team);
    }

    let url = $(this).domData('href');
    const response = await SERVER.sendJsonUrl(url, siteUser);
    if (!response.ok) {
      // TODO: Some error message
      return;
    }

    USER = JSON.parse(JSON.stringify(EDIT_USER));
  });
});
