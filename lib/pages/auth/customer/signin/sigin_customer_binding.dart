import 'package:get/get.dart';

import 'index.dart';

class CustomerSignInBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<CustomerSignInController>(() => CustomerSignInController());
  }
}
