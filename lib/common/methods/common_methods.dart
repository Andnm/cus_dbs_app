import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cus_dbs_app/pages/main/home/map/values/constants.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../entities/direction_detail.dart';

class CommonMethods {
  checkConnectivity(BuildContext context) async {
    var connectionResult = await Connectivity().checkConnectivity();

    if (connectionResult != ConnectivityResult.mobile &&
        connectionResult != ConnectivityResult.wifi) {
      if (!context.mounted) return;
      Get.snackbar('your Internet is not Available',
          ' Check your connection. Try Again.');
    }
  }

  // turnOffLocationUpdatesForHomePage() {
  //   positionStreamHomePage!.pause();
  //
  //   Geofire.removeLocation(FirebaseAuth.instance.currentUser!.uid);
  // }
  //
  // turnOnLocationUpdatesForHomePage() {
  //   positionStreamHomePage!.resume();
  //
  //   Geofire.setLocation(
  //     FirebaseAuth.instance.currentUser!.uid,
  //     driverCurrentPosition!.latitude,
  //     driverCurrentPosition!.longitude,
  //   );
  // }

  static Future<dynamic> sendRequestToGoogleMapdAPI(String apiUrl) async {
    try {
      var responseFromAPI = await Dio().get(apiUrl);

      if (responseFromAPI.statusCode == 200) {
        dynamic dataFromApi = responseFromAPI.data;
        return dataFromApi;
      } else {
        return "error";
      }
    } catch (errorMsg) {
      print(errorMsg);
      return "error";
    }
  }

  //Directions API
  static Future<DirectionDetails?> getDirectionDetailsFromAPI(
      LatLng source, LatLng destination) async {
    String urlDirectionsAPI =
        "https://maps.googleapis.com/maps/api/directions/json?destination=${destination.latitude},${destination.longitude}&origin=${source.latitude},${source.longitude}&mode=driving&key=$google_api_key";

    var responseFromDirectionsAPI =
        await sendRequestToGoogleMapdAPI(urlDirectionsAPI);
    print('REPONSE DIRECT $responseFromDirectionsAPI');
    if (responseFromDirectionsAPI == "error") {
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

  static String formatCurrency(double amount) {
    // Format the amount without decimal places
    String result = amount.toStringAsFixed(0);

    // Reverse the integer part to add commas
    String reversedIntegerPart = result.split('').reversed.join();

    // Add commas after every 3 digits
    String formattedIntegerPart = reversedIntegerPart.replaceAllMapped(
      RegExp(r'.{1,3}'),
      (match) => '${match.group(0)}.',
    );

    // Reverse the formatted integer part back and remove leading comma
    formattedIntegerPart = formattedIntegerPart
        .split('')
        .reversed
        .join()
        .replaceAll(RegExp(r'^\.'), '');

    return formattedIntegerPart;
  }
}
