import 'dart:async';

import 'package:cus_dbs_app/common/apis/customer_api.dart';
import 'package:cus_dbs_app/common/entities/customer.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'index.dart';

class CustomerUpdateProfileController extends GetxController {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final genderController = TextEditingController();
  final dobController = TextEditingController();
  Rx<CustomerItem> customer = CustomerItem().obs;

  DateTime? _selectedDate;

  final state = CustomerUpdateProfileState();

  @override
  void onInit() {
    super.onInit();
    fetchCustomerProfile();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  void toggleEditMode() {
    state.editMode.value = !state.editMode.value;
    update();
  }

  Future<void> fetchCustomerProfile() async {
    try {
      customer.value = await UserStore.to.getCustomerProfile();
    } catch (e) {
      Get.snackbar('Error fetching customer profile:', '$e');
    }
  }

  Future<void> handleCustomerUpdateProfile() async {
    try {
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true,
      );

      late CustomerUpdateProfile updatedCustomer;
      state.name.value = nameController.text.trim();
      state.address.value = addressController.text.trim();
      state.phoneNumber.value = phoneNumberController.text.trim();
      state.gender.value = genderController.text.trim();
      state.dob.value = dobController.text.trim();

      updatedCustomer = CustomerUpdateProfile(
        name: state.name.value,
        address: state.address.value,
        phoneNumber: state.phoneNumber.value,
        gender: state.gender.value,
        dob: state.dob.value,
      );

      if (updatedCustomer != null) {
        await _asyncUpdateCustomerInfo(updatedCustomer);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Try again');
      EasyLoading.dismiss();
    }
  }

  Future<void> _asyncUpdateCustomerInfo(
      CustomerUpdateProfile updatedCustomer) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);

      String data = await CustomerAPI.updateProfile(params: updatedCustomer);
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
