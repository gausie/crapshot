function parseQs(input) {
  return input.split('&').reduce((acc, param) => {
    let [key, value] = param.replace(/\+/g, ' ').split('=');
    value = value === undefined ? null : value;

    internalKey = /\[(\w*)\]$/.exec(key);
    key = key.replace(/\[\w*\]$/, '');

    if (!internalKey) {
      acc[key] = value;
      return acc;
    }

    if (!acc[key]) acc[key] = {};

    acc[key][internalKey[1]] = value;
    return acc;
  }, {});
}

function createElement(type, content) {
  const el = document.createElement(type);
  if (!content) return el;
  if (typeof content === 'string') {
    el.innerHTML = content;
  } else {
    el.appendChild(content);
  }
  return el;
}

function renderSkills(snapshot) {
  const table = document.createElement('table');

  let tr;

  snapshot.skills.split('|').forEach((value, i) => {
    if (i % 6 == 0) {
      tr = document.createElement('tr');
      table.appendChild(tr);
    }

    const skill = data.skills[i + 1];
    if (!skill) return;

    const td = document.createElement('td');
    switch (value) {
      case '1':
        td.classList.add('p'); break;
      case '2':
        td.classList.add('hp'); break;
    }

    const name = createElement('div', skill.itemname);
    const desc = createElement('div', skill.gifname !== 'none' && skill.gifname);

    td.appendChild(name);
    td.appendChild(desc);
    tr.appendChild(td);
  });

  return table;
}

function renderTattoos(snapshot) {
  const outfitTable = document.createElement('table');
  const tattooTable = document.createElement('table');
  let table = outfitTable;
  let tr;

  const numOutfits = Object.keys(data.outfits).length;
  const outfits = Object.entries(data.outfits);
  const tattoos = Object.entries(data.tattoos);

  snapshot.tattoos.split('|').forEach((value, i) => {
    if (i == numOutfits) table = tattooTable;

    if (i % 6 == 0) {
      tr = document.createElement('tr');
      table.appendChild(tr);
    }

    const tat = i < numOutfits ? outfits[i] : tattoos[i - numOutfits];
    if (!tat) return;
    const [name, image] = tat;

    const td = document.createElement('td');

    switch (value) {
      case '': break;
      case '0':
        td.classList.add('p'); break;
      default:
        td.classList.add('hp'); break;
    }

    const suffix = Number(value) > 1 ? value : '';

    console.log(suffix);

    const n = createElement('div', name);
    const img = createElement('img');
    img.src = '/images/otherimages/sigils/' + image + suffix + '.gif';

    td.appendChild(n);
    td.appendChild(img);
    tr.appendChild(td);
  });

  const container = document.createElement('div');
  container.appendChild(createElement('h3', 'Outfits'));
  container.appendChild(outfitTable);
  container.appendChild(createElement('h3', 'Other'));
  container.appendChild(tattooTable);
  return container;
}

window.addEventListener('load', () => {
  const el = document.getElementById('crapshot');

  const snapshot = parseQs(snapshot_qs);

  el.appendChild(createElement('h2', 'Skills'));
  el.appendChild(renderSkills(snapshot));

  el.appendChild(createElement('h2', 'Tattoos'));
  el.appendChild(renderTattoos(snapshot));
});
