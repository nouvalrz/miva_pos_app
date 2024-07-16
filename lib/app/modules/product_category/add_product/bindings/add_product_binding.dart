import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/repositories/category_repository.dart';
import 'package:miva_pos_app/app/data/repositories/product_repository.dart';

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
  }
}
