
      chai.assert(window.WebComponents, 'WebComponents scope missing');
      chai.assert.equal(WebComponents.flags.shadow, true, 'improper "shadow" flag');
      chai.assert(window.ShadowDOMPolyfill, 'ShadowDOMPolyfill missing');
      done();
    