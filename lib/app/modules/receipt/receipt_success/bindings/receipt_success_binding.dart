import 'package:get/get.dart';

import '../controllers/receipt_success_controller.dart';

class ReceiptSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiptSuccessController>(
      () => ReceiptSuccessController(),
    );
  }
}
