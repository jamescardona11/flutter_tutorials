import 'package:firebase_messaging/firebase_messaging.dart';

class FcmRepository {
  final FirebaseMessaging _firebaseMessaging;

  FcmRepository(
    this._firebaseMessaging,
  ) {
    fetchFCMToken();
  }

  Future<void> fetchFCMToken() async {
    final token = await _firebaseMessaging.getToken();
    showFCMToken(token);

    _firebaseMessaging.onTokenRefresh.listen((String token) {
      showFCMToken(token);
    });
  }

  Future<void> showFCMToken(String? token) async {
    if (token == null) return;
  }

  Future<void> notificationMessagesManagement(
      Future<void> Function(Map<String, dynamic> message) firebaseMessagingBackgroundHandler) async {
    _manageForegroundMessages();
    _manageBackgroundMessages(firebaseMessagingBackgroundHandler);
    await _manageTerminatedMessages();
    // Listen when notifications are opened and will open then application
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  // Listen Notifications on terminated state
  Future<void> _manageTerminatedMessages() async {
    RemoteMessage? messageFromTerminated = await FirebaseMessaging.instance.getInitialMessage();

    if (messageFromTerminated != null) {
      _handleMessage(messageFromTerminated);
    }
  }

  void _manageForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
  }

  // Listen Notifications on background state
  void _manageBackgroundMessages(Future<void> Function(Map<String, dynamic>) firebaseMessagingBackgroundHandler) {
    FirebaseMessaging.onBackgroundMessage((RemoteMessage remoteMessage) => firebaseMessagingBackgroundHandler(remoteMessage.toMap()));
  }

  void _handleMessage(RemoteMessage message) {}
}
