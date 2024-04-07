import 'dart:ffi';
import 'dart:math';

import 'package:cus_dbs_app/common/apis/booking_api.dart';
import 'package:cus_dbs_app/common/apis/search_request.dart';
import 'package:cus_dbs_app/common/entities/booking.dart';
import 'package:cus_dbs_app/common/entities/direction_detail.dart';
import 'package:cus_dbs_app/common/entities/driver.dart';
import 'package:cus_dbs_app/common/entities/search_request_model.dart';
import 'package:cus_dbs_app/common/methods/common_methods.dart';
import 'package:cus_dbs_app/store/user_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../app/booking_status_type.dart';
import '../../../../common/apis/customer_api.dart';
import '../../../../common/entities/customer.dart';
import '../map/home_map_controller.dart';
import '../map/values/sizes.dart';
import 'index.dart';

class CustomerHomeController extends GetxController {
  final state = CustomerHomeState();
  MapController get mapPageController => Get.find<MapController>();

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  Rx<bool> isDrawerOpened = true.obs;
  Rx<CustomerItem> customer = CustomerItem().obs;
  @override
  Future<void> onInit() async {
    super.onInit();

    fetchCustomerProfile();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future<void> fetchCustomerProfile() async {
    try {
      customer.value = await UserStore.to.getCustomerProfile();
    
    } catch (e) {
      Get.snackbar('Error fetching customer profile:', '$e');
    }
  }
  

  displayUserRideDetailsContainer() async {
    ///Directions API

    searchContainerHeight.value = 0;
    bottomMapPadding.value = 240;
    rideDetailsContainerHeight.value = 242;
    isDrawerOpened.value = false;
  }

  Future<void> displayRequestContainer() async {
    rideDetailsContainerHeight.value = 0;
    requestContainerHeight.value = 220;
    bottomMapPadding.value = 200;
    isDrawerOpened.value = true; //false disable car
    await searchRequest();
  }

  Future<void> searchRequest() async {
    SearchRequestModel searchRequestModel = SearchRequestModel(
        pickupLatitude: state.pickUpLocation.value?.latitudePosition,
        pickupLongtitude: state.pickUpLocation.value?.longitudePosition,
        dropOffLatitude: state.dropOffLocation.value?.latitudePosition,
        dropOffLongtitude: state.dropOffLocation.value?.longitudePosition,
        price: 0);

    var searchRequestResult =
        await SearchRequestAPI.searchRequest(params: searchRequestModel);
    print('SEARCH REQUEST RESULT $searchRequestResult');
    if (state.availableNearbyOnlineDriversList.length == 0) {
      mapPageController.resetStatus();
      cancelRideRequest();
      //show diaglog
      return;
    }
    var currentDriver = state.availableNearbyOnlineDriversList[0];
    //send push noti
    BookingRequestModel bookingRequestModel = BookingRequestModel(
        driverId: currentDriver?.id,
        searchRequestId: searchRequestResult ?? '');
    var bookingResponse =
        await BookingAPI.requestBooking(params: bookingRequestModel);
    print('BOOKING REQUEST $bookingResponse');
    BookingRequestModel bookingRequest = BookingRequestModel(
        bookingId: state.availableNearbyOnlineDriversList[0]?.id ?? '',
        bookingStatus: BOOKING_STATUS.PENDING
            .name); //change status ngay tai cho khong reload thi khong update
    var changedBookingsResponse =
        await BookingAPI.changeStatus(params: bookingRequest);
  }

  Future<void> getAvailableNearbyOnlineDriversOnMap() async {
    print('GET AvailableNearbyOnlineDrivers');

    var onlineDrivers = await CustomerAPI.getOnlineNearByDrivers(
        currentLatitude: mapPageController.state.currentLocation.value.latitude,
        currentLongtitude:
            mapPageController.state.currentLocation.value.longitude,
        radius: 3.0);
    state.availableNearbyOnlineDriversList.value = onlineDrivers;
    updateAvailableNearbyOnlineDriversOnMap();
  }

  updateAvailableNearbyOnlineDriversOnMap() {
    // state.markerSet.clear();

    for (OnlineNearByDriver? eachOnlineNearbyDriver
        in state.availableNearbyOnlineDriversList) {
      if (eachOnlineNearbyDriver == null) {
        return;
      }
      LatLng driverCurrentPosition = LatLng(
          eachOnlineNearbyDriver.latitude ?? 0.0,
          eachOnlineNearbyDriver.longitude ?? 0.0);

      Marker driverMarker = Marker(
        markerId:
            MarkerId("driver ID = " + eachOnlineNearbyDriver.id.toString()),
        position: driverCurrentPosition,
        icon: mapPageController.state.carIcon,
      );

      mapPageController.state.markerSet.add(driverMarker);
    }
  }

  String calculateFareAmount(DirectionDetails? directionDetails) {
    double baseFareAmount = 100000;
    double distancePerKmAmount1 = 16000; // Giá mỗi km (10km đầu)
    double distancePerKmAmount2 = 12000; // Giá mỗi km (11km đến 20km)
    double distancePerKmAmount3 = 8000; // Giá mỗi km (sau 20km đầu)
    double waitingFeePerHour = 50000;

    double totalDistanceTravelFareAmount = 0;
    double totalDurationSpendFareAmount = 0;

    double distanceInKm = (directionDetails?.distanceValueDigits ?? 0) / 1000;
    double durationInMinutes =
        (directionDetails?.durationValueDigits ?? 0) / 60;

    if (distanceInKm <= 10) {
      totalDistanceTravelFareAmount = distanceInKm * distancePerKmAmount1;
    } else if (distanceInKm <= 20) {
      totalDistanceTravelFareAmount = 10 * distancePerKmAmount1 +
          (distanceInKm - 10) * distancePerKmAmount2;
    } else {
      totalDistanceTravelFareAmount = 10 * distancePerKmAmount1 +
          10 * distancePerKmAmount2 +
          (distanceInKm - 20) * distancePerKmAmount3;
    }

    totalDurationSpendFareAmount = durationInMinutes * waitingFeePerHour / 60;

    double overAllTotalFareAmount = baseFareAmount +
        totalDistanceTravelFareAmount +
        totalDurationSpendFareAmount;

    // Kiểm tra và áp dụng phí tăng thêm sau 21h và 23h
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 21 && hour < 23) {
      overAllTotalFareAmount *= 1.10; // Tăng 10%
    } else if (hour >= 23) {
      overAllTotalFareAmount *= 1.20; // Tăng 20%
    }

    double totalAmountWithServiceFee =
        overAllTotalFareAmount + 30000; // Phí dịch vụ

    return CommonMethods.formatCurrency(totalAmountWithServiceFee);
  }

  cancelRideRequest() {
    //remove ride request from database
    //ham remove search request

    mapPageController.state.statusOfBooking.value = BOOKING_STATUS.NONE;
  }

  void onClose() {
    super.onClose();
  }
}
