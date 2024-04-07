import 'package:get/get.dart';

import '../driver/home_driver_controller.dart';
import '../map/home_map_controller.dart';
import 'index.dart';

class CustomerHomeBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<CustomerHomeController>(() => CustomerHomeController());
    Get.lazyPut<MapController>(() => MapController());
    Get.lazyPut<DriverHomeController>(() => DriverHomeController());
  }
}
