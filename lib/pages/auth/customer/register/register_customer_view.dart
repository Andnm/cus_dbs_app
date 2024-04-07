import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'index.dart';

class CustomerRegisterPage extends GetView<CustomerRegisterController> {
  const CustomerRegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký người dùng'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/icons/icon.png",
                  height: 100,
                  width: 100,
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: controller.userNameController,
                  decoration: InputDecoration(
                    labelText: "Họ và tên",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  controller: controller.confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: "Xác nhận mật khẩu",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.primaryElement),
                    ),
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(color: AppColors.primaryElementText),
                    ),
                    onPressed: () {
                      controller.handleCustomerRegister();

                      // Handle registration logic here
                      // You can access the entered values using:
                      // _emailController.text
                      // _passwordController.text
                      // _confirmPasswordController.text
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
