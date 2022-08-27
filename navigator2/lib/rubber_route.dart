// Information to create the route
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ElevenNav {
  ElevenNav({
    this.initialRoute,
    this.routes = const [],
  }) {
    final formatRoutes = routes.map((route) {
      return route.refactorDash();
    });

    _delegate = ElevenNavDelegate(
      routes: formatRoutes,
      navBuilder: (nav) => ElevenNavProvider(
        elevenNav: this,
        child: nav,
      ),
    );
  }
  late ElevenNavDelegate _delegate;
  final _routeInformationParser = ElevenNavInformationParser();

  final String? initialRoute;
  final List<ElevenNavRoute> routes;

  Future<void> nav(String location) async {
    _delegate.nav(location);
  }

  static ElevenNav of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<ElevenNavProvider>();
    assert(inherited != null, 'No ElevenNav found in context');
    return inherited!.elevenNav;
  }

  ElevenNavDelegate get delegate => _delegate;
  ElevenNavInformationParser get parser => _routeInformationParser;
}

class ElevenNavRoute {
  ElevenNavRoute({
    required this.path,
    required this.handler,
    this.name,
    this.routes,
  });

  final String path;
  final HandlerBuilder handler;
  final String? name;
  final List<ElevenNavRoute>? routes;

  ElevenNavRoute refactorDash() => ElevenNavRoute(
        path: startWihDash ? path : '/$path',
        handler: handler,
        name: name,
        routes: routes,
      );

  bool get startWihDash => path.startsWith('/');

  @override
  String toString() => 'ElevenNavRoute= path: $path';
}

class ElevenNavPage extends Page {
  ElevenNavPage({
    required this.child,
    super.name,
    super.key,
  });

  final HandlerBuilder child;
  // final String name;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => child.call(
        context,
        ElevenNavState(),
      ),
    );
  }
}

/// Information to navigate send for the user
class ElevenNavData {}

/// Information before navigate send for delegate
class ElevenNavState {}

/// The signature of the widget builder callback for a matched ElevenNavRouter
typedef HandlerBuilder = Widget Function(
  BuildContext context,
  ElevenNavState state,
);

typedef ProviderBuilder = Widget Function(Navigator nav);

class ElevenNavInformationParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(
    RouteInformation routeInformation,
  ) =>
      SynchronousFuture(routeInformation.location ?? '/');

  @override
  RouteInformation restoreRouteInformation(String configuration) =>
      RouteInformation(location: configuration);
}

class ElevenNavDelegate extends RouterDelegate<String> with ChangeNotifier {
  //PopNavigatorRouterDelegateMixin<String>,
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  ElevenNavDelegate({
    required this.routes,
    required this.navBuilder,
    this.initialRoute,
  }) {
    pages = [
      ElevenNavPage(
        key: ValueKey(routes.first.path),
        name: routes.first.path,
        child: routes.first.handler,
      ),
      // ElevenNavPage(
      //   key: ValueKey(routes.last.path),
      //   name: routes.last.path,
      //   child: routes.last.handler,
      // ),
    ];
  }

  final String? initialRoute;
  final Iterable<ElevenNavRoute> routes;
  final ProviderBuilder navBuilder;

  late List<ElevenNavPage> pages;

  Future<void> nav(String location) async {
    // search
    final elevenNavRoute =
        routes.firstWhere((element) => element.path == location);

    print('eleveNavRoute $elevenNavRoute');

    // build state

    // pages.add(ElevenNavPage(
    //   key: ValueKey(elevenNavRoute.path),
    //   name: elevenNavRoute.path,
    //   child: elevenNavRoute.handler,
    // ));

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
    print('Build ${pages.length}');
    pages.forEach((element) {
      print(element.name);
    });
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
}

class ElevenNavProvider extends InheritedWidget {
  const ElevenNavProvider({
    Key? key,
    required this.elevenNav,
    required Widget child,
  }) : super(key: key, child: child);

  final ElevenNav elevenNav;

  static ElevenNavProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ElevenNavProvider>();

  @override
  bool updateShouldNotify(covariant ElevenNavProvider oldWidget) => false;
}
