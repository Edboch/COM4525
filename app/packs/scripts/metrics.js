let VISITOR_ID;
let BLOCK_VIS_SEND = false;
let DISABLE = false;

document.onvisibilitychange = function() {
  if (document.visibilityState === "visible" && BLOCK_VIS_SEND)
    return;

  if (DISABLE)
    return;

  let timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  let time = Date.now();
  SERVER.send(
    'visitor-track',
    { visitor_id: VISITOR_ID, time_zone: timeZone, end_time: time, url: window.location.href }
  );
};

document.addEventListener('DOMContentLoaded', async function() {
  VISITOR_ID = UTIL.getMetaData('visit-id');

  let timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  let time = Date.now();
  await SERVER.send(
    'visitor-track',
    { visitor_id: VISITOR_ID, time_zone: timeZone, start_time: time, url: window.location.href }
  );
  BLOCK_VIS_SEND = true;

  $("form[action='/users/sign_out'], form[action='/users/sign_in']")
    .on('submit', function(evt) {
      DISABLE = true;
  });
});

