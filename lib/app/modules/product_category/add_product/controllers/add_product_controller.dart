import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:miva_pos_app/app/data/models/category.dart';
import 'package:miva_pos_app/app/data/repositories/category_repository.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';

class AddProductController extends GetxController {
  final formKey = GlobalKey<FormBuilderState>();

  Rx<TextEditingController> categorySearchController =
      TextEditingController().obs;

  RxBool withStock = false.obs;

  final PagingController<int, Category> pagingController =
      PagingController(firstPageKey: 0);

  final CategoryRepository categoryRepository;

  AddProductController({required this.categoryRepository});
  final pageSize = 10;

  void setWithStock(bool value) {
    withStock.value = value;
  }

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
          withTotalProduct: false,
          orderQuery: CategoryRepository.ORDER_BY_NAME_ASC);
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
}
