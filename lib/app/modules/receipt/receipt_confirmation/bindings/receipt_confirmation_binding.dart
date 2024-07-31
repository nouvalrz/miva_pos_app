import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/repositories/payment_method_repository.dart';
import 'package:miva_pos_app/app/data/repositories/receipt_repository.dart';

import '../controllers/receipt_confirmation_controller.dart';

class ReceiptConfirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentMethodRepository>(
      () => PaymentMethodRepository(),
    );
    Get.lazyPut<ReceiptRepository>(
      () => ReceiptRepository(),
    );
    Get.lazyPut<ReceiptConfirmationController>(
      () => ReceiptConfirmationController(
          paymentMethodRepository: Get.find(), receiptRepository: Get.find()),
    );
  }
}
