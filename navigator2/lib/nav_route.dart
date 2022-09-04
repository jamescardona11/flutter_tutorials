import 'nautilus_page.dart';

class ElevenNavRoute {
  ElevenNavRoute({
    required this.path,
    required this.handler,
    this.routes,
  });

  final String path;
  final HandlerBuilder handler;
  final List<ElevenNavRoute>? routes;

  ElevenNavRoute refactorDash() => ElevenNavRoute(
        path: startWihDash ? path : '/$path',
        handler: handler,
        routes: routes,
      );

  bool get startWihDash => path.startsWith('/');

  @override
  String toString() => 'ElevenNavRoute= path: $path';
}
