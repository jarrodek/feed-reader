
      // TODO(nevir): Running these tests concurrently increases the flakiness.
      WCT.numConcurrentSuites = 1;

      WCT.loadSuites([
        'js/attrs.js',
        'js/bindMDV.js',
        'js/events.js',
        'js/marshall.js',
        'js/oop.js',
        'js/paths.js',
        'js/register.js',

        'html/shadowroots.html',
        'html/resolvePath.html',
        'html/prepare.html',

        // Declarative Attributes
        'html/publish-attributes.html',
        'html/take-attributes.html',
        'html/attr-mustache.html',
        'html/prop-attr-reflection.html',

        // bind
        'html/template-distribute-dynamic.html',
        'html/template-attr-template.html',
        'html/bind.html',
        'html/unbind.html',
        'html/prop-attr-bind-reflection.html',
        'html/bindProperties.html',
        'html/bind-object-repeat.html',

        // Events
        'html/event-handlers.html',
        'html/event-handlers-host.html',
        'html/event-handlers-light.html',
        'html/event-path.html',
        'html/event-path-declarative.html',

        // MDV Syntax
        // TODO(dfreedm): Disable this test until polymer-expressions#19 is resolved
        // 'html/mdv-syntax.html',
        'html/template-repeat-wrappers.html',
        'html/mdv-shadow.html',

        // Properties
        'html/property-changes.html',
        'html/property-array-changes.html',
        'html/property-observe.html',
        'html/computedProperties.html',

        // Element Registration
        'html/callbacks.html',
        'html/element-script.html',
        'html/element-registration.html',
        'html/element-instanceOfType.html',
        'html/element-import.html',
        'html/auto-binding.html',
        'html/ctor.html',
        'html/domready.html',
        'html/infer-name.html',
        'html/platform-less.html',
        'html/import-warning.html',
        'html/forceReady.html',

        // Styling
        'html/styling/sheet-order.html',
        'html/styling/sheet-scope.html',
        'html/styling/sheet-main-doc.html',
        'html/styling/unresolved.html',
        'html/styling/recursive-style-import.html',

        // Utils
        'html/async.html',
        'html/url.html',
        'html/loader-deduplicate.html',
        'html/layout.html',
        'html/polymer-import.html'
      ]);
    