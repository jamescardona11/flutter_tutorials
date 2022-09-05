// import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// extension Log on Object {
//   void log() => devtools.log(toString());
// }

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}

void testIt() async {
  final stream1 = Stream.periodic(
      const Duration(seconds: 1), (count) => 'Stream 1, count = $count');

  final stream2 = Stream.periodic(
      const Duration(seconds: 3), (count) => 'Stream 2, count = $count');

  final combined =
      Rx.combineLatest2(stream1, stream2, (a, b) => 'One = $a, Two = $b');

  await for (final value in combined) {
    // value.log();
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    testIt();
    return Scaffold(
      appBar: AppBar(
        title: Text('AppBar Text'),
      ),
      body: Center(
        child: Text('New Page'),
      ),
    );
  }
}
