import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/repositories/business_repository.dart';
import 'package:miva_pos_app/app/data/repositories/transaction_repository.dart';
import 'package:miva_pos_app/app/data/repositories/user_repository.dart';
import 'package:miva_pos_app/app/modules/dashboard/controllers/dashboard_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(
      () => UserRepository(),
    );
    Get.lazyPut<BusinessRepository>(
      () => BusinessRepository(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(
          userRepository: Get.find(), businessRepository: Get.find()),
    );
    Get.lazyPut<TransactionRepository>(
      () => TransactionRepository(),
    );
    Get.lazyPut<DashboardController>(
      () => DashboardController(
          transactionRepository: Get.find(), homeController: Get.find()),
    );
  }
}
