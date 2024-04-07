import 'package:cus_dbs_app/store/user_store.dart';
import 'package:cus_dbs_app/values/server.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HttpUtil {
  static HttpUtil instance = HttpUtil._internal();
  factory HttpUtil() => instance;

  late Dio dio;

  HttpUtil._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: SERVER_API_URL,
      headers: {},
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );

    dio = Dio(options)
      ..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      ));
  }

  Map<String, dynamic>? getAuthorizationHeader() {
    var headers = <String, dynamic>{};
    if (Get.isRegistered<UserStore>() && UserStore.to.hasToken == true) {
      headers['Authorization'] = 'Bearer ${UserStore.to.token}';
      dio.options.headers["Authorization"] = 'Bearer ${UserStore.to.token}';
    }
    return headers;
  }

  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
  }) async {
    getAuthorizationHeader();
    var response = await dio.get(path,
        queryParameters: queryParameters, onReceiveProgress: onReceiveProgress);
    return response.data;
  }

  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
    String? contentType,
  }) async {
    getAuthorizationHeader();

    var response = await dio.post(path,
        data: data,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        options: Options(
          contentType: contentType,
        ));
    return response.data;
  }

  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    getAuthorizationHeader();
    var response = await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    getAuthorizationHeader();
    var response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return response.data;
  }
}
