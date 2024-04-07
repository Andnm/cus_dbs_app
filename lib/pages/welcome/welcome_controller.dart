import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:get/get.dart';

import '../../values/roles.dart';
import '../main/home/map/values/constants.dart';
import 'index.dart';

class WelcomeController extends GetxController {
  WelcomeController();
  final title = "DBS";

  Future<void> onReady() async {
    super.onReady();
    Future.delayed(const Duration(seconds: 3), () async {
      List<String>? userRoles = await UserStore.to.getRoles();
      RolesApp.roles = userRoles;
      print("userRoles $userRoles");
      if (RolesApp.roles!.isEmpty) {
        Get.offAllNamed(AppRoutes.chooseRole);
      } else if (RolesApp.roles?[0] == RolesApp.driverRole) {
        Get.offAllNamed(AppRoutes.main);
      } else {
        Get.offAllNamed(AppRoutes.customerHome);
      }
    });
  }
}
