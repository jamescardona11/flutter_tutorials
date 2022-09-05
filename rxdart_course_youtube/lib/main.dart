import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

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

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final BehaviorSubject<DateTime> subject;
  late final Stream<String> streamOfStrings;

  @override
  void initState() {
    super.initState();

    subject = BehaviorSubject<DateTime>();
    streamOfStrings = subject.switchMap(
      (dateTime) => Stream.periodic(const Duration(seconds: 1),
          (count) => 'Stream count= $count, dateTime = $dateTime'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AppBar Text'),
      ),
      body: Column(
        children: [
          StreamBuilder<String>(
            stream: streamOfStrings,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.requireData);
              } else {
                return Text('Waiting for the boton');
              }
            },
          ),
          TextButton(
            onPressed: () {
              subject.add(DateTime.now());
            },
            child: Text('Start this string'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }
}
