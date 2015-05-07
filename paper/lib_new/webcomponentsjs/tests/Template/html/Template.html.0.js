
      addEventListener('DOMContentLoaded', function() {
        var template = document.querySelector('template');
        chai.assert.equal(template.childNodes.length, 0, 'template children evacipated');
        chai.assert.isDefined(template.content, 'template content exists');
        chai.assert.equal(template.content.childNodes.length, 3, 'template content has expected number of nodes');
        var content = document.querySelector('#content');
        chai.assert.isNull(content, 'template content not in document');
        document.body.appendChild(document.importNode(template.content, true));
        content = document.querySelector('#content');
        chai.assert.isDefined(content, 'template content stamped into document');
        done();
      });
    