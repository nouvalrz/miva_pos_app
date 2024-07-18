import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/repositories/category_repository.dart';

import '../controllers/add_category_controller.dart';

class AddCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepository(),
    );
    Get.lazyPut<AddCategoryController>(
      () => AddCategoryController(categoryRepository: Get.find()),
    );
  }
}
