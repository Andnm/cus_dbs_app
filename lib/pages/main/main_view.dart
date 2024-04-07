import 'package:cus_dbs_app/common/widgets/fab_bottom_app_bar.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        bottomNavigationBar: FABBottomAppBar(
          items: [
            FABBottomAppBarItem(iconData: Icons.home, text: 'Trang chủ'),
            FABBottomAppBarItem(iconData: Icons.history, text: 'Lịch sử'),
            FABBottomAppBarItem(
                iconData: Icons.notifications, text: 'Thông báo'),
            FABBottomAppBarItem(iconData: Icons.person, text: 'Cá nhân'),
          ],
          backgroundColor: AppColors.primayBackground,
          notificationBadge: controller.state.notiCount.value,
          color: AppColors.primayBackground,
          selectedColor: AppColors.primaryElement,
          notchedShape: const CircularNotchedRectangle(),
          tabSelected: controller.state.tabSelected.value,
          onTabSelected: (value) => {controller.selectedTab(value)},
        ),
        body: controller.changedPage()));
  }
}
