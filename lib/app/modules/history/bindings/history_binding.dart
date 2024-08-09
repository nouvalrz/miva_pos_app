import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/repositories/receipt_repository.dart';

import '../controllers/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiptRepository>(
      () => ReceiptRepository(),
    );
    Get.lazyPut<HistoryController>(
      () => HistoryController(receiptRepository: Get.find()),
    );
  }
}
