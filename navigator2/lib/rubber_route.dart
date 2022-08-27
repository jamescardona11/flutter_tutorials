// Information to create the route
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Rubber {
  Rubber({
    this.initialRoute,
    this.routes = const [],
  }) {
    final formatRoutes = routes.map((route) {
      return route.refactorDash();
    });

    delegate = RubberDelegate(
      routes: formatRoutes,
    );
  }

  final String? initialRoute;
  final List<RubberRoute> routes;

  final routeInformationParser = RubberInformationParser();

  late RubberDelegate delegate;
}

class RubberRoute {
  RubberRoute({
    required this.path,
    required this.handler,
    this.name,
    this.routes,
  });

  final String path;
  final HandlerBuilder handler;
  final String? name;
  final List<RubberRoute>? routes;

  RubberRoute refactorDash() => RubberRoute(
        path: startWihDash ? path : '/$path',
        handler: handler,
        name: name,
        routes: routes,
      );

  bool get startWihDash => path.startsWith('/');
}

class RubberPage extends Page {
  final HandlerBuilder child;

  RubberPage({
    required this.child,
  });

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => child.call(
        context,
        RubberState(),
      ),
    );
  }
}

/// Information to navigate
class RubberData {}

class RubberState {}

/// The signature of the widget builder callback for a matched RubberRouter
typedef HandlerBuilder = Widget Function(
  BuildContext context,
  RubberState state,
);

class RubberInformationParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(
    RouteInformation routeInformation,
  ) =>
      SynchronousFuture(routeInformation.location ?? '/');

  @override
  RouteInformation restoreRouteInformation(String configuration) =>
      RouteInformation(location: configuration);
}

class RubberDelegate extends RouterDelegate<String>
    with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  RubberDelegate({
    required this.routes,
    this.initialRoute,
  }) {
    pages = [
      RubberPage(
        child: routes.first.handler,
      ),
    ];
  }

  final String? initialRoute;
  final Iterable<RubberRoute> routes;
  late List<RubberPage> pages;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: pages,
    );
  }

  @override
  Future<void> setNewRoutePath(String configuration) async {
    print('setNewRoutePath: $configuration');
  }
}
