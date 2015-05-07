
  var d = document._currentScript.ownerDocument.querySelector('div');
  chai.assert.ok(document._currentScript);
  chai.assert.equal(d.innerHTML, 'me', '_currentScript can locate element in import')
