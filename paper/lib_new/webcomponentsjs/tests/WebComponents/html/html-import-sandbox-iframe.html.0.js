
			window.addEventListener('HTMLImportsLoaded', function() {
				parent.postMessage({
					type: 'test',
					data: document.querySelector('link[rel=import]').content.querySelector('body').innerHTML
				}, '*');
			});
		