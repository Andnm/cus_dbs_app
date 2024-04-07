import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notification_handler.dart';

class FirebaseMessagingHandler {
  FirebaseMessagingHandler._();

  static Future<void> config() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    try {
      await messaging.requestPermission(
          sound: true,
          badge: true,
          alert: true,
          announcement: false,
          carPlay: false,
          criticalAlert: false,
          provisional: false);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, badge: true, sound: true);

      FirebaseMessaging.instance.getInitialMessage().then((message) {
        //terminated
        if (message != null) {
          handleMessage(message);
        }
      });

      FirebaseMessaging.onMessageOpenedApp //background
          .listen((RemoteMessage message) async {
        handleMessage(message);
      });

      if (Platform.isAndroid) {
        FirebaseMessaging.onMessage.listen((event) {
          //foreground
          LocalNotificationService.showNotificationWithAndroid(event);
        });
      }
    } on Exception catch (e) {
      print("$e");
    }
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackground(
      RemoteMessage message) async {}

  static Future<void> handleMessage(RemoteMessage message) async {
    print(message.notification!.body);
    if (await checkAuthSuccess()) {}
  }

  static Future<bool> checkAuthSuccess() async {
    return true;
  }
}
