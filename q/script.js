async function loadFiles(){
  const menu = document.getElementById('menu');
  const search = document.getElementById('search');
  const detailTitle = document.getElementById('detail-title');
  const detailDesc = document.getElementById('detail-desc');
  const valName = document.getElementById('val-name');
  const valSize = document.getElementById('val-size');
  const codeView = document.querySelector('#code-view code');
  const btnDownload = document.getElementById('btn-download');
  const btnCopy = document.getElementById('btn-copy');

  let files = [];
  let activeFile = null;
  let fileContents = {};

  try {
    const res = await fetch('files.json');
    files = await res.json();
  } catch(e) {
    console.error('Failed to load files.json', e);
  }

  function renderList(list){
    menu.innerHTML = '';
    list.forEach(name => {
      const li = document.createElement('li');
      li.className = 'qh-item';
      li.dataset.id = name;
      li.innerHTML = `<span class=\"dot\"></span><div class=\"qh-name\">${name}</div>`;
      li.addEventListener('click', () => selectFile(name));
      menu.appendChild(li);
    });
  }

  async function selectFile(name){
    activeFile = name;
    [...menu.children].forEach(el => el.classList.toggle('active', el.dataset.id === name));
    detailTitle.textContent = name;
    detailDesc.textContent = 'Loading…';
    valName.textContent = name;
    valSize.textContent = '—';

    try {
      const res = await fetch('files/' + name);
      const text = await res.text();
      fileContents[name] = text;
      detailDesc.textContent = 'File loaded.';
      codeView.textContent = text;
      valSize.textContent = text.length + ' bytes';
    } catch(e) {
      detailDesc.textContent = 'Error loading file.';
      codeView.textContent = '';
    }
  }

  btnDownload.addEventListener('click', () => {
    if(!activeFile) return;
    const link = document.createElement('a');
    link.href = 'files/' + activeFile;
    link.download = activeFile;
    document.body.appendChild(link);
    link.click();
    link.remove();
  });

  btnCopy.addEventListener('click', () => {
    const text = codeView.textContent;
    if (!text) {
      detailDesc.textContent = 'No code to copy.';
      return;
    }

    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(text)
        .then(() => detailDesc.textContent = 'Copied to clipboard.')
        .catch(() => fallbackCopy(text));
    } else {
      fallbackCopy(text);
    }

    function fallbackCopy(text) {
      const ta = document.createElement('textarea');
      ta.value = text;
      document.body.appendChild(ta);
      ta.select();
      try {
        document.execCommand('copy');
        detailDesc.textContent = 'Copied to clipboard (fallback).';
      } catch (err) {
        detailDesc.textContent = 'Failed to copy.';
        console.error('Fallback copy failed:', err);
      }
      document.body.removeChild(ta);
    }
  });

  search.addEventListener('input', e => {
    const q = e.target.value.toLowerCase();
    const filtered = files.filter(f => f.toLowerCase().includes(q));
    renderList(filtered);
  });

  renderList(files);
}

window.addEventListener('DOMContentLoaded', loadFiles);
