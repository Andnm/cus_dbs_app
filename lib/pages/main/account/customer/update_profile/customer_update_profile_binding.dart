import 'package:get/get.dart';

import 'index.dart';

class CustomerUpdateProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerUpdateProfileController>(
        () => CustomerUpdateProfileController());
  }
}
