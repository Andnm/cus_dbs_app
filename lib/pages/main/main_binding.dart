import 'package:cus_dbs_app/pages/main/home/customer/home_customer_controller.dart';
import 'package:cus_dbs_app/pages/main/home/map/home_map_controller.dart';
import 'package:get/get.dart';

import 'home/driver/home_driver_controller.dart';
import 'index.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<MapController>(MapController());
    Get.lazyPut<DriverHomeController>(() => DriverHomeController());
    Get.lazyPut<CustomerHomeController>(() => CustomerHomeController());

    Get.lazyPut<MainController>(() => MainController());
  }
}
