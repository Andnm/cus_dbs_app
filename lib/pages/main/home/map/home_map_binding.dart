import 'package:cus_dbs_app/pages/main/home/customer/home_customer_controller.dart';
import 'package:get/get.dart';

import '../driver/home_driver_controller.dart';
import 'index.dart';

class MapBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<CustomerHomeController>(CustomerHomeController());

    Get.lazyPut<DriverHomeController>(() => DriverHomeController());

    Get.put(MapController());
  }
}
