import 'package:flutter/material.dart';

import 'rubber_route.dart';

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
