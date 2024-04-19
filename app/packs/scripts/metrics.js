import 'jquery';
let VISITOR_ID;
let SENT_START = false;

document.onvisibilitychange = function() {
  if (document.visibilityState == "visible" && SENT_START)
    return;

  let timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  let time = Date.now();
  SERVER.send(
    'visitor-track',
    { visitor_id: VISITOR_ID, time_zone: timeZone, end_time: time, url: document.url }
  );
};

document.addEventListener('DOMContentLoaded', async function() {
  VISITOR_ID = UTIL.getMetaData('visit-id');

  let timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  let time = Date.now();
  await SERVER.send(
    'visitor-track',
    { visitor_id: VISITOR_ID, time_zone: timeZone, start_time: time, url: document.url }
  );
  SENT_START = true;
});

