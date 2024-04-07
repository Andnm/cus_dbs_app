import 'package:cus_dbs_app/pages/main/account/customer/update_identity_card/index.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerUpdateIdentityPage
    extends GetView<CustomerUpdateIdentityController> {
  const CustomerUpdateIdentityPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              Get.back();
            }),
        title: Text("Căn cước công dân"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
