const syncButton = document.getElementById('sync-fixtures-button');
if(syncButton) {
  syncButton.addEventListener('click', function() {
    syncButton.innerText = 'Loading Fixtures, Please Wait...';
  });
}

const leagueTableButton = document.getElementById('league-table-button');
if(leagueTableButton) {
  leagueTableButton.addEventListener('click', function() {
    leagueTableButton.innerText = 'Loading League Table, Please Wait...';
  });
}
