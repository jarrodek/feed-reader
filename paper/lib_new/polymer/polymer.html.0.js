
	(function() {
		// evacipate all scripts in parent!
		if (window.WebComponents) {
			var scripts = document._currentScript.parentNode;
			scripts.parentNode.removeChild(scripts);
		}
	})();
	