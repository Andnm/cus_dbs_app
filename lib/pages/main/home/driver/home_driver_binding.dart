import 'package:get/get.dart';

import '../customer/home_customer_controller.dart';
import '../map/home_map_controller.dart';
import 'home_driver_controller.dart';
import 'index.dart';

class DriverHomeBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<DriverHomeController>(() => DriverHomeController());

    Get.lazyPut<MapController>(() => MapController());

    Get.lazyPut<CustomerHomeController>(() => CustomerHomeController());
  }
}
