
    var assert = chai.assert;
    document.addEventListener('polymer-ready', function() {
      Polymer.import(['element-import/import-a.html'], function() {
        chai.assert.isTrue(document.querySelector('x-foo').isCustom);
        var dom = document.importNode(document.querySelector('template').content, true);
        Polymer.importElements(dom, function() {
          chai.assert.isTrue(document.querySelector('x-bar').isCustom);
          done();
        });
      });
    });
  