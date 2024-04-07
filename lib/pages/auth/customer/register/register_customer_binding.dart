import 'package:get/get.dart';

import 'index.dart';

class CustomerRegisterBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<CustomerRegisterController>(() => CustomerRegisterController());
  }
}
