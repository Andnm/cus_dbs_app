import 'dart:async';

import 'package:get/get.dart';

class CustomerRegisterState {
  Rx<String> email = ''.obs;
  Rx<String> userName = ''.obs;
  Rx<String> password = ''.obs;
  Rx<String> confirmPassword = ''.obs;
}
