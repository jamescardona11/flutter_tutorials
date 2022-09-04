import 'package:flutter/material.dart';

import 'rubber_route.dart';

typedef HandlerBuilder = Widget Function(
  BuildContext context,
  ElevenNavState state,
);

class ElevenNavPage extends Page {
  const ElevenNavPage({
    required this.child,
    super.name,
    super.key,
  });

  final HandlerBuilder child;

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
