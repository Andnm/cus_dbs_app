import 'dart:async';

import 'package:cus_dbs_app/common/entities/driver.dart';

import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common/apis/driver_api.dart';
import 'index.dart';

class DriverSignInController extends GetxController {
  final myInputPhoneController = TextEditingController();
  final myInputEmailController = TextEditingController();
  final myInputPasswordController = TextEditingController();
  Rx<String> selectedLoginMethod = 'email'.obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final state = DriverSignInState();

  User? user;

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  Future<void> handleDriverInternalSignIn() async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      late DriverInternalLogin? internalLogin;
      state.email.value = myInputEmailController.text;
      state.password.value = myInputPasswordController.text;

      internalLogin = DriverInternalLogin(
          email: state.email.value, password: state.password.value);
      await asyncPostAllDataDriverByInternalLogin(internalLogin);
    } catch (e) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print("...error login with $e");
      }
    }
  }

  Future<void> asyncPostAllDataDriverByInternalLogin(
      DriverInternalLogin login) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      var result = await DriverAPI.loginWithEmailAndPassword(params: login);

      if (result.access_token != null) {
        await UserStore.to.saveDriverProfile(DriverItem(
            access_token: result.access_token,
            tokenType: result.tokenType,
            userID: result.userID,
            expiresIn: result.expiresIn,
            userName: result.userName,
            phoneNumber: result.phoneNumber,
            name: result.userName,
            avatar: result.avatar,
            roles: result.roles,
            dateLogin: DateTime.now().toString()));
        EasyLoading.dismiss();
        print('loged');
        Get.toNamed(AppRoutes.main);
      }
    } on DioException catch (e) {
      Get.snackbar("Error", e.response.toString());
      EasyLoading.dismiss();
    }
  }

  void startResendTimer() {
    state.canResend.value = false;
    state.secondsRemaining.value = 30;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsRemaining > 0) {
        state.secondsRemaining--;
      } else {
        timer.cancel();
        state.canResend.value = true;
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
