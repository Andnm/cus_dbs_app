import 'package:cus_dbs_app/pages/main/home/driver/home_driver_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'account/account_view.dart';
import 'home/customer/home_customer_view.dart';
import 'index.dart';

class MainController extends GetxController {
  final state = MainState();

  ScrollController myScrollController = ScrollController();

  @override
  Future<void> onInit() async {
    super.onInit();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    var data = Get.parameters;
    state.tabSelected.value =
        data['tabSelected'] != null ? int.parse(data['tabSelected']!) : 0;
  }

  @override
  void onReady() async {
    super.onReady();
  }

  void selectedTab(int index) {
    state.tabSelected.value = index;
  }

  Widget changedPage() {
    Widget content = Container();
    switch (state.tabSelected.value) {
      case 0:
        content = const DriverHomePage();
        break;
      case 3:
        content = const AccountPage();
        break;
    }
    return content;
  }

  Widget changeTitleAppbar() {
    Text content = const Text('');
    switch (state.tabSelected.value) {
      case 0:
        content = const Text('Home');
        break;
    }
    return content;
  }

  @override
  void onClose() {
    super.onClose();
    myScrollController.dispose();
  }
}
