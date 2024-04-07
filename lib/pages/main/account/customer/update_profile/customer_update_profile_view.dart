import 'package:cus_dbs_app/pages/main/account/customer/update_profile/customer_update_profile_controller.dart';
import 'package:cus_dbs_app/pages/main/home/customer/home_customer_controller.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerUpdateProfilePage
    extends GetView<CustomerUpdateProfileController> {
  const CustomerUpdateProfilePage();

  CustomerHomeController get homeCustomerController =>
      Get.find<CustomerHomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                Get.back();
              }),
          title: Text("Thông tin cá nhân"),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                controller.toggleEditMode();
              },
            ),
          ],
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
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.blue.shade400),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 20,
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
                TextFormField(
                  keyboardType: TextInputType.text,
                  // controller: controller.nameController,
                  decoration: InputDecoration(
                    labelText: "Họ và tên",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  initialValue: homeCustomerController.customer.value.getName,
                  readOnly: controller.state.editMode.value,
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: controller.addressController,
                  decoration: InputDecoration(
                    labelText: "Địa chỉ",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: controller.phoneNumberController,
                  decoration: InputDecoration(
                    labelText: "Số điện thoại",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: controller.genderController,
                  decoration: InputDecoration(
                    labelText: "Giới tính",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.transgender),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                    keyboardType: TextInputType.datetime,
                    controller: controller.dobController,
                    decoration: InputDecoration(
                      labelText: "Ngày sinh",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.date_range),
                    ),
                    readOnly: true,
                    onTap: () {
                      controller.selectDate(context);
                    }),
                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: controller.state.editMode.value
                      ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.primaryElement,
                            ),
                          ),
                          child: Text(
                            'Cập nhập',
                            style:
                                TextStyle(color: AppColors.primaryElementText),
                          ),
                          onPressed: () {
                            controller.handleCustomerUpdateProfile();
                          },
                        )
                      : SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
