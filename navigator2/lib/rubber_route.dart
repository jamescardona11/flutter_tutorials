// Information to create the route
import 'package:flutter/material.dart';
import 'package:navigator2/navigator_actions.dart';

import 'nautilus_delegate.dart';
import 'nautilus_parser.dart';
import 'nautilus_provider.dart';
import 'nav_route.dart';

//Nautilus, Bismarck

/// PATH STRATEGY
/// https://github.com/tomgilder/routemaster/tree/main/lib/src
/// https://github.com/HosseinYousefi/yeet/blob/master/lib/src/yeet_transition.dart
/// https://github.com/dleurs/Flutter-Navigator-2.0-demo-with-Authentication-mecanism
/// https://github.com/slovnicki/beamer/blob/master/package/lib/src/path_url_strategy_web.dart
/// https://github.com/slovnicki/beamer/blob/master/package/lib/src/beamer_delegate.dart
/// https://github.com/csells/go_router/blob/main/go_router/lib/src/go_router_delegate.dart
/// FLURO

class ElevenNav implements NavigationActions {
  ElevenNav({
    this.initialRoute,
    this.routes = const [],
  }) {
    final formatRoutes = routes.map((route) => route.refactorDash()).toList();

    _delegate = ElevenNavDelegate(
      routes: formatRoutes,
      navBuilder: (nav) => ElevenNavProvider(
        elevenNav: this,
        child: nav,
      ),
    );
  }

  final String? initialRoute;
  final List<ElevenNavRoute> routes;

  final _routeInformationParser = ElevenNavInformationParser();
  late ElevenNavDelegate _delegate;

  ElevenNavDelegate get delegate => _delegate;
  ElevenNavInformationParser get parser => _routeInformationParser;

  static ElevenNav of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<ElevenNavProvider>();
    assert(inherited != null, 'No ElevenNav found in context');
    return inherited!.elevenNav;
  }

  @override
  Future<R?> navigate<R extends dynamic>(ElevenNavRoute route) {
    // TODO: implement navigate
    throw UnimplementedError();
  }

  @override
  Future<R?> navigateNamed<R extends dynamic>(String name) {
    // TODO: implement navigateNamed
    throw UnimplementedError();
  }

  @override
  void pop() {
    // TODO: implement pop
  }

  @override
  Future<void> popUntil(String route) {
    // TODO: implement popUntil
    throw UnimplementedError();
  }

  @override
  Future<void> popUntilFirst() {
    // TODO: implement popUntilFirst
    throw UnimplementedError();
  }

  @override
  Future<void> replace(ElevenNavRoute route) {
    // TODO: implement replace
    throw UnimplementedError();
  }

  @override
  Future<void> start(ElevenNavRoute route) {
    // TODO: implement start
    throw UnimplementedError();
  }

  @override
  Future<void> startNamed(String route) {
    // TODO: implement startNamed
    throw UnimplementedError();
  }
}

/// Information to navigate send for the user
class ElevenNavData {}

/// Information before navigate send for delegate
class ElevenNavState {}

/// The signature of the widget builder callback for a matched ElevenNavRouter

typedef ProviderBuilder = Widget Function(Navigator nav);
