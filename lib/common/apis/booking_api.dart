import 'package:cus_dbs_app/common/entities/booking.dart';
import 'package:cus_dbs_app/common/entities/customer.dart';
import 'package:cus_dbs_app/common/entities/search_request_model.dart';
import 'package:cus_dbs_app/utils/http.dart';

class BookingAPI {
  static Future<String> requestBooking({
    BookingRequestModel? params,
  }) async {
    var response = await HttpUtil().post('api/Booking', data: params?.toJson());
    return response;
  }

  static Future<BookingItem?> changeStatus(
      {BookingRequestModel? params}) async {
    var response = await HttpUtil()
        .put('api/Booking/ChangeStatus', data: params?.toJson());

    return BookingItem.fromJson(response);
    ;
  }
}
