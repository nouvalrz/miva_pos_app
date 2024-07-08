import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/repositories/transaction_repository.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';

import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionRepository>(
      () => TransactionRepository(),
    );
    Get.lazyPut<DashboardController>(
      () => DashboardController(
          transactionRepository: Get.find(), homeController: Get.find()),
    );
  }
}
