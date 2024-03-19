import 'jquery';
let VISITOR_ID;
let SENT_START = false;

document.onvisibilitychange = function() {
  if (document.visibilityState == "visible" && SENT_START)
    return;

  let timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  let time = Date.now();
  SERVER.send('visitor-track', { 'visitor_id': VISITOR_ID, 'time_zone': timeZone, 'end_time': time });
};

document.addEventListener('DOMContentLoaded', function() {
  VISITOR_ID = UTIL.getMetaData('visit-id');

  let timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  let time = Date.now();
  SERVER.send('visitor-track', { 'visitor_id': VISITOR_ID, 'time_zone': timeZone, 'start_time': time })
    .then(() => { SENT_START = true; });
});

