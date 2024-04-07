import 'dart:convert';

import 'package:cus_dbs_app/common/entities/customer.dart';
import 'package:cus_dbs_app/common/entities/identity.dart';
import 'package:cus_dbs_app/utils/http.dart';

import '../entities/driver.dart';

class CustomerAPI {
  static Future<CustomerItem> login({
    CustomerExternalLogin? params,
  }) async {
    var response = await HttpUtil()
        .post('api/Customer/ExternalLogin', data: params?.toJson());
    return CustomerItem.fromJson(response);
  }

  static Future<CustomerItem> loginWithEmailAndPassword({
    CustomerItem? params,
  }) async {
    var response =
        await HttpUtil().post('api/Customer/Login', data: params?.toJson());
    return CustomerItem.fromJson(response);
  }

  static Future<String> register({
    CustomerRegister? params,
  }) async {
    var response =
        await HttpUtil().post('api/Customer/Register', data: params?.toJson());
    return response;
  }

  static Future<String> updateProfile({
    CustomerUpdateProfile? params,
  }) async {
    var response =
        await HttpUtil().put('api/Customer/Profile', data: params?.toJson());
    return response;
  }

  static Future<List<OnlineNearByDriver>> getOnlineNearByDrivers(
      {double? radius,
      double? currentLatitude,
      double? currentLongtitude}) async {
    var response = await HttpUtil().get(
        'api/Driver/Online?Radius=$radius&Latitude=$currentLatitude&Longitude=$currentLongtitude');
    return List<OnlineNearByDriver>.from(
        (response).map((e) => OnlineNearByDriver.fromJson(e)));
  }

  // static Future<List<OnlineDriver>> getOnlineDrivers(
  //     {double? radius,
  //     double? currentLatitude,
  //     double? currentLongtitude}) async {
  //   var response = await HttpUtil().get(
  //     'api/Driver/Online?radius=$radius&currentLatitude=$currentLatitude&currentLongitude=$currentLongtitude',
  //   );
  //
  //   List<dynamic> jsonData = jsonDecode(response);
  //   List<OnlineDriver> onlineDrivers =
  //       jsonData.map((data) => OnlineDriver.fromJson(data)).toList();
  //   return onlineDrivers;
  // }
}
