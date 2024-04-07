import 'package:cus_dbs_app/pages/main/account/customer/update_profile/index.dart';
import 'package:cus_dbs_app/pages/main/home/customer/home_customer_controller.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerProfileView extends StatelessWidget {
  const CustomerProfileView({Key? key}) : super(key: key);
  CustomerHomeController get homeCustomerController =>
      Get.find<CustomerHomeController>();

  @override
  Widget build(BuildContext context) {
    void showUnsupportedFunctionDialog() {
      Get.defaultDialog(
        title: "Chưa hỗ trợ",
        titleStyle: const TextStyle(fontSize: 20),
        content: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Text("Chức năng chưa hỗ trợ!"),
        ),
        cancel: OutlinedButton(
            onPressed: () => Get.back(), child: const Text("Xác nhận")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text("Trang cá nhân"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          "assets/images/avatarman.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                homeCustomerController.customer.value.getName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                homeCustomerController.customer.value.getEmail,
              ),

              /// -- BUTTON
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                  title: "Thông tin cá nhân",
                  icon: Icons.info,
                  onPress: () {
                    Get.toNamed(AppRoutes.updateCustomerProfile);
                  }),
              ProfileMenuWidget(
                  title: "CCCD",
                  icon: Icons.add_card,
                  onPress: () {
                    Get.toNamed(AppRoutes.updateCustomerIdentityCard);
                  }),
              ProfileMenuWidget(
                  title: "Xe của tôi",
                  icon: Icons.car_crash_outlined,
                  onPress: () {
                    showUnsupportedFunctionDialog();
                  }),
              ProfileMenuWidget(
                title: "Ví tiền",
                icon: Icons.wallet,
                onPress: () {
                  showUnsupportedFunctionDialog();
                },
              ),
              ProfileMenuWidget(
                title: "Lịch sử chuyến đi",
                icon: Icons.history,
                onPress: () {
                  showUnsupportedFunctionDialog();
                },
              ),

              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Cài đặt",
                icon: Icons.settings,
                onPress: () {
                  showUnsupportedFunctionDialog();
                },
              ),

              ProfileMenuWidget(
                  title: "Logout",
                  icon: Icons.logout,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    Get.defaultDialog(
                      title: "Đăng xuất",
                      titleStyle: const TextStyle(fontSize: 20),
                      content: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text("Are you sure, you want to Logout?"),
                      ),
                      confirm: Expanded(
                        child: ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              side: BorderSide.none),
                          child: const Text("Yes"),
                        ),
                      ),
                      cancel: OutlinedButton(
                          onPressed: () => Get.back(), child: const Text("No")),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blue.shade400.withOpacity(0.1),
        ),
        child: Icon(icon, color: Colors.blue.shade400),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black,
        ),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child:
                  const Icon(Icons.arrow_right, size: 18.0, color: Colors.grey))
          : null,
    );
  }
}
