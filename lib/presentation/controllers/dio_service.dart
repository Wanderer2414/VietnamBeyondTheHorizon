import 'package:dio/dio.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/loading_screen.dart';

class DioService {
  static String? _accessToken;
  static Function()? onTokenExpired;
  static void setToken(String token) {
    _accessToken = token;
  }

  static void removeToken() {
    _accessToken = null;
  }

  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: "https://vnbth-backend.onrender.com",
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {"Content-Type": "application/json"},
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              LoadingManager.show();

              if (_accessToken != null) {
                options.headers["Authorization"] = "Bearer $_accessToken";
              }
              if (options.data is! FormData) {
                options.headers["Content-Type"] ??= "application/json";
              }
              return handler.next(options);
            },
            onResponse: (response, handler) {
              LoadingManager.hide();
              return handler.next(response);
            },
            onError: (e, handler) {
              LoadingManager.hide();

              if (e.response?.statusCode == 401) {
                removeToken();
                onTokenExpired?.call();
              }
              return handler.next(e);
            },
          ),
        );
}
