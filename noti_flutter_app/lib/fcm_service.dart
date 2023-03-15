import 'package:firebase_messaging/firebase_messaging.dart';

import 'main.dart';

class FcmService {
  final FirebaseMessaging _messaging;

  FcmService(
    this._messaging,
  );

  Future<void> requestAndRegisterNotification() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      print('User declined or has not accepted permission');
      return;
    }

    print('User granted permission');

    final token = await _messaging.getToken();
    showFCMToken(token);

    _registerNotifications();
  }

  Future<void> showFCMToken(String? token) async {
    if (token == null) return;

    print("The token is $token");
  }

  void _registerNotifications() {
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   print('Foreground notification ${message.toMap()}');
    //   final badge = int.tryParse(message.data['badge']) ?? 100;

    //   await FlutterAppBadger.updateBadgeCount(badge);
    // });

    FirebaseMessaging.onMessage.listen(handleBackgroundMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // Listen when notifications are opened and will open then application
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Click notification');
    });
  }
}
