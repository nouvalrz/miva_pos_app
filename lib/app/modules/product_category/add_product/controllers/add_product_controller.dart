import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:miva_pos_app/app/data/models/category.dart';
import 'package:miva_pos_app/app/data/repositories/category_repository.dart';
import 'package:miva_pos_app/app/data/repositories/product_repository.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';
import 'package:miva_pos_app/app/utils/barcode_utils.dart';

class AddProductController extends GetxController {
  AddProductController(
      {required this.categoryRepository, required this.productRepository});

  final formKey = GlobalKey<FormBuilderState>();
  Rx<TextEditingController> categorySearchController =
      TextEditingController().obs;
  RxBool withStock = false.obs;
  final PagingController<int, Category> pagingController =
      PagingController(firstPageKey: 0);
  final CategoryRepository categoryRepository;
  final ProductRepository productRepository;
  final pageSize = 10;
  RxString selectedCategoryId = "".obs;

  RxBool isLoading = false.obs;

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

  void setWithStock(bool value) {
    withStock.value = value;
    formKey.currentState?.fields['stock']?.didChange("");
  }

  void setSelectedCategoryId({required String id, required String name}) {
    selectedCategoryId.value = id;
    formKey.currentState?.fields['category_id']?.didChange(name);
    Get.back();
  }

  void pickImage() {}

  void uploadImageToSupabase() {}

  void generateRandomBarcodeNumber() async {
    isLoading.value = true;
    try {
      final HomeController homeController = Get.find<HomeController>();
      String randomBarcodeNumber = "";
      int barcodeFoundCount = 1;
      do {
        randomBarcodeNumber = generateBarcodeNumber();
        barcodeFoundCount = await productRepository.getProductByBarcodeNumber(
            businessId: homeController.loggedInBusiness.id,
            barcodeNumber: randomBarcodeNumber);
      } while (barcodeFoundCount > 0);
      formKey.currentState?.fields['barcode_number']
          ?.didChange(randomBarcodeNumber);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    isLoading.value = false;
  }

  void checkUniqueBarcodeNumber() {}

  void scanExistingBarcode() {}

  void validateProductData() {}

  void addProduct() {}
}
