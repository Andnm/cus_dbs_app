import 'package:get/get.dart';

import 'index.dart';

class CustomerUpdateIdentityBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<CustomerUpdateIdentityController>(() => CustomerUpdateIdentityController());
    
  }
}
