library rss_app.web.rss_app.generated_type_factory_maps;

import 'package:di/di.dart';
import 'package:di/src/reflector_static.dart';

import 'package:rss_app/component/unread_counter/unread_counter.dart' as import_0;
import 'package:rss_app/service/query_service.dart' as import_1;
import 'package:angular/core_dom/module_internal.dart' as import_2;
import 'package:angular/core/module_internal.dart' as import_3;
import 'package:perf_api/perf_api.dart' as import_4;
import 'package:di/src/injector.dart' as import_6;
import 'package:angular/core/formatter.dart' as import_7;
import 'package:angular/core/registry.dart' as import_8;
import 'package:angular/core/parser/parser.dart' as import_9;
import 'package:angular/change_detection/ast_parser.dart' as import_10;
import 'dart:html' as import_11;
import 'package:angular/change_detection/watch_group.dart' as import_12;
import 'package:angular/cache/module.dart' as import_13;
import 'package:angular/core/parser/dynamic_parser.dart' as import_14;
import 'package:angular/core/parser/lexer.dart' as import_15;
import 'package:angular/directive/module.dart' as import_16;
import 'package:angular/core_dom/directive_injector.dart' as import_17;
import 'package:angular/change_detection/change_detection.dart' as import_18;
import 'package:angular/formatter/module_internal.dart' as import_19;
import 'package:angular/animate/module.dart' as import_20;
import 'package:angular/routing/module.dart' as import_21;
import 'package:route_hierarchical/client.dart' as import_22;
import 'package:angular/application.dart' as import_23;
import 'package:angular/cache/js_cache_register.dart' as import_24;
import 'package:rss_app/service/database.dart' as import_25;
import 'package:rss_app/service/communication.dart' as import_26;
import 'package:rss_app/rss_controller.dart' as import_27;
import 'package:rss_app/formatter/posts_list_formatter.dart' as import_28;
import 'package:rss_app/service/image_service.dart' as import_29;
import 'package:rss_app/component/star/star.dart' as import_30;
import 'package:rss_app/component/feed_list/feed_list.dart' as import_31;
import 'package:rss_app/component/app-header/app-header.dart' as import_32;
import 'package:rss_app/service/events_observer.dart' as import_33;
import 'package:rss_app/component/data_handler/data_handler.dart' as import_34;
import 'package:rss_app/component/post/post.dart' as import_35;
import 'package:rss_app/formatter/text_formatter.dart' as import_36;
import 'package:rss_app/component/menu/menu.dart' as import_37;
import 'package:rss_app/component/pubdate/pubdate.dart' as import_38;
import 'package:rss_app/decorator/app-icon.dart' as import_39;
import 'package:rss_app/component/feed_entries/feed_entries.dart' as import_40;
import 'package:rss_app/formatter/date_formatter.dart' as import_41;
import 'package:rss_app/component/lists/list_article.dart' as import_42;
import 'package:rss_app/component/menu/menu-item.dart' as import_43;
import 'package:rss_app/component/lists/entries_lists.dart' as import_44;

final Key _KEY_QueryService = new Key(import_1.QueryService);
final Key _KEY_ExceptionHandler = new Key(import_3.ExceptionHandler);
final Key _KEY_BrowserCookies = new Key(import_2.BrowserCookies);
final Key _KEY_Profiler = new Key(import_4.Profiler);
final Key _KEY_Expando = new Key(Expando);
final Key _KEY_Injector = new Key(import_6.Injector);
final Key _KEY_FormatterMap = new Key(import_7.FormatterMap);
final Key _KEY_MetadataExtractor = new Key(import_8.MetadataExtractor);
final Key _KEY_DirectiveSelectorFactory = new Key(import_2.DirectiveSelectorFactory);
final Key _KEY_Parser = new Key(import_9.Parser);
final Key _KEY_CompilerConfig = new Key(import_2.CompilerConfig);
final Key _KEY_ASTParser = new Key(import_10.ASTParser);
final Key _KEY_ComponentFactory = new Key(import_2.ComponentFactory);
final Key _KEY_ShadowDomComponentFactory = new Key(import_2.ShadowDomComponentFactory);
final Key _KEY_TranscludingComponentFactory = new Key(import_2.TranscludingComponentFactory);
final Key _KEY_Node = new Key(import_11.Node);
final Key _KEY_ShadowRoot = new Key(import_11.ShadowRoot);
final Key _KEY_HttpDefaultHeaders = new Key(import_2.HttpDefaultHeaders);
final Key _KEY_LocationWrapper = new Key(import_2.LocationWrapper);
final Key _KEY_UrlRewriter = new Key(import_2.UrlRewriter);
final Key _KEY_HttpBackend = new Key(import_2.HttpBackend);
final Key _KEY_HttpDefaults = new Key(import_2.HttpDefaults);
final Key _KEY_HttpInterceptors = new Key(import_2.HttpInterceptors);
final Key _KEY_RootScope = new Key(import_3.RootScope);
final Key _KEY_HttpConfig = new Key(import_2.HttpConfig);
final Key _KEY_VmTurnZone = new Key(import_3.VmTurnZone);
final Key _KEY_AST = new Key(import_12.AST);
final Key _KEY_Scope = new Key(import_3.Scope);
final Key _KEY_NodeAttrs = new Key(import_2.NodeAttrs);
final Key _KEY_String = new Key(String);
final Key _KEY_Element = new Key(import_11.Element);
final Key _KEY_Animate = new Key(import_2.Animate);
final Key _KEY_ElementBinderFactory = new Key(import_2.ElementBinderFactory);
final Key _KEY_Interpolate = new Key(import_3.Interpolate);
final Key _KEY_ViewCache = new Key(import_2.ViewCache);
final Key _KEY_Http = new Key(import_2.Http);
final Key _KEY_TemplateCache = new Key(import_2.TemplateCache);
final Key _KEY_WebPlatform = new Key(import_2.WebPlatform);
final Key _KEY_ComponentCssRewriter = new Key(import_2.ComponentCssRewriter);
final Key _KEY_NodeTreeSanitizer = new Key(import_11.NodeTreeSanitizer);
final Key _KEY_CacheRegister = new Key(import_13.CacheRegister);
final Key _KEY_ContentPort = new Key(import_2.ContentPort);
final Key _KEY_Compiler = new Key(import_2.Compiler);
final Key _KEY_Lexer = new Key(import_15.Lexer);
final Key _KEY_ParserBackend = new Key(import_9.ParserBackend);
final Key _KEY_ClosureMap = new Key(import_14.ClosureMap);
final Key _KEY_ElementProbe = new Key(import_2.ElementProbe);
final Key _KEY_NodeValidator = new Key(import_11.NodeValidator);
final Key _KEY_NgElement = new Key(import_2.NgElement);
final Key _KEY_ViewFactory = new Key(import_2.ViewFactory);
final Key _KEY_ViewPort = new Key(import_2.ViewPort);
final Key _KEY_DirectiveInjector = new Key(import_17.DirectiveInjector);
final Key _KEY_DirectiveMap = new Key(import_2.DirectiveMap);
final Key _KEY_NgModel = new Key(import_16.NgModel);
final Key _KEY_NgTrueValue = new Key(import_16.NgTrueValue);
final Key _KEY_NgFalseValue = new Key(import_16.NgFalseValue);
final Key _KEY_NgModelOptions = new Key(import_16.NgModelOptions);
final Key _KEY_NgBindTypeForDateLike = new Key(import_16.NgBindTypeForDateLike);
final Key _KEY_NgValue = new Key(import_16.NgValue);
final Key _KEY_BoundViewFactory = new Key(import_2.BoundViewFactory);
final Key _KEY_NgSwitch = new Key(import_16.NgSwitch);
final Key _KEY_InputSelect = new Key(import_16.InputSelect);
final Key _KEY_ScopeStatsEmitter = new Key(import_3.ScopeStatsEmitter);
final Key _KEY_ScopeStatsConfig = new Key(import_3.ScopeStatsConfig);
final Key _KEY_Object = new Key(Object);
final Key _KEY_FieldGetterFactory = new Key(import_18.FieldGetterFactory);
final Key _KEY_ScopeDigestTTL = new Key(import_3.ScopeDigestTTL);
final Key _KEY_ScopeStats = new Key(import_3.ScopeStats);
final Key _KEY_AnimationFrame = new Key(import_20.AnimationFrame);
final Key _KEY_Window = new Key(import_11.Window);
final Key _KEY_AnimationLoop = new Key(import_20.AnimationLoop);
final Key _KEY_CssAnimationMap = new Key(import_20.CssAnimationMap);
final Key _KEY_AnimationOptimizer = new Key(import_20.AnimationOptimizer);
final Key _KEY_RouteInitializer = new Key(import_21.RouteInitializer);
final Key _KEY_Router = new Key(import_22.Router);
final Key _KEY_Application = new Key(import_23.Application);
final Key _KEY_NgRoutingHelper = new Key(import_21.NgRoutingHelper);
final Key _KEY_RssDatabase = new Key(import_25.RssDatabase);
final Key _KEY_AppEvents = new Key(import_33.AppEvents);
final Key _KEY_AppComm = new Key(import_26.AppComm);
final Key _KEY_RouteProvider = new Key(import_21.RouteProvider);
final Key _KEY_ImageService = new Key(import_29.ImageService);
final Map<Type, Function> typeFactories = <Type, Function>{
  import_0.UnreadCounterComponent: (a1) => new import_0.UnreadCounterComponent(a1),
  import_2.Animate: () => new import_2.Animate(),
  import_2.BrowserCookies: (a1) => new import_2.BrowserCookies(a1),
  import_2.Cookies: (a1) => new import_2.Cookies(a1),
  import_2.Compiler: (a1, a2) => new import_2.Compiler(a1, a2),
  import_2.CompilerConfig: () => new import_2.CompilerConfig(),
  import_2.DirectiveMap: (a1, a2, a3, a4) => new import_2.DirectiveMap(a1, a2, a3, a4),
  import_2.ElementBinderFactory: (a1, a2, a3, a4, a5, a6, a7, a8) => new import_2.ElementBinderFactory(a1, a2, a3, a4, a5, a6, a7, a8),
  import_2.EventHandler: (a1, a2, a3) => new import_2.EventHandler(a1, a2, a3),
  import_2.ShadowRootEventHandler: (a1, a2, a3) => new import_2.ShadowRootEventHandler(a1, a2, a3),
  import_2.UrlRewriter: () => new import_2.UrlRewriter(),
  import_2.HttpBackend: () => new import_2.HttpBackend(),
  import_2.LocationWrapper: () => new import_2.LocationWrapper(),
  import_2.HttpInterceptors: () => new import_2.HttpInterceptors(),
  import_2.HttpDefaultHeaders: () => new import_2.HttpDefaultHeaders(),
  import_2.HttpDefaults: (a1) => new import_2.HttpDefaults(a1),
  import_2.Http: (a1, a2, a3, a4, a5, a6, a7, a8, a9) => new import_2.Http(a1, a2, a3, a4, a5, a6, a7, a8, a9),
  import_2.HttpConfig: () => new import_2.HttpConfig(),
  import_2.TextMustache: (a1, a2, a3) => new import_2.TextMustache(a1, a2, a3),
  import_2.AttrMustache: (a1, a2, a3, a4) => new import_2.AttrMustache(a1, a2, a3, a4),
  import_2.NgElement: (a1, a2, a3) => new import_2.NgElement(a1, a2, a3),
  import_2.DirectiveSelectorFactory: (a1, a2, a3, a4, a5) => new import_2.DirectiveSelectorFactory(a1, a2, a3, a4, a5),
  import_2.ShadowDomComponentFactory: (a1, a2, a3, a4, a5, a6, a7, a8, a9) => new import_2.ShadowDomComponentFactory(a1, a2, a3, a4, a5, a6, a7, a8, a9),
  import_2.ComponentCssRewriter: () => new import_2.ComponentCssRewriter(),
  import_2.Content: (a1, a2) => new import_2.Content(a1, a2),
  import_2.TranscludingComponentFactory: (a1, a2, a3) => new import_2.TranscludingComponentFactory(a1, a2, a3),
  import_2.NullTreeSanitizer: () => new import_2.NullTreeSanitizer(),
  import_2.ViewCache: (a1, a2, a3, a4, a5) => new import_2.ViewCache(a1, a2, a3, a4, a5),
  import_2.WebPlatform: () => new import_2.WebPlatform(),
  import_7.FormatterMap: (a1, a2) => new import_7.FormatterMap(a1, a2),
  import_14.DynamicParser: (a1, a2, a3) => new import_14.DynamicParser(a1, a2, a3),
  import_14.DynamicParserBackend: (a1) => new import_14.DynamicParserBackend(a1),
  import_15.Lexer: () => new import_15.Lexer(),
  import_13.CacheRegister: () => new import_13.CacheRegister(),
  import_16.AHref: (a1, a2) => new import_16.AHref(a1, a2),
  import_16.NgBaseCss: () => new import_16.NgBaseCss(),
  import_16.NgBind: (a1, a2) => new import_16.NgBind(a1, a2),
  import_16.NgBindHtml: (a1, a2) => new import_16.NgBindHtml(a1, a2),
  import_16.NgBindTemplate: (a1) => new import_16.NgBindTemplate(a1),
  import_16.NgClass: (a1, a2, a3) => new import_16.NgClass(a1, a2, a3),
  import_16.NgClassOdd: (a1, a2, a3) => new import_16.NgClassOdd(a1, a2, a3),
  import_16.NgClassEven: (a1, a2, a3) => new import_16.NgClassEven(a1, a2, a3),
  import_16.NgEvent: (a1, a2) => new import_16.NgEvent(a1, a2),
  import_16.NgCloak: (a1, a2) => new import_16.NgCloak(a1, a2),
  import_16.NgIf: (a1, a2, a3) => new import_16.NgIf(a1, a2, a3),
  import_16.NgUnless: (a1, a2, a3) => new import_16.NgUnless(a1, a2, a3),
  import_16.NgInclude: (a1, a2, a3, a4, a5) => new import_16.NgInclude(a1, a2, a3, a4, a5),
  import_16.NgModel: (a1, a2, a3, a4, a5, a6) => new import_16.NgModel(a1, a2, a3, a4, a5, a6),
  import_16.InputCheckbox: (a1, a2, a3, a4, a5, a6) => new import_16.InputCheckbox(a1, a2, a3, a4, a5, a6),
  import_16.InputTextLike: (a1, a2, a3, a4) => new import_16.InputTextLike(a1, a2, a3, a4),
  import_16.InputNumberLike: (a1, a2, a3, a4) => new import_16.InputNumberLike(a1, a2, a3, a4),
  import_16.NgBindTypeForDateLike: (a1) => new import_16.NgBindTypeForDateLike(a1),
  import_16.InputDateLike: (a1, a2, a3, a4, a5) => new import_16.InputDateLike(a1, a2, a3, a4, a5),
  import_16.NgValue: (a1) => new import_16.NgValue(a1),
  import_16.NgTrueValue: (a1) => new import_16.NgTrueValue(a1),
  import_16.NgFalseValue: (a1) => new import_16.NgFalseValue(a1),
  import_16.InputRadio: (a1, a2, a3, a4, a5) => new import_16.InputRadio(a1, a2, a3, a4, a5),
  import_16.ContentEditable: (a1, a2, a3, a4) => new import_16.ContentEditable(a1, a2, a3, a4),
  import_16.NgPluralize: (a1, a2, a3, a4) => new import_16.NgPluralize(a1, a2, a3, a4),
  import_16.NgRepeat: (a1, a2, a3, a4, a5) => new import_16.NgRepeat(a1, a2, a3, a4, a5),
  import_16.NgTemplate: (a1, a2) => new import_16.NgTemplate(a1, a2),
  import_16.NgHide: (a1, a2) => new import_16.NgHide(a1, a2),
  import_16.NgShow: (a1, a2) => new import_16.NgShow(a1, a2),
  import_16.NgBooleanAttribute: (a1) => new import_16.NgBooleanAttribute(a1),
  import_16.NgSource: (a1) => new import_16.NgSource(a1),
  import_16.NgAttribute: (a1) => new import_16.NgAttribute(a1),
  import_16.NgStyle: (a1, a2) => new import_16.NgStyle(a1, a2),
  import_16.NgSwitch: (a1) => new import_16.NgSwitch(a1),
  import_16.NgSwitchWhen: (a1, a2, a3, a4) => new import_16.NgSwitchWhen(a1, a2, a3, a4),
  import_16.NgSwitchDefault: (a1, a2, a3, a4) => new import_16.NgSwitchDefault(a1, a2, a3, a4),
  import_16.NgNonBindable: () => new import_16.NgNonBindable(),
  import_16.InputSelect: (a1, a2, a3, a4) => new import_16.InputSelect(a1, a2, a3, a4),
  import_16.OptionValue: (a1, a2, a3) => new import_16.OptionValue(a1, a2, a3),
  import_16.NgForm: (a1, a2, a3, a4) => new import_16.NgForm(a1, a2, a3, a4),
  import_16.NgModelRequiredValidator: (a1) => new import_16.NgModelRequiredValidator(a1),
  import_16.NgModelUrlValidator: (a1) => new import_16.NgModelUrlValidator(a1),
  import_16.NgModelColorValidator: (a1) => new import_16.NgModelColorValidator(a1),
  import_16.NgModelEmailValidator: (a1) => new import_16.NgModelEmailValidator(a1),
  import_16.NgModelNumberValidator: (a1) => new import_16.NgModelNumberValidator(a1),
  import_16.NgModelMaxNumberValidator: (a1) => new import_16.NgModelMaxNumberValidator(a1),
  import_16.NgModelMinNumberValidator: (a1) => new import_16.NgModelMinNumberValidator(a1),
  import_16.NgModelPatternValidator: (a1) => new import_16.NgModelPatternValidator(a1),
  import_16.NgModelMinLengthValidator: (a1) => new import_16.NgModelMinLengthValidator(a1),
  import_16.NgModelMaxLengthValidator: (a1) => new import_16.NgModelMaxLengthValidator(a1),
  import_16.NgModelOptions: () => new import_16.NgModelOptions(),
  import_3.ExceptionHandler: () => new import_3.ExceptionHandler(),
  import_3.Interpolate: (a1) => new import_3.Interpolate(a1),
  import_3.ScopeDigestTTL: () => new import_3.ScopeDigestTTL(),
  import_3.ScopeStats: (a1, a2) => new import_3.ScopeStats(a1, a2),
  import_3.ScopeStatsEmitter: () => new import_3.ScopeStatsEmitter(),
  import_3.ScopeStatsConfig: () => new import_3.ScopeStatsConfig(),
  import_3.RootScope: (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) => new import_3.RootScope(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10),
  import_10.ASTParser: (a1, a2) => new import_10.ASTParser(a1, a2),
  import_19.Currency: () => new import_19.Currency(),
  import_19.Date: () => new import_19.Date(),
  import_19.Filter: (a1) => new import_19.Filter(a1),
  import_19.Json: () => new import_19.Json(),
  import_19.LimitTo: (a1) => new import_19.LimitTo(a1),
  import_19.Lowercase: () => new import_19.Lowercase(),
  import_19.Arrayify: () => new import_19.Arrayify(),
  import_19.Number: () => new import_19.Number(),
  import_19.OrderBy: (a1) => new import_19.OrderBy(a1),
  import_19.Uppercase: () => new import_19.Uppercase(),
  import_19.Stringify: () => new import_19.Stringify(),
  import_20.AnimationLoop: (a1, a2, a3) => new import_20.AnimationLoop(a1, a2, a3),
  import_20.AnimationFrame: (a1) => new import_20.AnimationFrame(a1),
  import_20.AnimationOptimizer: (a1) => new import_20.AnimationOptimizer(a1),
  import_20.CssAnimate: (a1, a2, a3) => new import_20.CssAnimate(a1, a2, a3),
  import_20.CssAnimationMap: () => new import_20.CssAnimationMap(),
  import_20.NgAnimate: (a1, a2) => new import_20.NgAnimate(a1, a2),
  import_20.NgAnimateChildren: (a1, a2) => new import_20.NgAnimateChildren(a1, a2),
  import_21.NgRoutingUsePushState: () => new import_21.NgRoutingUsePushState(),
  import_21.NgRoutingHelper: (a1, a2, a3, a4) => new import_21.NgRoutingHelper(a1, a2, a3, a4),
  import_21.NgView: (a1, a2, a3, a4, a5, a6) => new import_21.NgView(a1, a2, a3, a4, a5, a6),
  import_21.NgBindRoute: (a1, a2, a3) => new import_21.NgBindRoute(a1, a2, a3),
  import_24.JsCacheRegister: (a1) => new import_24.JsCacheRegister(a1),
  import_1.QueryService: (a1, a2) => new import_1.QueryService(a1, a2),
  import_25.RssDatabase: () => new import_25.RssDatabase(),
  import_26.AppComm: (a1) => new import_26.AppComm(a1),
  import_27.RssController: () => new import_27.RssController(),
  import_28.PostsListFormatter: () => new import_28.PostsListFormatter(),
  import_29.ImageService: (a1) => new import_29.ImageService(a1),
  import_30.StarringComponent: () => new import_30.StarringComponent(),
  import_31.FeedListComponent: (a1) => new import_31.FeedListComponent(a1),
  import_32.AppHeaderComponent: (a1, a2, a3, a4) => new import_32.AppHeaderComponent(a1, a2, a3, a4),
  import_33.AppEvents: () => new import_33.AppEvents(),
  import_34.DataHandlerComponent: (a1, a2, a3) => new import_34.DataHandlerComponent(a1, a2, a3),
  import_35.PostComponent: (a1, a2, a3) => new import_35.PostComponent(a1, a2, a3),
  import_36.TruncateFilter: () => new import_36.TruncateFilter(),
  import_37.MenuComponent: () => new import_37.MenuComponent(),
  import_38.PubdateComponent: () => new import_38.PubdateComponent(),
  import_39.AppIcon: (a1) => new import_39.AppIcon(a1),
  import_40.FeedEntriesComponent: (a1) => new import_40.FeedEntriesComponent(a1),
  import_41.RelativeDateFilter: () => new import_41.RelativeDateFilter(),
  import_41.RelativeDayFilter: () => new import_41.RelativeDayFilter(),
  import_42.ListArticleComponent: (a1, a2) => new import_42.ListArticleComponent(a1, a2),
  import_43.MenuItemDecorator: (a1) => new import_43.MenuItemDecorator(a1),
  import_44.EntriesListComponent: (a1) => new import_44.EntriesListComponent(a1),
  import_4.Profiler: () => new import_4.Profiler(),
};
final Map<Type, List<Key>> parameterKeys = {
  import_0.UnreadCounterComponent: [_KEY_QueryService],
  import_2.Animate: const[],
  import_2.BrowserCookies: [_KEY_ExceptionHandler],
  import_2.Cookies: [_KEY_BrowserCookies],
  import_2.Compiler: [_KEY_Profiler, _KEY_Expando],
  import_2.CompilerConfig: const[],
  import_2.DirectiveMap: [_KEY_Injector, _KEY_FormatterMap, _KEY_MetadataExtractor, _KEY_DirectiveSelectorFactory],
  import_2.ElementBinderFactory: [_KEY_Parser, _KEY_Profiler, _KEY_CompilerConfig, _KEY_Expando, _KEY_ASTParser, _KEY_ComponentFactory, _KEY_ShadowDomComponentFactory, _KEY_TranscludingComponentFactory],
  import_2.EventHandler: [_KEY_Node, _KEY_Expando, _KEY_ExceptionHandler],
  import_2.ShadowRootEventHandler: [_KEY_ShadowRoot, _KEY_Expando, _KEY_ExceptionHandler],
  import_2.UrlRewriter: const[],
  import_2.HttpBackend: const[],
  import_2.LocationWrapper: const[],
  import_2.HttpInterceptors: const[],
  import_2.HttpDefaultHeaders: const[],
  import_2.HttpDefaults: [_KEY_HttpDefaultHeaders],
  import_2.Http: [_KEY_BrowserCookies, _KEY_LocationWrapper, _KEY_UrlRewriter, _KEY_HttpBackend, _KEY_HttpDefaults, _KEY_HttpInterceptors, _KEY_RootScope, _KEY_HttpConfig, _KEY_VmTurnZone],
  import_2.HttpConfig: const[],
  import_2.TextMustache: [_KEY_Node, _KEY_AST, _KEY_Scope],
  import_2.AttrMustache: [_KEY_NodeAttrs, _KEY_String, _KEY_AST, _KEY_Scope],
  import_2.NgElement: [_KEY_Element, _KEY_Scope, _KEY_Animate],
  import_2.DirectiveSelectorFactory: [_KEY_ElementBinderFactory, _KEY_Interpolate, _KEY_ASTParser, _KEY_FormatterMap, _KEY_Injector],
  import_2.ShadowDomComponentFactory: [_KEY_ViewCache, _KEY_Http, _KEY_TemplateCache, _KEY_WebPlatform, _KEY_ComponentCssRewriter, _KEY_NodeTreeSanitizer, _KEY_Expando, _KEY_CompilerConfig, _KEY_CacheRegister],
  import_2.ComponentCssRewriter: const[],
  import_2.Content: [_KEY_ContentPort, _KEY_Element],
  import_2.TranscludingComponentFactory: [_KEY_Expando, _KEY_ViewCache, _KEY_CompilerConfig],
  import_2.NullTreeSanitizer: const[],
  import_2.ViewCache: [_KEY_Http, _KEY_TemplateCache, _KEY_Compiler, _KEY_NodeTreeSanitizer, _KEY_CacheRegister],
  import_2.WebPlatform: const[],
  import_7.FormatterMap: [_KEY_Injector, _KEY_MetadataExtractor],
  import_14.DynamicParser: [_KEY_Lexer, _KEY_ParserBackend, _KEY_CacheRegister],
  import_14.DynamicParserBackend: [_KEY_ClosureMap],
  import_15.Lexer: const[],
  import_13.CacheRegister: const[],
  import_16.AHref: [_KEY_Element, _KEY_VmTurnZone],
  import_16.NgBaseCss: const[],
  import_16.NgBind: [_KEY_Element, _KEY_ElementProbe],
  import_16.NgBindHtml: [_KEY_Element, _KEY_NodeValidator],
  import_16.NgBindTemplate: [_KEY_Element],
  import_16.NgClass: [_KEY_NgElement, _KEY_Scope, _KEY_NodeAttrs],
  import_16.NgClassOdd: [_KEY_NgElement, _KEY_Scope, _KEY_NodeAttrs],
  import_16.NgClassEven: [_KEY_NgElement, _KEY_Scope, _KEY_NodeAttrs],
  import_16.NgEvent: [_KEY_Element, _KEY_Scope],
  import_16.NgCloak: [_KEY_Element, _KEY_Animate],
  import_16.NgIf: [_KEY_ViewFactory, _KEY_ViewPort, _KEY_Scope],
  import_16.NgUnless: [_KEY_ViewFactory, _KEY_ViewPort, _KEY_Scope],
  import_16.NgInclude: [_KEY_Element, _KEY_Scope, _KEY_ViewCache, _KEY_DirectiveInjector, _KEY_DirectiveMap],
  import_16.NgModel: [_KEY_Scope, _KEY_NgElement, _KEY_DirectiveInjector, _KEY_NodeAttrs, _KEY_Animate, _KEY_ElementProbe],
  import_16.InputCheckbox: [_KEY_Element, _KEY_NgModel, _KEY_Scope, _KEY_NgTrueValue, _KEY_NgFalseValue, _KEY_NgModelOptions],
  import_16.InputTextLike: [_KEY_Element, _KEY_NgModel, _KEY_Scope, _KEY_NgModelOptions],
  import_16.InputNumberLike: [_KEY_Element, _KEY_NgModel, _KEY_Scope, _KEY_NgModelOptions],
  import_16.NgBindTypeForDateLike: [_KEY_Element],
  import_16.InputDateLike: [_KEY_Element, _KEY_NgModel, _KEY_Scope, _KEY_NgBindTypeForDateLike, _KEY_NgModelOptions],
  import_16.NgValue: [_KEY_Element],
  import_16.NgTrueValue: [_KEY_Element],
  import_16.NgFalseValue: [_KEY_Element],
  import_16.InputRadio: [_KEY_Element, _KEY_NgModel, _KEY_Scope, _KEY_NgValue, _KEY_NodeAttrs],
  import_16.ContentEditable: [_KEY_Element, _KEY_NgModel, _KEY_Scope, _KEY_NgModelOptions],
  import_16.NgPluralize: [_KEY_Scope, _KEY_Element, _KEY_Interpolate, _KEY_FormatterMap],
  import_16.NgRepeat: [_KEY_ViewPort, _KEY_BoundViewFactory, _KEY_Scope, _KEY_Parser, _KEY_FormatterMap],
  import_16.NgTemplate: [_KEY_Element, _KEY_TemplateCache],
  import_16.NgHide: [_KEY_Element, _KEY_Animate],
  import_16.NgShow: [_KEY_Element, _KEY_Animate],
  import_16.NgBooleanAttribute: [_KEY_NgElement],
  import_16.NgSource: [_KEY_NgElement],
  import_16.NgAttribute: [_KEY_NodeAttrs],
  import_16.NgStyle: [_KEY_Element, _KEY_Scope],
  import_16.NgSwitch: [_KEY_Scope],
  import_16.NgSwitchWhen: [_KEY_NgSwitch, _KEY_ViewPort, _KEY_BoundViewFactory, _KEY_Scope],
  import_16.NgSwitchDefault: [_KEY_NgSwitch, _KEY_ViewPort, _KEY_BoundViewFactory, _KEY_Scope],
  import_16.NgNonBindable: const[],
  import_16.InputSelect: [_KEY_Element, _KEY_NodeAttrs, _KEY_NgModel, _KEY_Scope],
  import_16.OptionValue: [_KEY_Element, _KEY_InputSelect, _KEY_NgValue],
  import_16.NgForm: [_KEY_Scope, _KEY_NgElement, _KEY_DirectiveInjector, _KEY_Animate],
  import_16.NgModelRequiredValidator: [_KEY_NgModel],
  import_16.NgModelUrlValidator: [_KEY_NgModel],
  import_16.NgModelColorValidator: [_KEY_NgModel],
  import_16.NgModelEmailValidator: [_KEY_NgModel],
  import_16.NgModelNumberValidator: [_KEY_NgModel],
  import_16.NgModelMaxNumberValidator: [_KEY_NgModel],
  import_16.NgModelMinNumberValidator: [_KEY_NgModel],
  import_16.NgModelPatternValidator: [_KEY_NgModel],
  import_16.NgModelMinLengthValidator: [_KEY_NgModel],
  import_16.NgModelMaxLengthValidator: [_KEY_NgModel],
  import_16.NgModelOptions: const[],
  import_3.ExceptionHandler: const[],
  import_3.Interpolate: [_KEY_CacheRegister],
  import_3.ScopeDigestTTL: const[],
  import_3.ScopeStats: [_KEY_ScopeStatsEmitter, _KEY_ScopeStatsConfig],
  import_3.ScopeStatsEmitter: const[],
  import_3.ScopeStatsConfig: const[],
  import_3.RootScope: [_KEY_Object, _KEY_Parser, _KEY_ASTParser, _KEY_FieldGetterFactory, _KEY_FormatterMap, _KEY_ExceptionHandler, _KEY_ScopeDigestTTL, _KEY_VmTurnZone, _KEY_ScopeStats, _KEY_CacheRegister],
  import_10.ASTParser: [_KEY_Parser, _KEY_ClosureMap],
  import_19.Currency: const[],
  import_19.Date: const[],
  import_19.Filter: [_KEY_Parser],
  import_19.Json: const[],
  import_19.LimitTo: [_KEY_Injector],
  import_19.Lowercase: const[],
  import_19.Arrayify: const[],
  import_19.Number: const[],
  import_19.OrderBy: [_KEY_Parser],
  import_19.Uppercase: const[],
  import_19.Stringify: const[],
  import_20.AnimationLoop: [_KEY_AnimationFrame, _KEY_Profiler, _KEY_VmTurnZone],
  import_20.AnimationFrame: [_KEY_Window],
  import_20.AnimationOptimizer: [_KEY_Expando],
  import_20.CssAnimate: [_KEY_AnimationLoop, _KEY_CssAnimationMap, _KEY_AnimationOptimizer],
  import_20.CssAnimationMap: const[],
  import_20.NgAnimate: [_KEY_Element, _KEY_AnimationOptimizer],
  import_20.NgAnimateChildren: [_KEY_Element, _KEY_AnimationOptimizer],
  import_21.NgRoutingUsePushState: const[],
  import_21.NgRoutingHelper: [_KEY_RouteInitializer, _KEY_Injector, _KEY_Router, _KEY_Application],
  import_21.NgView: [_KEY_Element, _KEY_ViewCache, _KEY_DirectiveInjector, _KEY_Injector, _KEY_Router, _KEY_Scope],
  import_21.NgBindRoute: [_KEY_Router, _KEY_DirectiveInjector, _KEY_NgRoutingHelper],
  import_24.JsCacheRegister: [_KEY_CacheRegister],
  import_1.QueryService: [_KEY_Http, _KEY_RssDatabase],
  import_25.RssDatabase: const[],
  import_26.AppComm: [_KEY_QueryService],
  import_27.RssController: const[],
  import_28.PostsListFormatter: const[],
  import_29.ImageService: [_KEY_Http],
  import_30.StarringComponent: const[],
  import_31.FeedListComponent: [_KEY_QueryService],
  import_32.AppHeaderComponent: [_KEY_QueryService, _KEY_Router, _KEY_AppEvents, _KEY_AppComm],
  import_33.AppEvents: const[],
  import_34.DataHandlerComponent: [_KEY_RouteProvider, _KEY_Router, _KEY_QueryService],
  import_35.PostComponent: [_KEY_RouteProvider, _KEY_QueryService, _KEY_ImageService],
  import_36.TruncateFilter: const[],
  import_37.MenuComponent: const[],
  import_38.PubdateComponent: const[],
  import_39.AppIcon: [_KEY_Element],
  import_40.FeedEntriesComponent: [_KEY_QueryService],
  import_41.RelativeDateFilter: const[],
  import_41.RelativeDayFilter: const[],
  import_42.ListArticleComponent: [_KEY_QueryService, _KEY_Router],
  import_43.MenuItemDecorator: [_KEY_Element],
  import_44.EntriesListComponent: [_KEY_QueryService],
  import_4.Profiler: const[],
};
setStaticReflectorAsDefault() => Module.DEFAULT_REFLECTOR = new GeneratedTypeFactories(typeFactories, parameterKeys);
