import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/repositories/category_repository.dart';
import 'package:miva_pos_app/app/data/repositories/product_repository.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';
import 'package:miva_pos_app/app/modules/product_category/views/category_list_view.dart';
import 'package:miva_pos_app/app/modules/product_category/views/product_list_view.dart';

class ProductCategoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final ProductRepository productRepository;
  final CategoryRepository categoryRepository;

  final List<Widget> tabViews = [
    const ProductListView(),
    const CategoryListView()
  ];
  RxInt selectedTab = 0.obs;

  RxInt productsCount = 0.obs;
  RxInt categoriesCount = 0.obs;

  ProductCategoryController(
      {required this.productRepository, required this.categoryRepository});

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedTab.value = tabController.index;
    });
    getProductCategoryCount();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> getProductCategoryCount() async {
    try {
      HomeController homeController = Get.find<HomeController>();
      productsCount.value = await productRepository
          .getProductsCount(homeController.loggedInBusiness.id);
      categoriesCount.value = await categoryRepository
          .getCategoriesCount(homeController.loggedInBusiness.id);
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString());
    }
  }
}
