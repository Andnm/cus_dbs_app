import 'package:cus_dbs_app/common/entities/customer.dart';
import 'package:cus_dbs_app/common/entities/search_request_model.dart';
import 'package:cus_dbs_app/utils/http.dart';

class SearchRequestAPI {
  static Future<String>? searchRequest({
    SearchRequestModel? params,
  }) async {
    var response =
        await HttpUtil().post('api/SearchRequest', data: params?.toJson());

    return response.toString();
  }
}
