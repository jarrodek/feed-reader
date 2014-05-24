// Copyright (C) 2013 - 2014 Angular Dart UI authors. Please see AUTHORS.md.
// https://github.com/akserg/angular.dart.ui
// All rights reserved.  Please see the LICENSE.md file.
library angular.ui.accordion;

import 'package:angular/angular.dart';
//import 'package:angular_ui/app/injectable_service.dart';
import 'package:angular/utils.dart' as utils;
import 'package:logging/logging.dart' show Logger;

part 'accordion_group.dart';

final _log = new Logger('angular.ui.accordion');

class AccordionModule extends Module {
  AccordionModule() {
    bind(AccordionComponent);
    bind(AccordionHeadingComponent);
    bind(AccordionGroupComponent);
    bind(AccordionConfig, toValue:new AccordionConfig());
  }
}

@Injectable()
class AccordionConfig {
  bool closeOthers = true;
}

@Component(
    selector: 'accordion',
    publishAs: 'ctrl',
    visibility: Directive.CHILDREN_VISIBILITY,
    templateUrl: 'packages/angular_ui/accordion/accordion.html',
    applyAuthorStyles: true
)
@Component(
    selector: '[accordion]',
    publishAs: 'ctrl',
    visibility: Directive.CHILDREN_VISIBILITY,
    templateUrl: 'packages/angular_ui/accordion/accordion.html',
    applyAuthorStyles: true
)
class AccordionComponent {
  @NgTwoWay('close-others') bool isCloseOthers;

  final Scope scope;
  final AccordionConfig _config;

  /*
   * This array keeps track of the accordion groups
   */
  List<AccordionGroupComponent> groups = [];

  AccordionComponent(this.scope, this._config)
  {
    _log.fine('AccordionComponent');
  }

  /*
   * Ensure that all the groups in this accordion are closed, unless close-others explicitly says not to
   */
  void closeOthers(AccordionGroupComponent openGroup) {
    isCloseOthers = isCloseOthers != null ? isCloseOthers : _config.closeOthers;
    if(isCloseOthers) {
      groups.forEach((e) {
        if(e != openGroup) {
          e.isOpen = false;
        }
      });
    }
  }

  /*
   * This is called from the accordion-group directive to add itself to the accordion
   */
  void addGroup(AccordionGroupComponent groupScope) {
    groups.add(groupScope);
  }

  /*
   *  This is called from the accordion-group directive when to remove itself
   */
  void removeGroup(AccordionGroupComponent groupScope) {
    groups.remove(groupScope);
  }
}
