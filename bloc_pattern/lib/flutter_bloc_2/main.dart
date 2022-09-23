import 'package:flutter/material.dart';

import 'products_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ProductBloc bloc = ProductBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<String>>(
        stream: bloc.getProducts,
        initialData: [],
        builder: (_, snapshot) {
          final prds = snapshot.data ?? [];

          return ListView.builder(
            itemCount: prds.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(prds[i]),
            ),
          );
        },
      ),
    );
  }
}
