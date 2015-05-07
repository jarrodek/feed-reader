
			window.addEventListener('message', function(e) {
				if (e.data.type === 'test') {
					chai.assert.equal(e.data.data, 'hello!');
					done();
				} else {
					e.source.postMessage({
						url: e.data.url,
						err: 0,
						resource: 'hello!'
					}, '*');
				}
			});
		