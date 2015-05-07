
    XFoo = register('x-foo', '', HTMLElement.prototype, ['x-foo']);
    XBar = register('x-bar', 'x-foo', XFoo.prototype, ['x-foo', 'x-bar']);
    XBar2 = register('x-bar2', 'x-foo', XFoo.prototype, ['x-foo']);
    XZot = register('x-zot', 'x-bar', XBar.prototype, ['x-foo', 'x-bar', 'x-zot']);
    XZim = register('x-zim', 'x-zot', XZot.prototype, ['x-foo', 'x-bar', 'x-zot', 'x-zim']);
    XZim2 = register('x-zim2', 'x-zot', XZot.prototype, ['x-foo', 'x-bar', 'x-zot', 'x-zim2']);
    register('x-scope', '', HTMLElement.prototype, ['x-scope']);
    register('x-button', 'button', HTMLButtonElement.prototype, ['x-button']);
    register('x-anchor', 'a', HTMLAnchorElement.prototype, ['x-anchor']);
  