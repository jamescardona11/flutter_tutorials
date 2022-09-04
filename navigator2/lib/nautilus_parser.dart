import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
