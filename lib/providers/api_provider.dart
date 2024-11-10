import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ApiProvider {
  final LocalStorageProvider localStorage = Get.find<LocalStorageProvider>();
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://afrikababaa-571dedf1e98c.herokuapp.com/api',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      contentType: 'application/json',
      responseType: ResponseType.json,
    ),
  );

  bool _isRefreshingToken = false; // Flag pour éviter les multiples rafraîchissements
  final List<void Function()> _refreshQueue = []; // Queue pour mettre en attente les requêtes

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

  // Gérer les erreurs 401 pour rafraîchir le token
  Future<void> _handle401Error(DioException error, ErrorInterceptorHandler handler) async {
    if (_isRefreshingToken) {
      // Si le token est déjà en cours de rafraîchissement, ajoutez cette requête à la queue
      _refreshQueue.add(() => dio.fetch(error.requestOptions).then(
            handler.resolve,
            onError: handler.next,
          ));
      return;
    }

    _isRefreshingToken = true;
    final newAccessToken = await refreshToken();

    if (newAccessToken != null) {
      // Réessayer toutes les requêtes mises en attente dans la queue
      error.requestOptions.headers["Authorization"] = "Bearer $newAccessToken";
      for (var request in _refreshQueue) {
        request();
      }
      _refreshQueue.clear();
      handler.resolve(await dio.fetch(error.requestOptions));
    } else {
      // En cas d'échec, déconnectez l'utilisateur ou redirigez vers la connexion
      _logoutUser();
      handler.next(error);
    }
    _isRefreshingToken = false;
  }

  // Fonction pour rafraîchir le token
  Future<String?> refreshToken() async {
    final refreshToken = await localStorage.getToken();
    print('Rafraîchissement du token avec : $refreshToken');
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
    } catch (e) {
      print('Erreur lors du rafraîchissement du token : $e');
    }
    return null;
  }

  void _logoutUser() {
    localStorage.removeUser();
    localStorage.removeToken();
    Get.offAllNamed('/firstlogin');
  }
}
