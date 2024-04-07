import 'dart:async';
import 'dart:ffi';

import 'package:cus_dbs_app/common/apis/customer_api.dart';
import 'package:cus_dbs_app/common/entities/customer.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'index.dart';

class CustomerRegisterController extends GetxController {
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final state = CustomerRegisterState();

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  Future<void> handleCustomerRegister() async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      late CustomerRegister registeredCustomer;
      state.email.value = emailController.text.trim();
      state.userName.value = userNameController.text.trim();
      state.password.value = passwordController.text.trim();
      state.confirmPassword.value = confirmPasswordController.text.trim();
      registeredCustomer = CustomerRegister(
          email: state.email.value,
          userName: state.userName.value,
          password: state.confirmPassword.value);
      if (state.password.value != state.confirmPassword.value) {
        Get.snackbar('Error', 'Passwords do not match');
        EasyLoading.dismiss();

        return;
      }
      if (registeredCustomer != null) {
        await asyncPostAllDataCustomerByRegister(registeredCustomer);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Try again');
      EasyLoading.dismiss();
    }
  }

  Future<void> asyncPostAllDataCustomerByRegister(
      CustomerRegister registeredCustomer) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      String token = await CustomerAPI.register(params: registeredCustomer);
      if (token != null) {
        await UserStore.to.setToken(token);
        EasyLoading.dismiss();
        Get.toNamed(AppRoutes.customerSignIn);
        await loginCustomerAfterRegister();
      }
    } on DioException catch (e) {
      Get.snackbar("Error", e.response.toString());
      EasyLoading.dismiss();
    }
  }

  Future<void> loginCustomerAfterRegister() async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      late CustomerItem? internalLogin;
      state.email.value = emailController.text;
      state.password.value = passwordController.text;

      internalLogin = CustomerItem(
          email: state.email.value, password: state.password.value);
      if (internalLogin != null) {
        await asyncPostAllDataCustomerByInternalLoginAfterRegister(
            internalLogin);
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print("...error login with $e");
      }
    }
  }

  Future<void> asyncPostAllDataCustomerByInternalLoginAfterRegister(
      CustomerItem login) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      var result = await CustomerAPI.loginWithEmailAndPassword(params: login);
      if (result.access_token != null) {
        await UserStore.to.saveCustomerProfile(CustomerItem(
            access_token: result.access_token,
            tokenType: result.tokenType,
            userID: result.userID,
            expiresIn: result.expiresIn,
            userName: result.userName,
            phoneNumber: result.phoneNumber,
            name: result.userName,
            avatar: result.avatar,
            dateLogin: DateTime.now().toString()));
        EasyLoading.dismiss();

        Get.offAllNamed(AppRoutes.main, parameters: {"tabSelected": "0"});
        // Get.to(CustomerHomePage());
      }
    } on DioException catch (e) {
      Get.snackbar("Error", e.response.toString());
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
