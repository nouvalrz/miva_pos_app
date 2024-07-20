import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/repositories/category_repository.dart';
import 'package:miva_pos_app/app/data/repositories/product_repository.dart';
import 'package:miva_pos_app/app/modules/product_category/controllers/instant_add_category_controller.dart';

import '../controllers/add_product_controller.dart';

class AddProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepository(),
    );
    Get.lazyPut<ProductRepository>(
      () => ProductRepository(),
    );
    Get.lazyPut<AddProductController>(
      () => AddProductController(
          categoryRepository: Get.find(), productRepository: Get.find()),
    );
    Get.lazyPut<InstantAddCategoryController>(
      () => InstantAddCategoryController(categoryRepository: Get.find()),
    );
  }
}
