
      Polymer('x-base', {
        ready: function() {
          this.isReadied = true;
        },
        attached: function() {
          this.isInserted = true;
        },
        detached: function() {
          this.isRemoved = true;
        },
        attributeChanged: function() {
          this.hasAttributeChanged = true;
        }
      });
    