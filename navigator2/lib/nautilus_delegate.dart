import 'package:flutter/material.dart';

import 'nautilus_page.dart';
import 'nav_route.dart';
import 'navigator_actions.dart';
import 'rubber_route.dart';

class ElevenNavDelegate extends RouterDelegate<String>
    with ChangeNotifier
    implements NavigationActions {
  //PopNavigatorRouterDelegateMixin<String>,
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  ElevenNavDelegate({
    required this.routes,
    required this.navBuilder,
    this.initialRoute,
  }) {
    _initFirstRoute();
  }

  final String? initialRoute;
  final List<ElevenNavRoute> routes;
  final ProviderBuilder navBuilder;

  late List<ElevenNavPage> pages;

  Future<void> nav(String location) async {
    // search
    final elevenNavRoute =
        routes.firstWhere((element) => element.path == location);

    print('eleveNavRoute $elevenNavRoute');

    pages = [
      ...pages,
      ElevenNavPage(
        key: ValueKey(elevenNavRoute.path),
        name: elevenNavRoute.path,
        child: elevenNavRoute.handler,
      )
    ];

    notifyListeners();
  }

  // @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    return navBuilder.call(
      Navigator(
        key: navigatorKey,
        pages: pages,
        onPopPage: (route, dynamic result) {
          if (!route.didPop(result)) return false;
          // pop();
          return true;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(String configuration) async {
    print('setNewRoutePath: $configuration');
  }

  @override
  Future<bool> popRoute() async {
    return false;
  }

  @override
  Future<R?> navigate<R extends dynamic>(ElevenNavRoute route) async {}

  @override
  Future<R?> navigateNamed<R extends dynamic>(String name) async {}

  @override
  Future<void> start(ElevenNavRoute route) async {}

  @override
  Future<void> startNamed(String route) async {}

  @override
  Future<void> replace(ElevenNavRoute route) async {}

  @override
  void pop() async {}

  @override
  Future<void> popUntilFirst() async {}

  @override
  Future<void> popUntil(String route) async {}

  void _initFirstRoute() {
    final index = _initialRouteIndex();

    pages = [
      ElevenNavPage(
        key: ValueKey(routes[index].path),
        name: routes[index].path,
        child: routes.first.handler,
      ),
    ];
  }

  int _initialRouteIndex() {
    if (initialRoute == null || initialRoute!.isEmpty) {
      return 0;
    }

    bool isPath = initialRoute!.startsWith('/');
    int index = 0;

    if (isPath) {
      index = routes.indexWhere((element) => element.path == initialRoute);
    }

    return index > 0 ? index : 0;
  }
}
