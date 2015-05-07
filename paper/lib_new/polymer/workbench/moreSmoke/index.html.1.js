
      Polymer('x-foo', {
        me: 'foo',
        // you is published, can be changed via attribute (markup or binding)
        you: '?',
        color: 'tomato',
        ready: function() {
          this.colorChanged();
        },
        colorChanged: function() {
          this.style.backgroundColor = this.color;
        },
        meClicked: function(event, details, sender) {
          twiddleFont(sender);
          event.stopPropagation();
        },
        youClicked: function(event, details, sender) {
          twiddleFont(sender);
          event.stopPropagation();
        },
        clicked: function(event, details, sender) {
          this.$.me.style.fontSize = '';
          this.$.you.style.fontSize = '';
        }
      });
    