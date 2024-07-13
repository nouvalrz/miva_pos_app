import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:miva_pos_app/app/data/models/category.dart';
import 'package:miva_pos_app/app/data/repositories/category_repository.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';
import 'package:miva_pos_app/app/modules/product_category/controllers/product_category_controller.dart';
import 'package:miva_pos_app/app/modules/product_category/controllers/product_list_controller.dart';

class CategoryListController extends GetxController {
  Rx<TextEditingController> categorySearchController =
      TextEditingController().obs;

  Map<String, String> sortOptions = {
    CategoryRepository.ORDER_BY_NAME_ASC: "Urut A-Z",
    CategoryRepository.ORDER_BY_NAME_DESC: "Urut Z-A",
    CategoryRepository.ORDER_BY_TOTAL_PRODUCT_DESC: "Produk Terbanyak",
    CategoryRepository.ORDER_BY_TOTAL_PRODUCT_ASC: "Produk Tersedikit"
  };

  final pageSize = 10;

  RxString selectedSort = CategoryRepository.ORDER_BY_NAME_ASC.obs;

  final PagingController<int, Category> pagingController =
      PagingController(firstPageKey: 0);

  final CategoryRepository categoryRepository;

  CategoryListController({required this.categoryRepository});

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      getAllCategory(pageKey);
    });
    categorySearchController.value.addListener(() {
      pagingController.refresh();
    });
  }

  Future<void> getAllCategory(pageKey) async {
    try {
      final HomeController homeController = Get.find<HomeController>();
      List<Category> categoryList = await categoryRepository.getAllCategory(
          businessId: homeController.loggedInBusiness.id,
          limit: pageSize,
          offset: pageKey,
          searchKeyword: categorySearchController.value.text,
          withTotalProduct: true,
          orderQuery: selectedSort.value);
      final isLastPage = categoryList.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(categoryList);
      } else {
        final nextPageKey = pageKey + categoryList.length;
        pagingController.appendPage(categoryList, nextPageKey);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void goToProductList(String categoryId) {
    final ProductCategoryController productCategoryController =
        Get.find<ProductCategoryController>();
    final ProductListController productListController =
        Get.find<ProductListController>();
    productListController.resetQuery();
    productListController.selectedCategoryFilter.value = categoryId;
    productListController.pagingController.refresh();
    productCategoryController.tabController.animateTo(0);
  }
}
