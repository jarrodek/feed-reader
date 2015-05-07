
        Polymer('x-bar', {
          publish: {
            zot: {value: 3, reflect: true},
            zim: {value: false, reflect: true},
            str: {value: 'str', reflect: true},
            obj: {reflect: true}
          }
        });
      