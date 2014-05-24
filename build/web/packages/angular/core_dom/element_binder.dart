part of angular.core.dom_internal;

class TemplateElementBinder extends ElementBinder {
  final DirectiveRef template;
  ViewFactory templateViewFactory;

  final bool hasTemplate = true;

  final ElementBinder templateBinder;

  var _directiveCache;
  List<DirectiveRef> get _usableDirectiveRefs {
    if (_directiveCache != null) return _directiveCache;
    return _directiveCache = [template];
  }

  TemplateElementBinder(perf, expando, parser, componentFactory,
                        transcludingComponentFactory, shadowDomComponentFactory,
                        this.template, this.templateBinder,
                        onEvents, bindAttrs, childMode)
      : super(perf, expando, parser, componentFactory,
          transcludingComponentFactory, shadowDomComponentFactory,
          null, null, onEvents, bindAttrs, childMode);

  String toString() => "[TemplateElementBinder template:$template]";

  _registerViewFactory(node, parentInjector, nodeModule) {
    assert(templateViewFactory != null);
    nodeModule
      ..bind(ViewPort, toFactory: (_) =>
          new ViewPort(node, parentInjector.get(Animate)))
      ..bind(ViewFactory, toValue: templateViewFactory)
      ..bind(BoundViewFactory, toFactory: (Injector injector) =>
          templateViewFactory.bind(injector));
  }
}


/**
 * ElementBinder is created by the Selector and is responsible for instantiating
 * individual directives and binding element properties.
 */
class ElementBinder {
  // DI Services
  final Profiler _perf;
  final Expando _expando;
  final Parser _parser;

  // The default component factory
  final ComponentFactory _componentFactory;
  final TranscludingComponentFactory _transcludingComponentFactory;
  final ShadowDomComponentFactory _shadowDomComponentFactory;
  final Map onEvents;
  final Map bindAttrs;

  // Member fields
  final decorators;

  final DirectiveRef component;

  // Can be either COMPILE_CHILDREN or IGNORE_CHILDREN
  final String childMode;

  ElementBinder(this._perf, this._expando, this._parser,
                this._componentFactory,
                this._transcludingComponentFactory,
                this._shadowDomComponentFactory,
                this.component, this.decorators,
                this.onEvents, this.bindAttrs, this.childMode);

  final bool hasTemplate = false;

  bool get shouldCompileChildren =>
      childMode == Directive.COMPILE_CHILDREN;

  var _directiveCache;
  List<DirectiveRef> get _usableDirectiveRefs {
    if (_directiveCache != null) return _directiveCache;
    if (component != null) return _directiveCache = new List.from(decorators)..add(component);
    return _directiveCache = decorators;
  }

  bool get hasDirectivesOrEvents =>
      _usableDirectiveRefs.isNotEmpty || onEvents.isNotEmpty;

  _bindTwoWay(tasks, expression, scope, dstPathFn, controller, formatters, dstExpression) {
    var taskId = tasks.registerTask();
    Expression expressionFn = _parser(expression);

    var viewOutbound = false;
    var viewInbound = false;
    scope.watch(expression, (inboundValue, _) {
      if (!viewInbound) {
        viewOutbound = true;
        scope.rootScope.runAsync(() => viewOutbound = false);
        var value = dstPathFn.assign(controller, inboundValue);
        tasks.completeTask(taskId);
        return value;
      }
    }, formatters: formatters);
    if (expressionFn.isAssignable) {
      scope.watch(dstExpression, (outboundValue, _) {
        if (!viewOutbound) {
          viewInbound = true;
          scope.rootScope.runAsync(() => viewInbound = false);
          expressionFn.assign(scope.context, outboundValue);
          tasks.completeTask(taskId);
        }
      }, context: controller, formatters: formatters);
    }
  }

  _bindOneWay(tasks, expression, scope, dstPathFn, controller, formatters) {
    var taskId = tasks.registerTask();

    Expression attrExprFn = _parser(expression);
    scope.watch(expression, (v, _) {
      dstPathFn.assign(controller, v);
      tasks.completeTask(taskId);
    }, formatters: formatters);
  }

  _bindCallback(dstPathFn, controller, expression, scope) {
    dstPathFn.assign(controller, _parser(expression).bind(scope.context, ScopeLocals.wrapper));
  }

  _createAttrMappings(controller, scope, List<MappingParts> mappings, nodeAttrs, formatters, tasks) {
    mappings.forEach((MappingParts p) {
      var attrName = p.attrName;
      var dstExpression = p.dstExpression;

      Expression dstPathFn = _parser(dstExpression);
      if (!dstPathFn.isAssignable) {
        throw "Expression '$dstExpression' is not assignable in mapping '${p.originalValue}' "
              "for attribute '$attrName'.";
      }

      // Check if there is a bind attribute for this mapping.
      var bindAttr = bindAttrs["bind-${p.attrName}"];
      if (bindAttr != null) {
        if (p.mode == '<=>') {
          _bindTwoWay(tasks, bindAttr, scope, dstPathFn,
              controller, formatters, dstExpression);
        } else if(p.mode == '&') {
          _bindCallback(dstPathFn, controller, bindAttr, scope);
        } else {
          _bindOneWay(tasks, bindAttr, scope, dstPathFn, controller, formatters);
        }
        return;
      }

      switch (p.mode) {
        case '@': // string
          var taskId = tasks.registerTask();
          nodeAttrs.observe(attrName, (value) {
            dstPathFn.assign(controller, value);
            tasks.completeTask(taskId);
          });
          break;

        case '<=>': // two-way
          if (nodeAttrs[attrName] == null) return;

          _bindTwoWay(tasks, nodeAttrs[attrName], scope, dstPathFn,
              controller, formatters, dstExpression);
          break;

        case '=>': // one-way
          if (nodeAttrs[attrName] == null) return;
          _bindOneWay(tasks, nodeAttrs[attrName], scope,
              dstPathFn, controller, formatters);
          break;

        case '=>!': //  one-way, one-time
          if (nodeAttrs[attrName] == null) return;

          Expression attrExprFn = _parser(nodeAttrs[attrName]);
          var watch;
          watch = scope.watch(nodeAttrs[attrName], (value, _) {
            if (dstPathFn.assign(controller, value) != null) {
              watch.remove();
            }
          }, formatters: formatters);
          break;

        case '&': // callback
          _bindCallback(dstPathFn, controller, nodeAttrs[attrName], scope);
          break;
      }
    });
  }

  _link(nodeInjector, probe, scope, nodeAttrs, formatters) {
    _usableDirectiveRefs.forEach((DirectiveRef ref) {
      var linkTimer;
      try {
        var linkMapTimer;
        assert((linkTimer = _perf.startTimer('ng.view.link', ref.type)) != false);
        var controller = nodeInjector.get(ref.type);
        probe.directives.add(controller);
        assert((linkMapTimer = _perf.startTimer('ng.view.link.map', ref.type)) != false);

        if (ref.annotation is Controller) {
          scope.context[(ref.annotation as Controller).publishAs] = controller;
        }

        var tasks = new _TaskList(controller is AttachAware ? () {
          if (scope.isAttached) controller.attach();
        } : null);

        if (ref.mappings.isNotEmpty) {
          if (nodeAttrs == null) nodeAttrs = new _AnchorAttrs(ref);
          _createAttrMappings(controller, scope, ref.mappings, nodeAttrs, formatters, tasks);
        }

        if (controller is AttachAware) {
          var taskId = tasks.registerTask();
          Watch watch;
          watch = scope.watch('1', // Cheat a bit.
              (_, __) {
            watch.remove();
            tasks.completeTask(taskId);
          });
        }

        tasks.doneRegistering();

        if (controller is DetachAware) {
          scope.on(ScopeEvent.DESTROY).listen((_) => controller.detach());
        }

        assert(_perf.stopTimer(linkMapTimer) != false);
      } finally {
        assert(_perf.stopTimer(linkTimer) != false);
      }
    });
  }

  _createDirectiveFactories(DirectiveRef ref, nodeModule, node, nodesAttrsDirectives, nodeAttrs,
                            visibility) {
    if (ref.type == TextMustache) {
      nodeModule.bind(TextMustache, toFactory: (Injector injector) {
        return new TextMustache(node, ref.value, injector.get(Interpolate),
            injector.get(Scope), injector.get(FormatterMap));
      });
    } else if (ref.type == AttrMustache) {
      if (nodesAttrsDirectives.isEmpty) {
        nodeModule.bind(AttrMustache, toFactory: (Injector injector) {
          var scope = injector.get(Scope);
          var interpolate = injector.get(Interpolate);
          for (var ref in nodesAttrsDirectives) {
            new AttrMustache(nodeAttrs, ref.value, interpolate, scope,
                injector.get(FormatterMap));
          }
        });
      }
      nodesAttrsDirectives.add(ref);
    } else if (ref.annotation is Component) {
      var factory;
      var annotation = ref.annotation as Component;
      if (annotation.useShadowDom == true) {
        factory = _shadowDomComponentFactory;
      } else if (annotation.useShadowDom == false) {
        factory = _transcludingComponentFactory;
      } else {
        factory = _componentFactory;
      }
      nodeModule.bind(ref.type, toFactory: factory.call(node, ref), visibility: visibility);
    } else {
      nodeModule.bind(ref.type, visibility: visibility);
    }
  }

  // Overridden in TemplateElementBinder
  _registerViewFactory(node, parentInjector, nodeModule) {
    nodeModule..bind(ViewPort, toValue: null)
              ..bind(ViewFactory, toValue: null)
              ..bind(BoundViewFactory, toValue: null);
  }

  Injector bind(View view, Injector parentInjector, dom.Node node) {
    Injector nodeInjector;
    Scope scope = parentInjector.get(Scope);
    FormatterMap formatters = parentInjector.get(FormatterMap);
    var nodeAttrs = node is dom.Element ? new NodeAttrs(node) : null;
    ElementProbe probe;

    var timerId;
    assert((timerId = _perf.startTimer('ng.view.link.setUp', _html(node))) != false);
    var directiveRefs = _usableDirectiveRefs;
    try {
      if (!hasDirectivesOrEvents) return parentInjector;

      var nodesAttrsDirectives = [];
      var nodeModule = new Module()
          ..bind(NgElement)
          ..bind(View, toValue: view)
          ..bind(dom.Element, toValue: node)
          ..bind(dom.Node, toValue: node)
          ..bind(NodeAttrs, toValue: nodeAttrs)
          ..bind(ElementProbe, toFactory: (_) => probe);

      directiveRefs.forEach((DirectiveRef ref) {
        Directive annotation = ref.annotation;
        var visibility = ref.annotation.visibility;
        if (ref.annotation is Controller) {
          scope = scope.createChild(new PrototypeMap(scope.context));
          nodeModule.bind(Scope, toValue: scope);
        }

        _createDirectiveFactories(ref, nodeModule, node, nodesAttrsDirectives, nodeAttrs,
            visibility);
        if (ref.annotation.module != null) {
           nodeModule.install(ref.annotation.module());
        }
      });

      _registerViewFactory(node, parentInjector, nodeModule);

      nodeInjector = parentInjector.createChild([nodeModule]);
      probe = _expando[node] = new ElementProbe(
          parentInjector.get(ElementProbe), node, nodeInjector, scope);
    } finally {
      assert(_perf.stopTimer(timerId) != false);
    }

    _link(nodeInjector, probe, scope, nodeAttrs, formatters);

    onEvents.forEach((event, value) {
      view.registerEvent(EventHandler.attrNameToEventName(event));
    });
    return nodeInjector;
  }

  String toString() => "[ElementBinder decorators:$decorators]";
}

/**
 * Private class used for managing controller.attach() calls
 */
class _TaskList {
  var onDone;
  final List _tasks = [];
  bool isDone = false;

  _TaskList(this.onDone) {
    if (onDone == null) isDone = true;
  }

  int registerTask() {
    if (isDone) return null; // Do nothing if there is nothing to do.
    _tasks.add(false);
    return _tasks.length - 1;
  }

  void completeTask(id) {
    if (isDone) return;
    _tasks[id] = true;
    if (_tasks.every((a) => a)) {
      onDone();
      isDone = true;
    }
  }

  doneRegistering() {
    completeTask(registerTask());
  }
}

// Used for walking the DOM
class ElementBinderTreeRef {
  final int offsetIndex;
  final ElementBinderTree subtree;

  ElementBinderTreeRef(this.offsetIndex, this.subtree);
}

class ElementBinderTree {
  final ElementBinder binder;
  final List<ElementBinderTreeRef> subtrees;

  ElementBinderTree(this.binder, this.subtrees);
}

class TaggedTextBinder {
  final ElementBinder binder;
  final int offsetIndex;

  TaggedTextBinder(this.binder, this.offsetIndex);
  toString() => "[TaggedTextBinder binder:$binder offset:$offsetIndex]";
}

// Used for the tagging compiler
class TaggedElementBinder {
  final ElementBinder binder;
  int parentBinderOffset;
  var injector;
  bool isTopLevel;

  List<TaggedTextBinder> textBinders;

  TaggedElementBinder(this.binder, this.parentBinderOffset, this.isTopLevel);

  void addText(TaggedTextBinder tagged) {
    if (textBinders == null) textBinders = [];
    textBinders.add(tagged);
  }

  String toString() => "[TaggedElementBinder binder:$binder parentBinderOffset:"
                       "$parentBinderOffset textBinders:$textBinders "
                       "injector:$injector]";
}
