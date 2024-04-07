import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../map/home_map_view.dart';
import 'home_driver_controller.dart';

class DriverHomePage extends GetView<DriverHomeController> {
  const DriverHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          MapPage(),
          Container(
            height: 136,
            width: double.infinity,
            color: Colors.black54,
          ),

          ///go online offline button
          Obx(() {
            return Positioned(
              top: 61,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          builder: (BuildContext context) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0,
                                    spreadRadius: 0.5,
                                    offset: Offset(
                                      0.7,
                                      0.7,
                                    ),
                                  ),
                                ],
                              ),
                              height: 221,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 18),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 11,
                                    ),
                                    Text(
                                      (controller.state.isDriverAvailable.value)
                                          ? "ONLINE"
                                          : "OFFLINE",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 21,
                                    ),
                                    Text(
                                      (controller.state.isDriverAvailable.value)
                                          ? "Bạn đã sẵn sàng nhận yêu cầu chuyến đi từ người dùng."
                                          : "Bạn sẽ ngừng nhận yêu cầu chuyến đi mới từ người dùng..",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white30,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text("BACK"),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Obx(() {
                                          return Expanded(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (controller.state
                                                    .isDriverAvailable.value) {
                                                  //go online
                                                  //goOnlineNow();

                                                  await controller
                                                      .activateOnlineStatus();
                                                  // controller
                                                  //     .startSendingLocation();

                                                  //get driver location updates
                                                  // setAndGetLocationUpdates();
                                                  print("HIHI");
                                                  Get.back();
                                                } else {
                                                  //go offline
                                                  //goOfflineNow();
                                                  await controller
                                                      .deactivateOnlineStatus();

                                                  // controller
                                                  //     .stopSendingLocation();
                                                  print("HEHE");

                                                  Get.back();
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: (controller
                                                            .state
                                                            .titleToShow
                                                            .value ==
                                                        "ONLINE")
                                                    ? Colors.green
                                                    : Colors.pink,
                                              ),
                                              child: const Text("CONFIRM"),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.state.colorToShow.value,
                    ),
                    child: Text(
                      controller.state.titleToShow.value,
                    ),
                  ),

                  // ElevatedButton to show booking info
                  ElevatedButton(
                    onPressed: () {
                      controller.getAllCustomerBookings();
                    },
                    child: Text("Show Booking Info"),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
