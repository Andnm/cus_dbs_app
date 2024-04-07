import 'dart:async';

import 'package:cus_dbs_app/common/apis/booking_api.dart';
import 'package:cus_dbs_app/pages/main/home/map/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/booking_status_type.dart';
import '../../../../common/apis/driver_api.dart';
import '../../../../common/entities/booking.dart';
import '../../../../common/entities/place.dart';
import '../map/home_map_controller.dart';
import 'index.dart';

class DriverHomeController extends GetxController {
  final state = DriverHomeState();
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  MapController mapPageController = Get.find<MapController>();
  Timer? _timer;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future<void> getAllCustomerBookings() async {
    var customerBookingResponse = await DriverAPI.getAllCustomerBooking();
    print(customerBookingResponse.toString());
    BookingRequestModel bookingRequest = BookingRequestModel(
        bookingId: customerBookingResponse?[0].id,
        bookingStatus: mapPageController.state.statusOfBooking.value.name);
    var changedBookingsResponse =
        await BookingAPI.changeStatus(params: bookingRequest);
    print('After change:');
    print(changedBookingsResponse.toString());
  }

  Future<void> activateOnlineStatus() async {
    try {
      var onlineDriver = await DriverAPI.switchToOnline();
      state.colorToShow.value = Colors.pink;
      state.titleToShow.value = "OFFLINE";
      state.isDriverAvailable.value = false;
      print('Activated');
    } catch (e) {
      print('Driver status: $e ');
    }
  }

  Future<void> deactivateOnlineStatus() async {
    try {
      var onlineDriver = await DriverAPI.switchToOffline();
      state.colorToShow.value = Colors.green;
      state.titleToShow.value = "ONLINE";
      state.isDriverAvailable.value = true;
      print('Deactivated');
    } catch (e) {
      print('Driver status: $e ');
    }
  }

  Future<void> sendLocationToBackend() async {
    try {
      PlaceLocation placeLocation = PlaceLocation(
        latitude: mapPageController.state.currentLocation.value.latitude ?? 0.0,
        longitude:
            mapPageController.state.currentLocation.value.longitude ?? 0.0,
      );
      var driverLocation =
          await DriverAPI.updateDriverLocation(params: placeLocation);

      print('Location data sent successfully.');
    } catch (e) {
      print('Error sending location data: $e');
    }
  }

  // void startSendingLocation() {
  //   _timer?.cancel();
  //   _timer = Timer.periodic(Duration(seconds: 5), (timer) {
  //     sendLocationToBackend();
  //   });
  // }
  //
  // void stopSendingLocation() {
  //   _timer?.cancel();
  // }

  void onClose() {
    super.onClose();
  }
}
