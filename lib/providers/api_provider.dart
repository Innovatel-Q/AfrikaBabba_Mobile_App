import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class ApiProvider {
  final LocalStorageProvider localStorage = Get.find<LocalStorageProvider>();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL_PROD'] ?? '',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      contentType: 'application/json',
      responseType: ResponseType.json,
    ),
  );

  bool _isRefreshingToken = false;
  final List<void Function()> _refreshQueue = [];

  ApiProvider() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          String? accessToken = localStorage.getToken();
          if (accessToken != null) {
            options.headers["Accept"] = "application/json";
            options.headers["Authorization"] = "Bearer $accessToken";
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401 &&
              !error.requestOptions.path.contains('/auth/login')) {
            await _handle401Error(error, handler);
          } else {
            handler.next(error);
          }
        },
      ),
    );
  }

  Future<void> _handle401Error(DioException error, ErrorInterceptorHandler handler) async {
    if (_isRefreshingToken) {
      _refreshQueue.add(() => dio.fetch(error.requestOptions).then(
            handler.resolve,
            onError: (e, [stackTrace]) => handler.next(e),
          ));
      return;
    }

    _isRefreshingToken = true;
    final newAccessToken = await refreshToken();

    if (newAccessToken != null) {
      error.requestOptions.headers["Authorization"] = "Bearer $newAccessToken";
      for (var request in _refreshQueue) {
        request();
      }
      _refreshQueue.clear();
      handler.resolve(await dio.fetch(error.requestOptions));
    } else {
      _logoutUser();
      handler.next(error);
    }
    _isRefreshingToken = false;
  }

  Future<String?> refreshToken() async {
    final refreshToken = localStorage.getToken();
    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        await localStorage.saveToken(newAccessToken);
        return newAccessToken;
      }
    } catch (e, stackTrace) {
      print('Erreur lors du rafraîchissement du token : $e');
      print('StackTrace: $stackTrace');
    }
    return null;
  }

  void _logoutUser() {
    localStorage.removeUser();
    localStorage.removeToken();
    Get.offAllNamed('/firstlogin');
  }
}
