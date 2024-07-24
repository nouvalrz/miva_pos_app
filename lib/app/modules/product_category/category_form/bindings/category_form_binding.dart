import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/repositories/category_repository.dart';

import '../controllers/category_form_controller.dart';

class CategoryFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepository(),
    );
    Get.lazyPut<CategoryFormController>(
      () => CategoryFormController(categoryRepository: Get.find()),
    );
  }
}
