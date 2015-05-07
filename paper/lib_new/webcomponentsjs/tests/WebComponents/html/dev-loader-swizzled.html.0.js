
      chai.assert(window.WebComponents, 'Platform scope missing');
      chai.assert.equal(WebComponents.flags.squid, 'never', '"squid" flag missing');
      chai.assert(WebComponents.flags.spoo, '"spoo" flag missing');
      chai.assert(WebComponents.flags.log, 'flags.log missing');
      chai.assert(WebComponents.flags.log.foo, 'flags.log.foo missing');
      chai.assert(WebComponents.flags.log.boo, 'flags.log.foo missing');
      done();
    