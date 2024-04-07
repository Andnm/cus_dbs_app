import 'dart:io';

import 'package:cus_dbs_app/firebase_options.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:cus_dbs_app/store/storage.dart';
import 'package:cus_dbs_app/utils/firebase_messaging_handler.dart';
import 'package:cus_dbs_app/utils/local_notification_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Global {
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isAndroid) {
      LocalNotificationService.initialize();
    }
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseInit().whenComplete(() => FirebaseMessagingHandler.config());
    await Get.putAsync<StorageService>(() => StorageService().init());
    Get.put<UserStore>(UserStore());
  }

  static Future firebaseInit() async {
    FirebaseMessaging.instance
        .getToken()
        .then((fcmToken) => print("FCM Token: " + fcmToken.toString()));
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      print("FCM Refresh token: $fcmToken");
    }).onError((error) => print(error.toString()));
    FirebaseMessaging.onBackgroundMessage(
        FirebaseMessagingHandler.firebaseMessagingBackground);
  }
}
