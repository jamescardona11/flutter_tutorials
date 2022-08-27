import 'package:flutter/material.dart';

import 'rubber_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = ElevenNav(routes: [
      ElevenNavRoute(
        path: '/',
        handler: (context, state) => HomePage(),
      ),
      ElevenNavRoute(
        path: '/detail',
        handler: (context, state) => DetailPage(from: 'No se'),
      ),
    ]);

    return MaterialApp.router(
      title: 'Material App',
      routeInformationParser: router.parser,
      routerDelegate: router.delegate,
      // home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  /// default constructor
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: Center(
        child: Container(
          child: GestureDetector(
            onTap: () {
              print('Here');
              ElevenNav.of(context).nav('/detail');
            },
            child: Text('Go To detail'),
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  /// default constructor
  const DetailPage({
    super.key,
    required this.from,
  });

  final String from;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DetailPage'),
      ),
      body: Center(
        child: Container(
          child: Text('FROM $from'),
        ),
      ),
    );
  }
}
