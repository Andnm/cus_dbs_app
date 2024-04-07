import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'index.dart';

class DriverSignInPage extends GetView<DriverSignInController> {
  const DriverSignInPage({super.key});
  Widget _buildThirdPartyLogin(String loginType, String logo) {
    return GestureDetector(
      child: Container(
        width: 295.w,
        height: 44.h,
        padding: EdgeInsets.all(10.h),
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
            color: AppColors.primayBackground,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1))
            ]),
        child: Row(
          mainAxisAlignment:
              logo == "" ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            logo == ""
                ? Container()
                : Container(
                    padding: EdgeInsets.only(left: 40.w, right: 30.w),
                    child: Image.asset("assets/icons/$logo.png")),
            Container(
              child: Text(
                "Sign in with $loginType",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp),
              ),
            )
          ],
        ),
      ),
      onTap: () {/*controller.handleDriverSignIn("google")*/},
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget _phoneForm = Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.secondElement,
        ),
        body: Container(
          height: size.height,
          decoration: BoxDecoration(color: AppColors.secondElement),
          child: SafeArea(
            child: Column(children: [
              //ihi
              Container(
                height: size.height * 0.3,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 120.h,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/icons/icon.png"),
                                fit: BoxFit.contain)),
                      ),
                    ]),
              ),
              Container(
                height: size.height * 0.4,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.primaryElement))),
                            child: Row(
                              children: [
                                Container(
                                  width: size.width * 0.1,
                                  child: Image.asset(
                                    'assets/images/vietnam_flag.jpeg', // Đường dẫn đến hình ảnh quốc kỳ Việt Nam
                                    width: 30, // Độ rộng của hình ảnh
                                    height: 20, // Độ cao của hình ảnh
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: size.width * 0.1,
                                  child: const Text(
                                    '+84',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: AppColors.primaryElementText),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: size.width * 0.8 - 20 - 10,
                            child: TextField(
                              style: TextStyle(
                                  color: AppColors.primaryElementText),
                              keyboardType: TextInputType.phone,
                              controller: controller.myInputPhoneController,
                              autocorrect: true,
                              decoration: InputDecoration(
                                hintText:
                                    "99 123 4567 ${controller.state.secondsRemaining.value}",
                                hintStyle: TextStyle(
                                    color: AppColors.primaryElementText
                                        .withOpacity(0.3)),

                                border: UnderlineInputBorder(),
                                // labelText: 'Phone number',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      height: 46,
                      width: size.width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.primaryElement),
                        ),
                        child: const Text(
                          "Tiếp tục với số điện thoại",
                          style: TextStyle(color: AppColors.primaryElementText),
                        ),
                        onPressed: () async {
                          //controller.handleDriverSignIn("phoneNumber");
                        },
                      ),
                    ),
                    TextButton(
                      child: Text('Đăng nhập bằng tài khoản'),
                      onPressed: () {
                        controller.selectedLoginMethod.value = 'email';
                      },
                    ),
                  ],
                ),
              )
// Center(
              //     child: Column(
              //   children: [
              //     _buildThirdPartyLogin("Google", "google"),
              //   ],
              // ))
            ]),
          ),
        ));
    Widget _emailForm = Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondElement,
      ),
      body: Container(
        height: size.height,
        decoration: BoxDecoration(color: AppColors.secondElement),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: size.height * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 120.h,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/icons/icon.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Text('Driver')
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextField(
                        controller: controller.myInputEmailController,
                        style: TextStyle(color: AppColors.primaryElementText),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle:
                              TextStyle(color: AppColors.primaryElementText),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primaryElement),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primaryElement),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: controller.myInputPasswordController,
                        style: TextStyle(color: AppColors.primaryElementText),
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle:
                              TextStyle(color: AppColors.primaryElementText),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primaryElement),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primaryElement),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(fontSize: 10.sp),
                            ),
                            onPressed: () {
                              // Navigate to password reset page
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        height: 46,
                        width: size.width,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.primaryElement),
                          ),
                          child: const Text(
                            "Đăng nhập",
                            style:
                                TextStyle(color: AppColors.primaryElementText),
                          ),
                          onPressed: () {
                            controller.handleDriverInternalSignIn();
                          },
                        ),
                      ),
                      TextButton(
                        child: Text(
                          'Đăng nhập bằng số điện thoại',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10.sp),
                        ),
                        onPressed: () {
                          controller.selectedLoginMethod.value = 'phone';
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Bạn chưa có tài khoản?'),
                          TextButton(
                            child: Text('Đăng ký'),
                            onPressed: () {
                              Get.toNamed(AppRoutes.driverRegister);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return Obx(() => controller.selectedLoginMethod.value == 'email'
        ? _emailForm
        : _phoneForm);
  }
}
