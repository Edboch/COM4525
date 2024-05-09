document.addEventListener('DOMContentLoaded', function() {
  let EDIT_TEAM = UTIL.jsonDup(TEAM);

  const checkChange = function() {
    let changesMade = JSON.stringify(TEAM) === JSON.stringify(EDIT_TEAM);

    $('button.save, button.revert').prop('disabled', changesMade);
  };

  UTIL.wireupLiveSearch(
    'new-owner',
    function(container, user) {
      if (user.id === EDIT_TEAM.owner.id)
        return;

      return UTIL.createLiveSearchEntry(container, user);
    });

  $('button.set-owner').on('click', function() {
    let ownerSearch = $('.live-search-new-owner');
    let name = ownerSearch.domData('name');
    if (name === undefined)
      return;

    EDIT_TEAM.owner.id = ownerSearch.domData('id');
    EDIT_TEAM.owner.name = name;
    EDIT_TEAM.owner.email = ownerSearch.domData('email');

    $('#owner span').text(name);
    ownerSearch.find('input').val('');

    checkChange();
  });

  UTIL.wireupLiveSearch(
    'new-member',
    function(container, user) {
      if (user.id in EDIT_TEAM.members)
        return;

      return UTIL.createLiveSearchEntry(container, user);
    });

  UTIL.wireupLiveSearch('new-member-roles', ADMIN.createRoleSearchEntry);

  const onClickDeleteMember = function() {
    let dom_member = $(this).parents('.tc-member');
    let id = dom_member.domData('id');

    delete EDIT_TEAM.members[id];
    dom_member.remove();

    checkChange();
  };

  const onClickDeleteRole = function() {
    let dom_role = $(this).parent('.team-role');
    let dom_member = $(this).parents('.tc-member');

    let roleID = dom_role.domData('role-id');
    let memberID = dom_member.domData('id');

    EDIT_TEAM.members[memberID].roles.remove(roleID);

    let roles = dom_member.domData('role-ids');
    roles.remove(roleID);
    dom_member.domData('role-ids', roles);

    dom_roles.remove();

    checkChange();
  };

  UTIL.wireupPillFoldout($('#members-block'), '.pill-foldout', 'button');

  $('.tcm-delete').on('click', onClickDeleteMember);

  $('.tcm-roles .tr-remove').on('click.team-role', onClickDeleteRole);

  $('#add-member .add').on('click', function() {
    let dom_member = $('.live-search-new-member');
    let dom_roles = $('.live-search-new-member-roles');

    let roles = dom_roles.domData('roles');
    if (roles.length == 0)
      return;

    let id = dom_member.domData('id');
    let member = {
      name: dom_member.domData('name'),
      email: dom_member.domData('email'),
      roles: dom_roles.domData('roles')
    };

    EDIT_TEAM.members[id] = member;

    dom_member.find('input').val('');
    dom_roles.find('input').val('');
    dom_roles.domData('roles', []);
    dom_roles.siblings('.roles-selected').empty();

    let memberSlot = UTIL.fromTemplate('.member');
    memberSlot.domData('id', id);
    memberSlot.domData('role-ids', roles);

    memberSlot.find('.tcm-name span').text(member.name);

    let roleNames = [];
    let rolesBlock = memberSlot.find('.tcm-body .tcm-roles');

    for (let roleID of member.roles) {
      let roleSlot = UTIL.fromTemplate('.role');
      let role = LIVE_SEARCH.team_roles.find(tr => tr.id === roleID);
      if (role === undefined)
        continue;

      roleSlot.domData('role-id', role.id);
      roleSlot.find('.re-name').text(role.name);
      roleSlot.find('.re-type').text(role.type);
      rolesBlock.append(roleSlot);

      roleNames.push(role.name);
    }

    let pill = memberSlot.find('.tcm-pill');
    pill.find('.tcm-roles span').text(roleNames.join(' | '));

    $('#members-block').append(memberSlot);
    UTIL.wireupPillFoldout($('#members-block'), '.pill-foldout', 'button');

    checkChange();
  });

  $('button.revert').on('click', () => location.reload());

  $('button.save').on('click', async function() {
    let url = $(this).domData('href');
    const response = await SERVER.sendJsonUrl(url, { team: EDIT_TEAM });
    if (!response.ok) {
      return;
    }

    TEAM = UTIL.jsonDup(EDIT_TEAM);
  });
});
