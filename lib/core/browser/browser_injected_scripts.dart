/// Scripts injected into the in-app browser for editor-friendly shortcuts.
abstract final class BrowserInjectedScripts {
  /// Keep window.open / target=_blank in the same tab. Related WebKit views
  /// share a process with the parent and have crashed the Linux companion
  /// window when YouTube opens a watch URL.
  static const sameWindowNavigation = r'''
(function () {
  if (window.__gizeCareSameWindowNav) return;
  window.__gizeCareSameWindowNav = true;

  try {
    window.open = function (url) {
      if (url && url !== 'about:blank') {
        window.location.assign(url);
      }
      return null;
    };
  } catch (_) {}

  document.addEventListener('click', function (e) {
    var a = e.target && e.target.closest ? e.target.closest('a[href]') : null;
    if (!a) return;
    var target = (a.getAttribute('target') || '').toLowerCase();
    if (target === '_blank' || target === '_new') {
      a.removeAttribute('target');
      a.removeAttribute('rel');
    }
  }, true);
})();
''';

  /// Ctrl/Cmd+Enter inserts a newline in text fields and contenteditable
  /// composers (WhatsApp Web, notes-style fields, etc.). Capture-phase so it
  /// runs before the page's "send on Enter" handlers consume the key.
  static const ctrlEnterNewline = r'''
(function () {
  if (window.__gizeCareCtrlEnterNewline) return;
  window.__gizeCareCtrlEnterNewline = true;

  function editableRoot(node) {
    var n = node;
    while (n && n !== document.documentElement) {
      if (n.nodeType === 1) {
        if (n.isContentEditable) return n;
        var tag = (n.tagName || '').toLowerCase();
        if (tag === 'textarea') return n;
        if (tag === 'input') {
          var t = (n.type || 'text').toLowerCase();
          if (t === 'text' || t === 'search' || t === 'url' ||
              t === 'tel' || t === 'password' || t === 'email' || t === '') {
            return n;
          }
        }
      }
      n = n.parentNode || (n.getRootNode && n.getRootNode().host) || null;
    }
    return null;
  }

  function insertNewline(el) {
    if (el.isContentEditable) {
      if (document.execCommand) {
        document.execCommand('insertLineBreak');
      } else {
        document.execCommand('insertText', false, '\n');
      }
      el.dispatchEvent(new InputEvent('input', { bubbles: true, inputType: 'insertLineBreak' }));
      return;
    }
    if (typeof el.selectionStart === 'number') {
      var start = el.selectionStart;
      var end = el.selectionEnd;
      var value = el.value || '';
      el.value = value.slice(0, start) + '\n' + value.slice(end);
      el.selectionStart = el.selectionEnd = start + 1;
      el.dispatchEvent(new Event('input', { bubbles: true }));
    }
  }

  document.addEventListener('keydown', function (e) {
    if (e.defaultPrevented) return;
    if (!(e.ctrlKey || e.metaKey) || e.altKey) return;
    if (e.key !== 'Enter' && e.keyCode !== 13) return;
    var el = editableRoot(e.target);
    if (!el) return;
    e.preventDefault();
    e.stopPropagation();
    if (typeof e.stopImmediatePropagation === 'function') e.stopImmediatePropagation();
    insertNewline(el);
  }, true);
})();
''';
}
