
(function() {
  var prototype = Object.create(HTMLElement.prototype);

  prototype.createdCallback = function() {
    this.isCreated = true;
  }

  document.registerElement('x-foo', {prototype: prototype});
})();
