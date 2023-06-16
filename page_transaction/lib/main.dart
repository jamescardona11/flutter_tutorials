import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'page_transition_2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PageTransition2(),
      ),
    );
  }
}
