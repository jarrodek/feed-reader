
      Polymer('x-baz', {
        cheese: [{name: "Gouda"}, {name: "Cheddar"}, {name: "Brie"}, {name: "Mozzarella"}],
        nameAction: function(event, detail, sender) {
          twiddleFont(sender);
        }
      });
    