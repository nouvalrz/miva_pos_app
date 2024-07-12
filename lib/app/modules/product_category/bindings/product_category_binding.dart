import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/repositories/category_repository.dart';
import 'package:miva_pos_app/app/data/repositories/product_repository.dart';

import 'package:miva_pos_app/app/modules/product_category/controllers/category_list_controller.dart';
import 'package:miva_pos_app/app/modules/product_category/controllers/product_list_controller.dart';

import '../controllers/product_category_controller.dart';

class ProductCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductRepository>(
      () => ProductRepository(),
    );
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepository(),
    );
    Get.lazyPut<CategoryListController>(
      () => CategoryListController(),
    );
    Get.lazyPut<ProductListController>(
      () => ProductListController(
          productRepository: Get.find(), categoryRepository: Get.find()),
    );
    Get.lazyPut<ProductCategoryController>(
      () => ProductCategoryController(
          productRepository: Get.find(), categoryRepository: Get.find()),
    );
  }
}
