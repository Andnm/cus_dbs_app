import 'dart:io';
import 'package:cus_dbs_app/routes/pages.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'global.dart';

Future<void> main() async {
  await Global.init();
  // await Global.firebaseInit();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 780),
        builder: (context, child) => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              initialRoute: AppRoutes.initial,
              getPages: AppPages.routes,
              builder: EasyLoading.init(),
            ));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    HttpClient client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.dualRing
    ..loadingStyle = EasyLoadingStyle.light;
}
