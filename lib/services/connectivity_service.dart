import 'dart:async';
import 'package:afrika_baba/shared/no_connection_srenn.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


class ConnectivityController extends GetxController {

  // instance de la classe Connectivity
  final Connectivity _connectivity = Connectivity();

  // instance de la classe InternetConnectionChecker
  final InternetConnectionChecker _internetChecker = InternetConnectionChecker();


  final _connectionType = MConnectivityResult.none.obs;
  final _isConnected = false.obs;


  StreamSubscription? _connectivitySubscription;
  StreamSubscription? _internetCheckerSubscription;


  MConnectivityResult get connectionType => _connectionType.value;
  bool get isConnected => _isConnected.value;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) => _updateConnectionStatus(result));
    _internetCheckerSubscription = _internetChecker.onStatusChange.listen(_updateInternetStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result.isNotEmpty) {
        _updateConnectionStatus(result);
      } else {
        _updateConnectionStatus([ConnectivityResult.none]);
      }
      _isConnected.value = await _internetChecker.hasConnection;

    } catch (e) {
      print("Erreur lors de l'initialisation de la connectivité: $e");
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
   if(result.contains(ConnectivityResult.mobile)){
    _connectionType.value = MConnectivityResult.mobile;
   }else if(result.contains(ConnectivityResult.wifi)){
    _connectionType.value = MConnectivityResult.wifi;
   }else{
    _connectionType.value = MConnectivityResult.none;
   }
  }

 

  redirect() {
    if (!_isConnected.value) {
      Get.to(() => const NoConnectionScreen());
    }else{
      Get.back();
    }
  }

  void _updateInternetStatus(InternetConnectionStatus status) {
    _isConnected.value = status == InternetConnectionStatus.connected;
    redirect();
  }

  Future<void> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    if (result.isNotEmpty) {
      _updateConnectionStatus(result);
    } else {
      _updateConnectionStatus([ConnectivityResult.none]);
    }
    redirect();
  }


   @override
  void onClose() {
    _connectivitySubscription?.cancel();
    _internetCheckerSubscription?.cancel();
    super.onClose();
  }
}

enum MConnectivityResult { wifi, mobile, none }
