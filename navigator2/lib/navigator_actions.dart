import 'nav_route.dart';

abstract class NavigationActions {
  Future<R?> navigate<R extends dynamic>(ElevenNavRoute route);

  Future<void> start(ElevenNavRoute route);

  Future<void> replace(ElevenNavRoute route);

  void pop();

  Future<void> popUntilFirst();

  Future<void> popUntil(String route);
}
