import 'package:flutter/material.dart';

import 'rubber_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = Rubber(routes: [
      RubberRoute(
        path: '/',
        handler: (context, state) => HomePage(),
      ),
      RubberRoute(
        path: '/detail',
        handler: (context, state) => DetailPage(),
      ),
    ]);

    return MaterialApp.router(
      title: 'Material App',
      routeInformationParser: router.routeInformationParser,
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
        title: Text('AppBar Text'),
      ),
      body: Container(
        child: Text('HomePage'),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  /// default constructor
  const DetailPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AppBar Text'),
      ),
      body: Container(
        child: Text('HomePage'),
      ),
    );
  }
}
