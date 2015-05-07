
  var d = document._currentScript.ownerDocument.querySelector('div');
  chai.assert.equal(d.innerText, 'me2', '_currentScript can locate element in import')
