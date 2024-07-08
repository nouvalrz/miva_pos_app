import 'package:get/get.dart';

import '../controllers/label_print_controller.dart';

class LabelPrintBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LabelPrintController>(
      () => LabelPrintController(),
    );
  }
}
