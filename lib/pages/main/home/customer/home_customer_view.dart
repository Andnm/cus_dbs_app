import 'package:cus_dbs_app/app/booking_status_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../common/widgets/profile_drawer.dart';
import '../../../../values/colors.dart';
import '../map/home_map_controller.dart';
import '../map/home_map_view.dart';
import '../map/values/sizes.dart';
import 'index.dart';
import 'items/search_destination_page.dart';

class CustomerHomePage extends GetView<CustomerHomeController> {
  const CustomerHomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.sKey,
      drawer: ProfileDrawer(),
      body: Center(
        child: Stack(
          children: [
            MapPage(),
            //drawer button
            Obx(() {
              return Positioned(
                top: 36,
                left: 19,
                child: GestureDetector(
                  onTap: () {
                    if (controller.isDrawerOpened.value == true) {
                      controller.sKey.currentState!.openDrawer();
                    } else {
                      final mapPageController = Get.find<MapController>();
                      mapPageController.resetStatus();
                      // controller.sKey.currentState!.closeDrawer();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaySecondBackground,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      child: Icon(
                        controller.isDrawerOpened.value == true
                            ? Icons.menu
                            : Icons.close,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            }),

            ///search location icon button
            Obx(() {
              return Positioned(
                left: 0,
                right: 0,
                bottom: -80,
                child: Container(
                  height: searchContainerHeight.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          var responseFromSearchPage =
                              await Get.to(SearchDestinationPage());

                          if (responseFromSearchPage == "placeSelected") {
                            controller.displayUserRideDetailsContainer();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          // Add elevation for shadow
                          splashFactory: InkRipple.splashFactory,
                          backgroundColor: AppColors.primaySecondBackground,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(24),
                        ),
                        child: Icon(
                          Icons.search,
                          color: AppColors.primaryElement,
                          size: 25,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          // Add elevation for shadow
                          splashFactory: InkRipple.splashFactory,
                          backgroundColor: AppColors.primaySecondBackground,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(24),
                        ),
                        child: Icon(
                          Icons.home,
                          color: AppColors.primaryElement,
                          size: 25,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          // Add elevation for shadow
                          splashFactory: InkRipple.splashFactory,
                          backgroundColor: AppColors.primaySecondBackground,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(24),
                        ),
                        child: Icon(
                          Icons.work,
                          color: AppColors.primaryElement,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            ///ride details container
            Obx(() {
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: rideDetailsContainerHeight.value,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white12,
                        blurRadius: 15.0,
                        spreadRadius: 0.5,
                        offset: Offset(.7, .7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: SizedBox(
                            height: 190,
                            child: Card(
                              elevation: 10,
                              child: Container(
                                width: MediaQuery.of(context).size.width * .70,
                                color: Colors.black45,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8,
                                          right: 8,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (controller
                                                      .state
                                                      .tripDirectionDetailsInfo
                                                      .value
                                                      ?.distanceTextString ??
                                                  ''),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              (controller
                                                      .state
                                                      .tripDirectionDetailsInfo
                                                      .value
                                                      ?.durationTextString ??
                                                  ''),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            final mapPageController = controller
                                                .mapPageController
                                                .updateBookingStatus(
                                                    BOOKING_STATUS.PENDING);
                                            controller
                                                .displayRequestContainer();
                                          },
                                          child: Image.asset(
                                            "assets/images/uberexec.png",
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${(controller.calculateFareAmount(controller.state.tripDirectionDetailsInfo.value))} VND",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            Obx(
              () =>

                  ///request container
                  Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: requestContainerHeight.value,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15.0,
                        spreadRadius: 0.5,
                        offset: Offset(
                          0.7,
                          0.7,
                        ),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          // width: 300,
                          child: LoadingAnimationWidget.discreteCircle(
                              color: Colors.greenAccent, size: 50),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            final mapPageController = Get.find<MapController>();
                            mapPageController.resetStatus();
                            controller.cancelRideRequest();
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(25),
                              border:
                                  Border.all(width: 1.5, color: Colors.grey),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
