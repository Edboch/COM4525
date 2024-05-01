window.ADMIN = (function($) {
  let mod = {};

  mod.createRoleSearchEntry = function(container, role) {
    let selectedRoles = container.domData('roles');
    if (selectedRoles.includes(role.id))
      return;

    let entry = UTIL.createLiveSearchEntry(container, role, false);
    entry.on('click', function() {
      const roles = container.domData('roles');
      let newRoles = roles.slice(0);
      newRoles.push(role.id);
      container.domData('roles', newRoles);

      let roleList = container.siblings('.roles-selected');
      let roleEntry = $('<span></span>');
      roleEntry.text(role.name);
      roleEntry.on('click', function() {
        let roles = container.domData('roles');
        roles.remove(role.id);
        container.domData('roles', roles);
        $(this).remove();
      });

      roleList.append(roleEntry);
      container.find('input').val('');
    });

    return entry;
  };

  return mod;
}(window.$));
