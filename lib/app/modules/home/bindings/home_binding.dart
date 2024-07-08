import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/repositories/user_repository.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(
      () => UserRepository(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(userRepository: Get.find()),
    );
  }
}
