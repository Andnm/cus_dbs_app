import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/themes/theme.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../values/roles.dart';
import '../main/home/map/values/constants.dart';

class ChooseRole extends StatelessWidget {
  const ChooseRole({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colorSchemes.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200.w, // Đặt chiều rộng cho nút
              child: ElevatedButton(
                onPressed: () {
                  RolesApp.roles?.add(RolesApp.customerRole);

                  Get.toNamed(AppRoutes.customerSignIn);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(double.infinity, 50), // Kích thước tối thiểu của nút
                  padding:
                      EdgeInsets.symmetric(vertical: 16), // Padding cho nút
                ),
                child: Text(
                  'Customer',
                  style: TextStyle(
                    color: AppColors.secondElement,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: 200.w, // Đặt chiều rộng cho nút
              child: ElevatedButton(
                onPressed: () {
                  RolesApp.roles?.add(RolesApp.driverRole);

                  RolesApp.roles?[0] = RolesApp.driverRole;

                  Get.toNamed(AppRoutes.driverSignIn);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(double.infinity, 50), // Kích thước tối thiểu của nút
                  padding:
                      EdgeInsets.symmetric(vertical: 16), // Padding cho nút
                ),
                child: Text(
                  'Driver',
                  style: TextStyle(
                    color: AppColors.secondElement,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
