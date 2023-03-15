import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fcm_service.dart';
import 'firebase_options.dart';

///THIS METHOD NEEDS TO BE STATIC or CLASS METHOD, IF NOT A CRASH IS THROW ON THE INIT
@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  final data = message.toMap();
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString('action', data.toString());

  print('Background notification $data');
  // final badge = int.tryParse(data['badge']) ?? 100;

  // await FlutterAppBadger.updateBadgeCount(badge);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FcmService(FirebaseMessaging.instance).requestAndRegisterNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  /// default constructor
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: data(),
          builder: (context, snapshot) {
            return Center(
              child: Text(snapshot.data ?? 'No data'),
            );
          },
        ),
      ),
    );
  }

  Future<String> data() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('action') ?? 'No data';
  }
}
