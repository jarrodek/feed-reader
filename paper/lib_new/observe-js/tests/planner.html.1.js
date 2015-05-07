
"use strict";

suite('Planner Tests', function() {
	var planner;
	setup(function() {
		planner = new Planner();
	});

  teardown(function() {
    planner = undefined;
  });

  function addVariable(priority) {
    return planner.addVariable(function() {
      return priority;
    });
  }

  function bind(prop1, prop2) {
    var c = planner.addConstraint();
    return {
      constraint: c,
      to: c.addMethod(prop2),
      from: c.addMethod(prop1)
    };
  }

  test('Linear', function() {
    var a = addVariable(0);
    var b = addVariable(1);
    var c = addVariable(1);

    var aToB = bind(a, b);
    var bToC = bind(b, c);

    assert.deepEqual(planner.getPlan(), [aToB.to, bToC.to]);
  });

  test('Linear Reverse Priority', function() {
    var a = addVariable(1);
    var b = addVariable(1);
    var c = addVariable(0);

    var aToB = bind(a, b);
    var bToC = bind(b, c);

    assert.deepEqual(planner.getPlan(), [bToC.from, aToB.from]);
  });

  test('Overconstrained', function() {
    var a = addVariable(1);
    var b = addVariable(1);
    var c = addVariable(0);

    var aToB = bind(a, b);
    var bToC = bind(b, c);
    var cToA = bind(c, a);

    assert.isUndefined(planner.getPlan());
  });

  test('Remove Constraint', function() {
    var a = addVariable(1);
    var b = addVariable(1);
    var c = addVariable(0);

    var aToB = bind(a, b);
    var bToC = bind(b, c);
    var cToA = bind(c, a);

    assert.isUndefined(planner.getPlan());

    planner.removeConstraint(bToC.constraint);
    assert.deepEqual(planner.getPlan(), [cToA.to, aToB.to]);

    planner.removeConstraint(aToB.constraint);
    assert.deepEqual(planner.getPlan(), [cToA.to]);
  });

  test('Stress', function() {
    var count = 10000;
    var variable = addVariable(count);

    while (count-- > 0) {
      var newVar = addVariable(count);
      bind(variable, newVar);
      variable = newVar;
    }

    console.time('Plan');
    planner.getPlan();
    console.timeEnd('Plan');
  });
});

