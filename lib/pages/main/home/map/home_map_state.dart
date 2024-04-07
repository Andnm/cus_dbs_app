import 'dart:async';
import 'dart:ui';

import 'package:cus_dbs_app/common/entities/place.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../../app/booking_status_type.dart';
import '../../../../common/entities/direction_detail.dart';

class MapState {
  Rx<BOOKING_STATUS> statusOfBooking = BOOKING_STATUS.NONE.obs;

  LatLng sourceLocation = LatLng(10.7912625, 106.6676691);
  LatLng destination = LatLng(10.8076085, 106.655907);
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;
  Rx<LocationData> currentLocation = LocationData.fromMap({}).obs;
  Rx<String> roleType = ''.obs;

  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor carIcon = BitmapDescriptor.defaultMarker;

  RxSet<Polyline> polylineSet = <Polyline>{}.obs;
  RxSet<Marker> markerSet = <Marker>{}.obs;
  RxSet<Circle> circleSet = <Circle>{}.obs;
}
