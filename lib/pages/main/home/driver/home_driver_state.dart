import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverHomeState {
  Rx<Color> colorToShow = Colors.green.obs;
  Rx<String> titleToShow = "ONLINE".obs;
  Rx<bool> isDriverAvailable = true.obs;
}
