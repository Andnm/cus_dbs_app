import 'dart:convert';
import 'dart:io';

import 'package:cus_dbs_app/app/booking_status_type.dart';
import 'package:cus_dbs_app/common/apis/driver_api.dart';
import 'package:cus_dbs_app/common/methods/common_methods.dart';
import 'package:cus_dbs_app/pages/main/home/customer/home_customer_controller.dart';
import 'package:cus_dbs_app/pages/main/home/map/values/sizes.dart';
import 'package:cus_dbs_app/values/roles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../common/entities/address_model.dart';
import '../../../../common/entities/direction_detail.dart';
import '../../../../common/entities/driver.dart';
import '../../../../common/entities/place.dart';
import '../../../../utils/firebase_messaging_handler.dart';
import '../driver/home_driver_controller.dart';
import 'values/constants.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'index.dart';

import 'package:location/location.dart';

class MapController extends GetxController {
  final state = MapState();
  GoogleMapController? controllerOfGoogleMap;

  final Completer<GoogleMapController> mapCompletePageController =
      Completer<GoogleMapController>();
  Location location = Location();
  bool get isDriver => RolesApp.roles?[0] == RolesApp.driverRole;

  bool get isAcceptedDriver =>
      isDriver && state.statusOfBooking == BOOKING_STATUS.ACCEPT;

  @override
  Future<void> onInit() async {
    super.onInit();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    var data = Get.parameters;

    // setCustomMarkerIcon();
    makeIcons();

    getCurrentLocation(() {
      if (isDriver) {
        initDataDriver();
      } else {
        initDataCustomer();
      }
    });
  }

  @override
  void onReady() async {
    super.onReady();
  }

  void initDataCustomer() {}
  void initDataDriver() {
    final driverHomeController = Get.find<DriverHomeController>();
    driverHomeController.sendLocationToBackend();
  }

  void getCurrentLocation(VoidCallback callbackSuccess) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    await location.getLocation().then(
      (location) async {
        state.currentLocation.value = location;

        print('Current location: ' + state.currentLocation.value.toString());
        print('lat ${state.currentLocation.value.latitude}');
        print('long ${state.currentLocation.value.longitude}');
        var temp = await convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(
            state.currentLocation.value);

        CameraPosition cameraPosition = CameraPosition(
            target: LatLng(state.currentLocation.value.latitude ?? 0.0,
                state.currentLocation.value.longitude ?? 0.0),
            zoom: 15);
        controllerOfGoogleMap!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      },
    );

    location.onLocationChanged.listen((newLoc) async {
      double distanceInMeters = calculateDistance(
        state.currentLocation.value.latitude ?? 0.0,
        state.currentLocation.value.longitude ?? 0.0,
        newLoc.latitude ?? 0.0,
        newLoc.longitude ?? 0.0,
      );
      if (distanceInMeters >= 10) {
        state.currentLocation.value = newLoc;
        print('new location: ${state.currentLocation.value}');
        var temp = await convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(
            state.currentLocation.value);
        print('Convert Geographic 2: $temp');
        updatePolyline(state.currentLocation.value);
        callbackSuccess();
      }
    });
  }

  Future<DirectionDetails?> getDirectionDetailsFromAPI(
      LatLng source, LatLng destination) async {
    String urlDirectionsAPI =
        "https://maps.googleapis.com/maps/api/directions/json?destination=${destination.latitude},${destination.longitude}&origin=${source.latitude},${source.longitude}&mode=driving&key=$google_api_key";

    var responseFromDirectionsAPI =
        await CommonMethods.sendRequestToGoogleMapdAPI(urlDirectionsAPI);

    if (responseFromDirectionsAPI == "error") {
      Get.snackbar('Error', 'Cannot get DIRECTION DETAILS');
      return null;
    }

    DirectionDetails detailsModel = DirectionDetails();

    detailsModel.distanceTextString =
        responseFromDirectionsAPI["routes"][0]["legs"][0]["distance"]["text"];
    detailsModel.distanceValueDigits =
        responseFromDirectionsAPI["routes"][0]["legs"][0]["distance"]["value"];

    detailsModel.durationTextString =
        responseFromDirectionsAPI["routes"][0]["legs"][0]["duration"]["text"];
    detailsModel.durationValueDigits =
        responseFromDirectionsAPI["routes"][0]["legs"][0]["duration"]["value"];

    detailsModel.encodedPoints =
        responseFromDirectionsAPI["routes"][0]["overview_polyline"]["points"];

    return detailsModel;
  }
  //
  // void moveToCurrentLocation(GoogleMapController? mapController) {
  //   mapController?.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: LatLng(state.currentLocation.value.latitude ?? 0.0,
  //             state.currentLocation.value.latitude ?? 0.0),
  //         zoom: 16.5,
  //       ),
  //     ),
  //   );
  // }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(state.currentLocation.value.latitude ?? 0.0,
          state.currentLocation.value.longitude ?? 0.0),
      PointLatLng(state.destination.latitude, state.destination.longitude),
    );
    if (result.points.isNotEmpty) {
      state.polylineCoordinates.value = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    }
  }

  void updatePolyline(LocationData? newLoc) async {
    if (newLoc == null) {
      return;
    }
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(newLoc.latitude!, newLoc.longitude!),
      PointLatLng(state.destination.latitude, state.destination.longitude),
    );
    state.polylineCoordinates.clear();

    if (result.points.isNotEmpty) {
      state.polylineCoordinates.value = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    }
  }

  Future<void> retrieveDirectionDetails() async {
    final customerHomeController = Get.find<CustomerHomeController>();

    var pickUpLocation = customerHomeController.state.pickUpLocation.value;
    var dropOffDestinationLocation =
        customerHomeController.state.dropOffLocation.value;

    var pickupGeoGraphicCoOrdinates = LatLng(
        pickUpLocation!.latitudePosition!, pickUpLocation.longitudePosition!);
    var dropOffDestinationGeoGraphicCoOrdinates = LatLng(
        dropOffDestinationLocation?.latitudePosition ?? 0.0,
        dropOffDestinationLocation?.longitudePosition ?? 0.0);

    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);

    //Directions API
    var detailsFromDirectionAPI = await getDirectionDetailsFromAPI(
        pickupGeoGraphicCoOrdinates, dropOffDestinationGeoGraphicCoOrdinates);

    customerHomeController.state.tripDirectionDetailsInfo.value =
        detailsFromDirectionAPI ?? DirectionDetails();

    EasyLoading.dismiss();

    //draw route from pickup to dropOffDestination
    PolylinePoints pointsPolyline = PolylinePoints();
    List<PointLatLng> latLngPointsFromPickUpToDestination =
        pointsPolyline.decodePolyline(customerHomeController
                .state.tripDirectionDetailsInfo.value?.encodedPoints ??
            '');
    print(
        'ENCODE POINTS ${customerHomeController.state.tripDirectionDetailsInfo.value?.encodedPoints}');
    print('POINTS POLYLINE ${latLngPointsFromPickUpToDestination.length}');
    state.polylineCoordinates.clear();
    if (latLngPointsFromPickUpToDestination.isNotEmpty) {
      latLngPointsFromPickUpToDestination.forEach((PointLatLng latLngPoint) {
        state.polylineCoordinates
            .add(LatLng(latLngPoint.latitude, latLngPoint.longitude));
      });
    }

    state.polylineSet.clear();
    print('LENGTH: ${state.polylineCoordinates.length}');
    Polyline polyline = Polyline(
      polylineId: const PolylineId("polylineID"),
      color: Colors.blueAccent,
      points: state.polylineCoordinates,
      jointType: JointType.round,
      width: 4,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    state.polylineSet.add(polyline);

    //fit the polyline into the map
    LatLngBounds boundsLatLng;
    if (pickupGeoGraphicCoOrdinates.latitude >
            dropOffDestinationGeoGraphicCoOrdinates.latitude &&
        pickupGeoGraphicCoOrdinates.longitude >
            dropOffDestinationGeoGraphicCoOrdinates.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: dropOffDestinationGeoGraphicCoOrdinates,
        northeast: pickupGeoGraphicCoOrdinates,
      );
    } else if (pickupGeoGraphicCoOrdinates.longitude >
        dropOffDestinationGeoGraphicCoOrdinates.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(pickupGeoGraphicCoOrdinates.latitude,
            dropOffDestinationGeoGraphicCoOrdinates.longitude),
        northeast: LatLng(dropOffDestinationGeoGraphicCoOrdinates.latitude,
            pickupGeoGraphicCoOrdinates.longitude),
      );
    } else if (pickupGeoGraphicCoOrdinates.latitude >
        dropOffDestinationGeoGraphicCoOrdinates.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(dropOffDestinationGeoGraphicCoOrdinates.latitude,
            pickupGeoGraphicCoOrdinates.longitude),
        northeast: LatLng(pickupGeoGraphicCoOrdinates.latitude,
            dropOffDestinationGeoGraphicCoOrdinates.longitude),
      );
    } else {
      boundsLatLng = LatLngBounds(
        southwest: pickupGeoGraphicCoOrdinates,
        northeast: dropOffDestinationGeoGraphicCoOrdinates,
      );
    }

    controllerOfGoogleMap
        ?.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 72));

    //add markers to pickup and dropOffDestination points
    Marker pickUpPointMarker = Marker(
      markerId: const MarkerId("pickUpPointMarkerID"),
      position: pickupGeoGraphicCoOrdinates,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
          title: pickUpLocation.placeName, snippet: "Pickup Location"),
    );

    Marker dropOffDestinationPointMarker = Marker(
      markerId: const MarkerId("dropOffDestinationPointMarkerID"),
      position: dropOffDestinationGeoGraphicCoOrdinates,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
          title: dropOffDestinationLocation?.placeName,
          snippet: "Destination Location"),
    );

    state.markerSet.add(pickUpPointMarker);
    state.markerSet.add(dropOffDestinationPointMarker);

    //add circles to pickup and dropOffDestination points
    Circle pickUpPointCircle = Circle(
      circleId: const CircleId('pickupCircleID'),
      strokeColor: Colors.blue,
      strokeWidth: 4,
      radius: 14,
      center: pickupGeoGraphicCoOrdinates,
      fillColor: Colors.pink,
    );

    Circle dropOffDestinationPointCircle = Circle(
      circleId: const CircleId('dropOffDestinationCircleID'),
      strokeColor: Colors.blue,
      strokeWidth: 4,
      radius: 14,
      center: dropOffDestinationGeoGraphicCoOrdinates,
      fillColor: Colors.pink,
    );

    state.circleSet.add(pickUpPointCircle);
    state.circleSet.add(dropOffDestinationPointCircle);
    customerHomeController.displayUserRideDetailsContainer();
    Get.back();
  }

  makeIcons() {
    // ImageConfiguration configuration;
    // configuration = Platform.isIOS
    //     ? (ImageConfiguration(size: Size(10, 10)))
    //     : (ImageConfiguration(size: Size(40, 40)));
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/tracking.png")
        .then((iconImage) {
      state.carIcon = iconImage;
    });

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'assets/icons/driver.png',
    ).then((icon) {
      state.destinationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'assets/icons/passenger.png',
    ).then((icon) {
      state.currentLocationIcon = icon;
    });
  }

  ///Reverse GeoCoding
  Future<String> convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(
      LocationData location) async {
    final customerHomeController = Get.find<CustomerHomeController>();

    String humanReadableAddress = "";
    String apiGeoCodingUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$google_api_key";

    var responseFromAPI =
        await CommonMethods.sendRequestToGoogleMapdAPI(apiGeoCodingUrl);

    if (responseFromAPI != "error") {
      humanReadableAddress = responseFromAPI["results"][0]["formatted_address"];

      AddressModel model = AddressModel();
      model.humanReadableAddress = humanReadableAddress;
      model.placeName = humanReadableAddress;
      model.longitudePosition = location.longitude;
      model.latitudePosition = location.latitude;

      customerHomeController.state.pickUpLocation.value = model;
    }

    return humanReadableAddress;
  }

  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    const double radiusOfEarth = 6371000; // meters
    double latDistance = degreesToRadians(endLatitude - startLatitude);
    double lonDistance = degreesToRadians(endLongitude - startLongitude);
    double a = sin(latDistance / 2) * sin(latDistance / 2) +
        cos(degreesToRadians(startLatitude)) *
            cos(degreesToRadians(endLatitude)) *
            sin(lonDistance / 2) *
            sin(lonDistance / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = radiusOfEarth * c;
    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  void updateBookingStatus(BOOKING_STATUS status) {
    state.statusOfBooking.value = status;
  }

  resetStatus() {
    final homeCustomerController = Get.find<CustomerHomeController>();
    state.polylineCoordinates.clear();
    state.polylineSet.clear();
    state.markerSet.clear();
    state.circleSet.clear();
    rideDetailsContainerHeight.value = 0;
    requestContainerHeight.value = 0;
    tripContainerHeight.value = 0;
    searchContainerHeight.value = 276;
    bottomMapPadding.value = 300;
    homeCustomerController.isDrawerOpened.value = true;
  }

  void updateMapTheme(GoogleMapController controller) {
    getJsonFileFromThemes("lib/themes/map_style.json")
        .then((value) => setGoogleMapStyle(value, controller));
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller) {
    controller.setMapStyle(googleMapStyle);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
