library rss_app.web.rss_app.generated_static_injector;

import 'package:di/di.dart';
import 'package:di/static_injector.dart';

import 'package:angular/core/module_internal.dart' as import_0;
import 'package:di/di.dart' as import_1;
import 'package:angular/core/registry.dart' as import_2;
import 'package:angular/core/parser/parser.dart' as import_4;
import 'package:angular/change_detection/change_detection.dart' as import_5;
import 'package:angular/core/parser/dynamic_parser.dart' as import_6;
import 'package:angular/core/parser/lexer.dart' as import_7;
import 'package:angular/core_dom/module_internal.dart' as import_8;
import 'dart:html' as import_9;
import 'package:perf_api/perf_api.dart' as import_10;
import 'package:angular/directive/module.dart' as import_11;
import 'package:angular/formatter/module_internal.dart' as import_12;
import 'package:angular/routing/module.dart' as import_13;
import 'package:route_hierarchical/client.dart' as import_14;
import 'package:angular/application.dart' as import_15;
import 'package:rss_app/rss_controller.dart' as import_16;
import 'package:rss_app/service/query_service.dart' as import_17;
import 'package:rss_app/service/database.dart' as import_18;
import 'package:rss_app/component/feed_list.dart' as import_19;
import 'package:rss_app/component/posts_list.dart' as import_20;
import 'package:rss_app/component/add_feed_header.dart' as import_21;
import 'package:rss_app/formatter/text_formatter.dart' as import_22;
Injector createStaticInjector({List<Module> modules, String name,
    bool allowImplicitInjection: false}) =>
  new StaticInjector(modules: modules, name: name,
      allowImplicitInjection: allowImplicitInjection,
      typeFactories: factories);

final Map<Type, TypeFactory> factories = <Type, TypeFactory>{
  import_0.ExceptionHandler: (f) => new import_0.ExceptionHandler(),
  import_0.FormatterMap: (f) => new import_0.FormatterMap(f(import_1.Injector), f(import_2.MetadataExtractor)),
  import_0.Interpolate: (f) => new import_0.Interpolate(),
  import_0.ScopeDigestTTL: (f) => new import_0.ScopeDigestTTL(),
  import_0.ScopeStats: (f) => new import_0.ScopeStats(f(import_0.ScopeStatsEmitter), f(import_0.ScopeStatsConfig)),
  import_0.ScopeStatsEmitter: (f) => new import_0.ScopeStatsEmitter(),
  import_0.RootScope: (f) => new import_0.RootScope(f(Object), f(import_4.Parser), f(import_5.FieldGetterFactory), f(import_0.FormatterMap), f(import_0.ExceptionHandler), f(import_0.ScopeDigestTTL), f(import_0.VmTurnZone), f(import_0.ScopeStats), f(import_6.ClosureMap)),
  import_6.DynamicParser: (f) => new import_6.DynamicParser(f(import_7.Lexer), f(import_4.ParserBackend)),
  import_6.DynamicParserBackend: (f) => new import_6.DynamicParserBackend(f(import_6.ClosureMap)),
  import_7.Lexer: (f) => new import_7.Lexer(),
  import_8.Animate: (f) => new import_8.Animate(),
  import_8.ViewCache: (f) => new import_8.ViewCache(f(import_8.Http), f(import_8.TemplateCache), f(import_8.Compiler), f(import_9.NodeTreeSanitizer)),
  import_8.BrowserCookies: (f) => new import_8.BrowserCookies(f(import_0.ExceptionHandler)),
  import_8.Cookies: (f) => new import_8.Cookies(f(import_8.BrowserCookies)),
  import_8.DirectiveMap: (f) => new import_8.DirectiveMap(f(import_1.Injector), f(import_2.MetadataExtractor), f(import_8.DirectiveSelectorFactory)),
  import_8.ElementBinderFactory: (f) => new import_8.ElementBinderFactory(f(import_4.Parser), f(import_10.Profiler), f(Expando), f(import_8.ComponentFactory), f(import_8.TranscludingComponentFactory), f(import_8.ShadowDomComponentFactory)),
  import_8.EventHandler: (f) => new import_8.EventHandler(f(import_9.Node), f(Expando), f(import_0.ExceptionHandler)),
  import_8.ShadowRootEventHandler: (f) => new import_8.ShadowRootEventHandler(f(import_9.ShadowRoot), f(Expando), f(import_0.ExceptionHandler)),
  import_8.UrlRewriter: (f) => new import_8.UrlRewriter(),
  import_8.HttpBackend: (f) => new import_8.HttpBackend(),
  import_8.LocationWrapper: (f) => new import_8.LocationWrapper(),
  import_8.HttpInterceptors: (f) => new import_8.HttpInterceptors(),
  import_8.HttpDefaultHeaders: (f) => new import_8.HttpDefaultHeaders(),
  import_8.HttpDefaults: (f) => new import_8.HttpDefaults(f(import_8.HttpDefaultHeaders)),
  import_8.Http: (f) => new import_8.Http(f(import_8.BrowserCookies), f(import_8.LocationWrapper), f(import_8.UrlRewriter), f(import_8.HttpBackend), f(import_8.HttpDefaults), f(import_8.HttpInterceptors)),
  import_8.TextMustache: (f) => new import_8.TextMustache(f(import_9.Node), f(String), f(import_0.Interpolate), f(import_0.Scope), f(import_0.FormatterMap)),
  import_8.AttrMustache: (f) => new import_8.AttrMustache(f(import_8.NodeAttrs), f(String), f(import_0.Interpolate), f(import_0.Scope), f(import_0.FormatterMap)),
  import_8.DirectiveSelectorFactory: (f) => new import_8.DirectiveSelectorFactory(f(import_8.ElementBinderFactory)),
  import_8.ShadowDomComponentFactory: (f) => new import_8.ShadowDomComponentFactory(f(Expando)),
  import_8.TaggingCompiler: (f) => new import_8.TaggingCompiler(f(import_10.Profiler), f(Expando)),
  import_8.Content: (f) => new import_8.Content(f(import_8.ContentPort), f(import_9.Element)),
  import_8.TranscludingComponentFactory: (f) => new import_8.TranscludingComponentFactory(f(Expando)),
  import_8.NullTreeSanitizer: (f) => new import_8.NullTreeSanitizer(),
  import_8.WalkingCompiler: (f) => new import_8.WalkingCompiler(f(import_10.Profiler), f(Expando)),
  import_8.NgElement: (f) => new import_8.NgElement(f(import_9.Element), f(import_0.Scope), f(import_8.Animate)),
  import_11.AHref: (f) => new import_11.AHref(f(import_9.Element), f(import_0.VmTurnZone)),
  import_11.NgBaseCss: (f) => new import_11.NgBaseCss(),
  import_11.NgBind: (f) => new import_11.NgBind(f(import_9.Element)),
  import_11.NgBindHtml: (f) => new import_11.NgBindHtml(f(import_9.Element), f(import_9.NodeValidator)),
  import_11.NgBindTemplate: (f) => new import_11.NgBindTemplate(f(import_9.Element)),
  import_11.NgClass: (f) => new import_11.NgClass(f(import_8.NgElement), f(import_0.Scope), f(import_8.NodeAttrs)),
  import_11.NgClassOdd: (f) => new import_11.NgClassOdd(f(import_8.NgElement), f(import_0.Scope), f(import_8.NodeAttrs)),
  import_11.NgClassEven: (f) => new import_11.NgClassEven(f(import_8.NgElement), f(import_0.Scope), f(import_8.NodeAttrs)),
  import_11.NgEvent: (f) => new import_11.NgEvent(f(import_9.Element), f(import_0.Scope)),
  import_11.NgCloak: (f) => new import_11.NgCloak(f(import_9.Element), f(import_8.Animate)),
  import_11.NgIf: (f) => new import_11.NgIf(f(import_8.BoundViewFactory), f(import_8.ViewPort), f(import_0.Scope)),
  import_11.NgUnless: (f) => new import_11.NgUnless(f(import_8.BoundViewFactory), f(import_8.ViewPort), f(import_0.Scope)),
  import_11.NgInclude: (f) => new import_11.NgInclude(f(import_9.Element), f(import_0.Scope), f(import_8.ViewCache), f(import_1.Injector), f(import_8.DirectiveMap)),
  import_11.NgModel: (f) => new import_11.NgModel(f(import_0.Scope), f(import_8.NgElement), f(import_1.Injector), f(import_8.NodeAttrs), f(import_8.Animate)),
  import_11.InputCheckbox: (f) => new import_11.InputCheckbox(f(import_9.Element), f(import_11.NgModel), f(import_0.Scope), f(import_11.NgTrueValue), f(import_11.NgFalseValue)),
  import_11.InputTextLike: (f) => new import_11.InputTextLike(f(import_9.Element), f(import_11.NgModel), f(import_0.Scope)),
  import_11.InputNumberLike: (f) => new import_11.InputNumberLike(f(import_9.Element), f(import_11.NgModel), f(import_0.Scope)),
  import_11.NgBindTypeForDateLike: (f) => new import_11.NgBindTypeForDateLike(f(import_9.Element)),
  import_11.InputDateLike: (f) => new import_11.InputDateLike(f(import_9.Element), f(import_11.NgModel), f(import_0.Scope), f(import_11.NgBindTypeForDateLike)),
  import_11.NgValue: (f) => new import_11.NgValue(f(import_9.Element)),
  import_11.NgTrueValue: (f) => new import_11.NgTrueValue(f(import_9.Element)),
  import_11.NgFalseValue: (f) => new import_11.NgFalseValue(f(import_9.Element)),
  import_11.InputRadio: (f) => new import_11.InputRadio(f(import_9.Element), f(import_11.NgModel), f(import_0.Scope), f(import_11.NgValue), f(import_8.NodeAttrs)),
  import_11.ContentEditable: (f) => new import_11.ContentEditable(f(import_9.Element), f(import_11.NgModel), f(import_0.Scope)),
  import_11.NgPluralize: (f) => new import_11.NgPluralize(f(import_0.Scope), f(import_9.Element), f(import_0.Interpolate), f(import_0.FormatterMap)),
  import_11.NgRepeat: (f) => new import_11.NgRepeat(f(import_8.ViewPort), f(import_8.BoundViewFactory), f(import_0.Scope), f(import_4.Parser), f(import_0.FormatterMap)),
  import_11.NgTemplate: (f) => new import_11.NgTemplate(f(import_9.Element), f(import_8.TemplateCache)),
  import_11.NgHide: (f) => new import_11.NgHide(f(import_9.Element), f(import_8.Animate)),
  import_11.NgShow: (f) => new import_11.NgShow(f(import_9.Element), f(import_8.Animate)),
  import_11.NgBooleanAttribute: (f) => new import_11.NgBooleanAttribute(f(import_8.NgElement)),
  import_11.NgSource: (f) => new import_11.NgSource(f(import_8.NgElement)),
  import_11.NgAttribute: (f) => new import_11.NgAttribute(f(import_8.NodeAttrs)),
  import_11.NgStyle: (f) => new import_11.NgStyle(f(import_9.Element), f(import_0.Scope)),
  import_11.NgSwitch: (f) => new import_11.NgSwitch(f(import_0.Scope)),
  import_11.NgSwitchWhen: (f) => new import_11.NgSwitchWhen(f(import_11.NgSwitch), f(import_8.ViewPort), f(import_8.BoundViewFactory), f(import_0.Scope)),
  import_11.NgSwitchDefault: (f) => new import_11.NgSwitchDefault(f(import_11.NgSwitch), f(import_8.ViewPort), f(import_8.BoundViewFactory), f(import_0.Scope)),
  import_11.NgNonBindable: (f) => new import_11.NgNonBindable(),
  import_11.InputSelect: (f) => new import_11.InputSelect(f(import_9.Element), f(import_8.NodeAttrs), f(import_11.NgModel), f(import_0.Scope)),
  import_11.OptionValue: (f) => new import_11.OptionValue(f(import_9.Element), f(import_11.InputSelect), f(import_11.NgValue)),
  import_11.NgForm: (f) => new import_11.NgForm(f(import_0.Scope), f(import_8.NgElement), f(import_1.Injector), f(import_8.Animate)),
  import_11.NgModelRequiredValidator: (f) => new import_11.NgModelRequiredValidator(f(import_11.NgModel)),
  import_11.NgModelUrlValidator: (f) => new import_11.NgModelUrlValidator(f(import_11.NgModel)),
  import_11.NgModelEmailValidator: (f) => new import_11.NgModelEmailValidator(f(import_11.NgModel)),
  import_11.NgModelNumberValidator: (f) => new import_11.NgModelNumberValidator(f(import_11.NgModel)),
  import_11.NgModelMaxNumberValidator: (f) => new import_11.NgModelMaxNumberValidator(f(import_11.NgModel)),
  import_11.NgModelMinNumberValidator: (f) => new import_11.NgModelMinNumberValidator(f(import_11.NgModel)),
  import_11.NgModelPatternValidator: (f) => new import_11.NgModelPatternValidator(f(import_11.NgModel)),
  import_11.NgModelMinLengthValidator: (f) => new import_11.NgModelMinLengthValidator(f(import_11.NgModel)),
  import_11.NgModelMaxLengthValidator: (f) => new import_11.NgModelMaxLengthValidator(f(import_11.NgModel)),
  import_12.Currency: (f) => new import_12.Currency(),
  import_12.Date: (f) => new import_12.Date(),
  import_12.Filter: (f) => new import_12.Filter(f(import_4.Parser)),
  import_12.Json: (f) => new import_12.Json(),
  import_12.LimitTo: (f) => new import_12.LimitTo(f(import_1.Injector)),
  import_12.Lowercase: (f) => new import_12.Lowercase(),
  import_12.Arrayify: (f) => new import_12.Arrayify(),
  import_12.Number: (f) => new import_12.Number(),
  import_12.OrderBy: (f) => new import_12.OrderBy(f(import_4.Parser)),
  import_12.Uppercase: (f) => new import_12.Uppercase(),
  import_12.Stringify: (f) => new import_12.Stringify(),
  import_13.NgRoutingUsePushState: (f) => new import_13.NgRoutingUsePushState(),
  import_13.NgRoutingHelper: (f) => new import_13.NgRoutingHelper(f(import_13.RouteInitializer), f(import_1.Injector), f(import_14.Router), f(import_15.Application)),
  import_13.NgView: (f) => new import_13.NgView(f(import_9.Element), f(import_8.ViewCache), f(import_1.Injector), f(import_14.Router), f(import_0.Scope)),
  import_13.NgBindRoute: (f) => new import_13.NgBindRoute(f(import_14.Router), f(import_1.Injector), f(import_13.NgRoutingHelper)),
  import_16.RssController: (f) => new import_16.RssController(f(import_17.QueryService)),
  import_17.QueryService: (f) => new import_17.QueryService(f(import_8.Http), f(import_18.RssDatabase)),
  import_18.RssDatabase: (f) => new import_18.RssDatabase(),
  import_19.FeedListComponent: (f) => new import_19.FeedListComponent(),
  import_20.PostsListComponent: (f) => new import_20.PostsListComponent(f(import_13.RouteProvider), f(import_17.QueryService)),
  import_21.AddFeedHeqaderComponent: (f) => new import_21.AddFeedHeqaderComponent(f(import_17.QueryService)),
  import_22.TruncateFilter: (f) => new import_22.TruncateFilter(),
  import_22.SanitizeFilter: (f) => new import_22.SanitizeFilter(),
  import_10.Profiler: (f) => new import_10.Profiler(),
};
