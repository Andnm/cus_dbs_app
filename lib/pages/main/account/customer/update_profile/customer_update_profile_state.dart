import 'package:get/get.dart';

class CustomerUpdateProfileState {
  Rx<String> name = ''.obs;
  Rx<String> address = ''.obs;
  Rx<String> phoneNumber = ''.obs;
  Rx<String> gender = ''.obs;
  Rx<String> dob = ''.obs;

  Rx<bool> editMode = false.obs;
}
