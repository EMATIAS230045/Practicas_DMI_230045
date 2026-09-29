from pathlib import Path

html_path = Path("architecture-diagram.html")
html = html_path.read_text(encoding="utf-8")
revision = "3059803afb60394d1abc791bee023a5c292818b5"
html = html.replace(f"/blob/{revision}/", "/blob/main/")
html = html.replace(f"/tree/{revision}", "/tree/main")

style = r"""
.github-direct-link {
  display: inline-flex; align-items: center; gap: .45rem; width: fit-content;
  margin-top: .55rem; padding: .52rem .72rem; border: 1px solid var(--backend-stroke);
  border-radius: .55rem; color: var(--backend-stroke); font-weight: 750;
  text-decoration: none; background: var(--panel-bg, transparent);
}
.github-direct-link:hover, .github-direct-link:focus-visible {
  color: var(--text-primary); background: var(--toolbar-hover); outline-offset: 3px;
}
.github-path-hint { display:block; color:var(--text-muted); font: .76rem/1.4 ui-monospace,monospace; margin-top:.3rem; overflow-wrap:anywhere; }
"""
html = html.replace("</style>", style + "\n</style>", 1)

script = r"""
<script>
(() => {
  const base = 'https://github.com/EMATIAS230045/Practicas_DMI_230045';
  const project = 'Practica02/hello_world_app';
  const targets = {
    project: ['', 'carpeta'],
    manifest: ['pubspec.yaml', 'archivo'],
    libdir: ['lib', 'carpeta'],
    main: ['lib/main.dart', 'archivo'],
    functions: ['lib/presentation/screens/counters/counter_functions_screen.dart', 'archivo'],
    counter: ['lib/presentation/screens/counters/counter_screen.dart', 'archivo'],
    button: ['lib/presentation/screens/counters/counter_functions_screen.dart', 'archivo'],
    deps: ['pubspec.yaml', 'archivo'],
    android: ['android', 'carpeta'],
    ios: ['ios', 'carpeta'],
    web: ['web', 'carpeta'],
    windows: ['windows', 'carpeta'],
    macos: ['macos', 'carpeta'],
    linux: ['linux', 'carpeta']
  };
  const focus = document.getElementById('focus-id');
  const links = document.getElementById('focus-evidence-links');
  if (!focus || !links) return;
  const refresh = () => {
    const id = focus.textContent.trim();
    const target = targets[id];
    let anchor = document.getElementById('github-direct-link');
    let hint = document.getElementById('github-path-hint');
    if (!target) { anchor?.remove(); hint?.remove(); return; }
    if (!anchor) {
      anchor = document.createElement('a');
      anchor.id = 'github-direct-link';
      anchor.className = 'github-direct-link';
      anchor.target = '_blank';
      anchor.rel = 'noopener noreferrer';
      anchor.innerHTML = '<span>Abrir ubicación en GitHub</span><span aria-hidden="true">↗</span>';
      links.append(anchor);
    }
    if (!hint) {
      hint = document.createElement('code');
      hint.id = 'github-path-hint';
      hint.className = 'github-path-hint';
      hint.setAttribute('aria-live', 'polite');
      links.append(hint);
    }
    const [path, kind] = target;
    const branch = kind === 'archivo' ? 'blob' : 'tree';
    anchor.href = `${base}/${branch}/main/${project}${path ? `/${path}` : ''}`;
    anchor.setAttribute('aria-label', `Abrir ${kind} ${path || project} en GitHub`);
    hint.textContent = `${path ? `${project}/${path}` : project}${kind === 'carpeta' ? '/' : ''}`;
  };
  new MutationObserver(refresh).observe(focus, { childList: true, characterData: true, subtree: true });
  refresh();
})();
</script>
"""
html = html.replace("</body>", script + "\n</body>")
html_path.write_text(html, encoding="utf-8")
