import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    testZip();
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

void testZip() async {
  final stream1 =
      Stream.periodic(const Duration(seconds: 1), (count) => '$count').take(10);

  final stream2 = Stream<String>.periodic(
          const Duration(seconds: 3), (count) => 'Stream 2, count = $count')
      .take(3);

  final zip = stream1.zipWith(stream2, (t, String s) => t + s);

  await for (final value in zip) {
    value.log();
  }
}

void testMerge() async {
  final stream1 =
      Stream.periodic(const Duration(seconds: 1), (count) => '$count').take(10);

  final stream2 = Stream.periodic(
          const Duration(seconds: 3), (count) => 'Stream 2, count = $count')
      .take(3);

  final merge = stream1.mergeWith([stream2]);

  await for (final value in merge) {
    value.log();
  }
}

void testItCombined() async {
  final stream1 = Stream.periodic(
      const Duration(seconds: 1), (count) => 'Stream 1, count = $count');

  final stream2 = Stream.periodic(
      const Duration(seconds: 3), (count) => 'Stream 2, count = $count');

  final combined =
      Rx.combineLatest2(stream1, stream2, (a, b) => 'One = $a, Two = $b');

  await for (final value in combined) {
    value.log();
  }
}

void testConcat() async {
  final stream1 =
      Stream.periodic(const Duration(seconds: 1), (count) => '$count').take(10);

  final stream2 = Stream.periodic(
          const Duration(seconds: 3), (count) => 'Stream 2, count = $count')
      .take(3);

  final concat = stream1.concatWith([stream2]);

  await for (final value in concat) {
    value.log();
  }
}
