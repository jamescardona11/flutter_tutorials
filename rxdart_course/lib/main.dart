import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

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

class HomePage extends HookWidget {
  /// default constructor
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create our behavior subject every time widget is re-built
    final subject = useMemoized(
      () => BehaviorSubject<String>(),
      [key],
    );

    // dispose of the old subject every time widget is re-built
    useEffect(
      () => subject.close,
      [subject],
    );

    return Scaffold(
      body: Center(
        child: Text('Hello New Page'),
      ),
    );
  }
}

class HomePage2 extends StatefulWidget {
  /// default constructor
  const HomePage2({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  late final BehaviorSubject<String> subject;

  @override
  void initState() {
    super.initState();
    subject = BehaviorSubject<String>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Hello New Page'),
      ),
    );
  }

  @override
  void dispose() async {
    await subject.close();
    super.dispose();
  }
}
