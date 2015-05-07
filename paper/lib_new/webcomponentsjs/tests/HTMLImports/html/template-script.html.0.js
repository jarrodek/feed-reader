
      addEventListener('HTMLImportsLoaded', function() {
        var link = document.querySelector('link');
        var template = link.import.querySelector('template');
        chai.assert.ok(template, 'found import template');
        var content = template.content || template;
        document.body.appendChild(content.cloneNode(true));
        chai.assert.ok(window.executedTemplateScript, 'executedTemplateScript');
        done();
      });
    