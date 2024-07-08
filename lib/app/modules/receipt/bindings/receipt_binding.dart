import 'package:get/get.dart';

import '../controllers/receipt_controller.dart';

class ReceiptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiptController>(
      () => ReceiptController(),
    );
  }
}
