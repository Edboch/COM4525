let POP_TOTAL;
let POP_AVGM;
let POP_AVGW;

async function updatePopularity() {
  const response = await SERVER.fetch('popularity');
  // const text = await response.text();
  // console.log(text);
  const json = await response.json();

  POP_TOTAL.html(json['total']);
  POP_AVGM.html(json['avgm']);
  POP_AVGW.html(json['avgw']);
}

document.addEventListener('DOMContentLoaded', function() {
  POP_TOTAL = $('#gnrl-popularity .total .value');
  POP_AVGM = $('#gnrl-popularity .avgm .value');
  POP_AVGW = $('#gnrl-popularity .avgw .value');

  updatePopularity();
});

