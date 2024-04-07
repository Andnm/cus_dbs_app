import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'index.dart';

class OtpConfirmController extends GetxController {
  final myInputOtpController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    // EasyLoading.dismiss();
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // var data = Get.parameters;
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
