import 'package:dio/dio.dart';

class DioService {
  final Function() onTokenExpired;
  DioService({required this.onTokenExpired});
  String? _accessToken;
  String? get token => _accessToken;

  set token(String t) {
    _accessToken = t;

    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers["Authorization"] = "Bearer $_accessToken";

          if (options.data is! FormData) {
            options.headers["Content-Type"] ??= "application/json";
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (e, handler) {
          if (e.response?.statusCode == 401) {
            onTokenExpired();
          }
          return handler.next(e);
        },
      ),
    );
  }

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://vnbth-backend.onrender.com",
      connectTimeout: const Duration(seconds: 100),
      receiveTimeout: const Duration(seconds: 100),
      headers: {"Content-Type": "application/json"},
    ),
  );
}
