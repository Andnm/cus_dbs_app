import 'package:cus_dbs_app/common/entities/driver.dart';
import 'package:cus_dbs_app/common/entities/place.dart';
import 'package:cus_dbs_app/utils/http.dart';

import '../entities/booking.dart';

class DriverAPI {
  static Future<DriverItem> login({
    DriverExternalLogin? params,
  }) async {
    var response = await HttpUtil()
        .post('api/Driver/ExternalLogin', data: params?.toJson());
    return DriverItem.fromJson(response);
  }

  static Future<DriverItem> loginWithEmailAndPassword({
    DriverInternalLogin? params,
  }) async {
    var response =
        await HttpUtil().post('api/Driver/Login', data: params?.toJson());
    return DriverItem.fromJson(response);
  }

  static Future<String> register({
    DriverItem? params,
  }) async {
    var response =
        await HttpUtil().post('api/Driver/Register', data: params?.toJson());
    return response;
  }

  static Future<String> updateDriverLocation({
    PlaceLocation? params,
  }) async {
    var response =
        await HttpUtil().put('api/Driver/Location', data: params?.toJson());
    return response;
  }

  static Future<String> switchToOnline() async {
    var response = await HttpUtil().put('api/Driver/Status/Online');
    return response;
  }

  static Future<String> switchToOffline() async {
    var response = await HttpUtil().put('api/Driver/Status/Offline');
    return response;
  }

  static Future<List<BookingData>?> getAllCustomerBooking() async {
    var response = await HttpUtil().get('api/Booking/ForDriver');
    return CustomerBooking.fromJson(response).data;
    ;
  }
}
