import 'dart:async';

import 'package:cus_dbs_app/common/apis/customer_api.dart';
import 'package:cus_dbs_app/common/apis/identity_api.dart';
import 'package:cus_dbs_app/common/entities/customer.dart';
import 'package:cus_dbs_app/common/entities/identity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'index.dart';

class CustomerUpdateIdentityController extends GetxController {
  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();
  final nationalityController = TextEditingController();
  final placeOriginController = TextEditingController();
  final placeResidenceController = TextEditingController();
  final personalIdentificationController = TextEditingController();
  final expiredDateController = TextEditingController();

  DateTime? _selectedDate;

  final state = CustomerUpdateIdentityState();

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  Future<void> handleCustomerUpdateIdentityCard() async {
    try {
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true,
      );
      
      late UpdateIdentity updatedCustomer;
      state.fullName.value = fullNameController.text.trim();
      state.dob.value = dobController.text.trim();
      state.gender.value = genderController.text.trim();
      state.nationality.value = nationalityController.text.trim();
      state.placeOrigin.value = placeOriginController.text.trim();
      state.placeResidence.value = placeResidenceController.text.trim();
      state.personalIdentification.value = personalIdentificationController.text.trim();
      state.expiredDate.value = expiredDateController.text.trim();

      updatedCustomer = UpdateIdentity(
        fullName: state.fullName.value,
        dob: state.dob.value,
        gender: state.gender.value,
        nationality: state.nationality.value,
        placeOrigin: state.placeOrigin.value,
        placeResidence: state.placeResidence.value,
        personalIdentification: state.personalIdentification.value,
        expiredDate: state.expiredDate.value,
      );

      if (updatedCustomer != null) {
        await _asyncUpdateCustomerInfo(updatedCustomer);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Try again');
      EasyLoading.dismiss();
    }
  }

  Future<void> _asyncUpdateCustomerInfo(UpdateIdentity updatedCustomer) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);

      String data = await IdentityAPI.updateIdentityCard(params: updatedCustomer);
      print('customer data');
      print(data);
    } on DioException catch (e) {
      Get.snackbar("Error", e.response.toString());
      EasyLoading.dismiss();
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      String formattedDate =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';

      dobController.text = formattedDate;
      state.dob.value = formattedDate;

      print(state.dob.value);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
