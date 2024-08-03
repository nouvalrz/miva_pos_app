import 'dart:async';

import 'package:get/get.dart';
import "package:miva_pos_app/app/services/powersync_service.dart";

class SplashController extends GetxController {
  RxBool isReady = false.obs;
  StreamSubscription? _syncStatusSubscription;
  @override
  void onInit() async {
    super.onInit();

    _syncStatusSubscription = db.statusStream.listen((status) {
      var statusSync = status.hasSynced ?? false;
      if (statusSync) {
        Get.offAllNamed('/home');
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    _syncStatusSubscription?.cancel();
  }
}
