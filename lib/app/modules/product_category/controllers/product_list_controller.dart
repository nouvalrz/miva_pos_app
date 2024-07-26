// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:miva_pos_app/app/data/models/category.dart';

import 'package:miva_pos_app/app/data/models/product.dart';
import 'package:miva_pos_app/app/data/repositories/category_repository.dart';
import 'package:miva_pos_app/app/data/repositories/product_repository.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';

class ProductListController extends GetxController {
  final pageSize = 10;
  final ProductRepository productRepository;
  final CategoryRepository categoryRepository;

  final TextEditingController categoryFilterController =
      TextEditingController();
  Rx<TextEditingController> searchInputController = TextEditingController().obs;
  final TextEditingController sortController = TextEditingController();

  ProductListController(
      {required this.productRepository, required this.categoryRepository});

  Map<String, String> categoryFilterOptions = {"0": "Semua Kategori"};
  Map<String, String> sortOptions = {
    ProductRepository.ORDER_BY_NAME_ASC: "Urut A-Z",
    ProductRepository.ORDER_BY_NAME_DESC: "Urut Z-A",
    ProductRepository.ORDER_BY_TOTAL_SOLD_DESC: "Penjualan Terbesar",
    ProductRepository.ORDER_BY_TOTAL_SOLD_ASC: "Penjualan Terkecil"
  };

  RxString selectedSort = ProductRepository.ORDER_BY_NAME_ASC.obs;
  RxString selectedCategoryFilter = "0".obs;

  final PagingController<int, Product> pagingController =
      PagingController(firstPageKey: 0);

  RxBool isTopPanelLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getAllCategory();
    pagingController.addPageRequestListener((pageKey) {
      getAllProduct(pageKey);
    });
    searchInputController.value.addListener(() {
      pagingController.refresh();
    });
  }

  Future<void> getAllProduct(pageKey) async {
    try {
      final HomeController homeController = Get.find<HomeController>();
      List<Product> productList = await productRepository.getAllProduct(
          businessId: homeController.loggedInBusiness.id,
          withTotalSold: true,
          limit: pageSize,
          offset: pageKey,
          searchKeyword: searchInputController.value.text,
          categoryId: selectedCategoryFilter.value,
          orderQuery: selectedSort.value);
      final isLastPage = productList.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(productList);
      } else {
        final nextPageKey = pageKey + productList.length;
        pagingController.appendPage(productList, nextPageKey);
      }
    } catch (e) {
      pagingController.error = e;
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> getAllCategory() async {
    isTopPanelLoading.value = true;
    try {
      final HomeController homeController = Get.find<HomeController>();
      List<Category> categoryList = await categoryRepository.getAllCategory(
          businessId: homeController.loggedInBusiness.id, withoutLimit: true);
      categoryFilterOptions
          .addAll({for (var item in categoryList) item.id: item.name});
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    isTopPanelLoading.value = false;
  }

  void resetQuery() {
    searchInputController.value.clear();
    searchInputController.refresh();
    selectedCategoryFilter.value = "0";
    selectedSort.value = ProductRepository.ORDER_BY_NAME_ASC;
    pagingController.refresh();
  }
}
