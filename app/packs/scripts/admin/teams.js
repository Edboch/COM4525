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

    checkChange();
  });

  UTIL.wireupLiveSearch(
    'new-member',
    function(container, user) {
      if (user.id in EDIT_USER.members)
        return;

      return UTIL.createLiveSearchEntry(container, user);
    });

  UTIL.wireupLiveSearch('new-member-roles', ADMIN.createRoleSearchEntry);



  const onClickDeleteMember = function() {
    let dom_member = $(this).parent('.tc-member');
    let id = dom_member.domData('id');

    delete EDIT_TEAM.members[id];
    dom_member.remove();

    checkChange();
  };

  UTIL.wireupPillFoldout($('#members-block'), '.pill-foldout', 'button');

  $('.tcm-delete').on('click', onClickDeleteMember);

  // $('.tr-remove').off('click.team-role');


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
      roles: dom_member.domData('roles')
    };

    EDIT_USER.members[id] = member;

    dom_member.find('input').val('');
    dom_roles.find('input').val('');
    dom_roles.siblings('.roles-selected').empty();

    let memberSlot = UTIL.fromTemplate('.member');
    memberSlot.domData('id', id);
    memberSlot.domData('role-ids', roles);

    let pill = memberSlot.find('.tcm-pill');
    pill.find('.tcm-name span').text(member.name);
    pill.find('.tcm-roles span').text(member.roles);

  });

  
});
