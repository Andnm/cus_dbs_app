import 'dart:async';
import 'dart:ffi';
import 'dart:io';

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

class CustomerSignInController extends GetxController {
  final myInputPhoneController = TextEditingController();
  final myInputEmailController = TextEditingController();
  final myInputPasswordController = TextEditingController();
  Rx<String> selectedLoginMethod = 'email'.obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final state = CustomerSignInState();

  User? user;

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  Future<void> handleCustomerSignIn(String type) async {
    //1: google, 2: facebook, 3: apple, 4: phone

    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      CustomerExternalLogin? externalLogin;
      switch (type) {
        case "phoneNumber":
          state.phoneNumber.value = myInputPhoneController.text;
          await auth.verifyPhoneNumber(
            phoneNumber: "+84${myInputPhoneController.text}",
            verificationCompleted: (credential) async {
              // final UserCredential userCredential =
              //     await auth.UsersignInWithCredential(credential);
            },
            codeSent: (verificationID, forceResendingToken) {
              state.verificationId.value = verificationID;
              startResendTimer();
              Get.toNamed(AppRoutes.otpConfirm);
            },
            codeAutoRetrievalTimeout: (verificationID) {
              state.verificationId.value = verificationID;
            },
            verificationFailed: (e) {
              startResendTimer();
              if (e.code == 'invalid-phone-number') {
                Get.snackbar('Error', 'The provided phone number is not valid');
              } else {
                Get.snackbar('Error', 'Something went wrong. Try again');
              }
            },
          );
          break;
        case "google":
          GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
          final UserCredential userCredential =
              await auth.signInWithProvider(googleAuthProvider);
          final User user = userCredential.user!;
          final idToken = await user.getIdToken();
          String? providerId = userCredential.additionalUserInfo!.providerId;
          externalLogin =
              CustomerExternalLogin(idToken: idToken, provider: providerId);
          break;
        case "facebook":
          if (kDebugMode) {
            print("... you are logging in with facebook");
          }
        case "userNameAndPassword":
          CustomerItem? internalLogin;
          state.email.value = myInputEmailController.text;
          state.password.value = myInputPasswordController.text;

          internalLogin = CustomerItem(
              email: state.email.value, password: state.password.value);
          print('INTERAL LOGIN: $internalLogin');

          await asyncPostAllDataCustomerByInternalLogin(internalLogin);
          break;
        default:
          if (kDebugMode) {
            print("...login type not sure...");
          }
          break;
      }
      if (externalLogin != null) {
        await asyncPostAllDataCustomer(externalLogin);
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print("...error login with $e");
      }
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      var credential = await auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: state.verificationId.value, smsCode: otp));
      final User user = credential.user!;
      final idToken = await user.getIdToken();
      print('id token: $idToken');
      String? providerId = credential.additionalUserInfo!.providerId;
       if (Platform.isAndroid) {
        providerId = "phone";
      }
      var externalLogin =
          CustomerExternalLogin(idToken: idToken, provider: providerId);
      await asyncPostAllDataCustomer(externalLogin);
      EasyLoading.dismiss();
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Try again');
      EasyLoading.dismiss();
    }
  }

  Future<void> resendOtp() async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      await auth.verifyPhoneNumber(
        phoneNumber: "+84${state.phoneNumber.value}",
        verificationCompleted: (credential) async {},
        codeSent: (verificationID, forceResendingToken) {
          state.verificationId.value = verificationID;
        },
        codeAutoRetrievalTimeout: (verificationID) {
          state.verificationId.value = verificationID;
        },
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number') {
            Get.snackbar('Error', 'The provided phone number is not valid');
          } else {
            Get.snackbar('Error', 'Something went wrong. Try again');
          }
        },
      );
      EasyLoading.dismiss();
      startResendTimer();
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Try again');
      EasyLoading.dismiss();
    }
  }

  Future<void> asyncPostAllDataCustomerByInternalLogin(
      CustomerItem login) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      print('FLAG');
      var result = await CustomerAPI.loginWithEmailAndPassword(params: login);
      print('RESULT ${result.toString()}');

      if (result.access_token != null) {
        await UserStore.to.saveCustomerProfile(CustomerItem(
            access_token: result.access_token,
            tokenType: result.tokenType,
            userID: result.userID,
            expiresIn: result.expiresIn,
            userName: result.userName,
            email: result.email,
            password: result.password,
            phoneNumber: result.phoneNumber,
            name: result.userName,
            avatar: result.avatar,
            roles: result.roles,
            dateLogin: DateTime.now().toString()));
        EasyLoading.dismiss();

        Get.toNamed(AppRoutes.customerHome);
      }
    } on DioException catch (e) {
      Get.snackbar("Error", e.response.toString());
      EasyLoading.dismiss();
    }
  }

  Future<void> asyncPostAllDataCustomer(
      CustomerExternalLogin externalLogin) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      var result = await CustomerAPI.login(params: externalLogin);

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
            roles: result.roles,
            dateLogin: DateTime.now().toString()));
        EasyLoading.dismiss();
        Get.offAllNamed(AppRoutes.customerHome,
            parameters: {"tabSelected": "0"});
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
