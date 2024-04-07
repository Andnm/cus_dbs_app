import 'package:cus_dbs_app/common/entities/identity.dart';
import 'package:cus_dbs_app/utils/http.dart';


class IdentityAPI {
  static Future<String> updateIdentityCard({
    UpdateIdentity? params,
  }) async {
    var response =
        await HttpUtil().put('api/IdentityCard', data: params?.toJson());
    return response;
  }

}
