
      Polymer('x-extendor', {
        ready: function() {
          this.extendedIsReadied = true;
          this.super();
        },
        attached: function() {
          this.extendedIsInserted = true;
          this.super();
        },
        detached: function() {
          this.extendedIsRemoved = true;
          this.super();
        },
        attributeChanged: function() {
          this.extendedHasAttributeChanged = true;
          this.super();
        }
      });
    