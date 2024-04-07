import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Center(
              child: Text("Account"),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.primaryElement),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(color: AppColors.primaryElementText),
              ),
              onPressed: () async {
                UserStore.to.clearStorage();
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed(AppRoutes.driverSignIn);
              },
            ),
          ],
        ));
  }
}
