
        Polymer('my-child-element', {
          publish: { 
            camelCase: {value: 0, reflect: true},
            lowercase: {value: 0, reflect: true}
          },
          // Make this a no-op, so we can verify the initial
          // reflectPropertyToAttribute works.
          observeAttributeProperty: function(name) { }
        });
      