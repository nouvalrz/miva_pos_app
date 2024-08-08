import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:miva_pos_app/app/data/models/category.dart';
import 'package:miva_pos_app/app/data/models/product.dart';
import 'package:miva_pos_app/app/data/repositories/category_repository.dart';
import 'package:miva_pos_app/app/data/repositories/product_repository.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';

class ReceiptController extends GetxController {
  final Rx<String> currentTime = ''.obs;

  var receiptProducts = <Product>[].obs;

  RxInt unpickProductCount = 1.obs;

  final pageSize = 10;
  final ProductRepository productRepository;
  final CategoryRepository categoryRepository;

  ReceiptController(
      {required this.categoryRepository, required this.productRepository});

  Map<String, String> categoryFilterOptions = {"0": "Semua Kategori"};

  RxString selectedCategoryFilter = "0".obs;

  final PagingController<int, Product> pagingController =
      PagingController(firstPageKey: 0);

  RxBool isTopPanelLoading = true.obs;

  final TextEditingController categoryFilterController =
      TextEditingController();
  Rx<TextEditingController> searchInputController = TextEditingController().obs;

  Rx<int> get totalPrice => Rx<int>(receiptProducts.fold<int>(0,
      (sum, product) => sum + (product.salePrice * product.receiptQuantity)));

  Rx<int> get totalQuantity => Rx<int>(receiptProducts.fold<int>(
      0, (sum, product) => sum + product.receiptQuantity));

  ScrollController receiptProductsScrollController = ScrollController();
  ScrollController summaryReceiptScrollController = ScrollController();

  late AudioPlayer audioPlayer;

  @override
  void onClose() {
    receiptProductsScrollController.dispose();
    summaryReceiptScrollController.dispose();
    audioPlayer.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _updateTime();
    Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
    getAllCategory();
    pagingController.addPageRequestListener((pageKey) {
      getAllProduct(pageKey);
    });
    searchInputController.value.addListener(() {
      pagingController.refresh();
    });
    audioPlayer = AudioPlayer();
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
          categoryId: selectedCategoryFilter.value);
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
    pagingController.refresh();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    final DateFormat formatter =
        DateFormat('EEEE, d MMM y - HH:mm:ss', 'id_ID');
    currentTime.value = formatter.format(now);
  }

  void addUnpickProduct() {
    unpickProductCount.value = unpickProductCount.value + 1;
  }

  void removeUnpickProduct() {
    if (unpickProductCount.value <= 1) {
      return;
    }
    unpickProductCount.value = unpickProductCount.value - 1;
  }

  void addProduct(Product product) {
    int index = receiptProducts.indexWhere((item) => item.id == product.id);
    if (index == -1) {
      product.receiptQuantity = 1;
      receiptProducts.add(product);
      playSound('success_add_product');
      Get.back();
    } else {
      setProductQuantity(
          newQuantity: receiptProducts[index].receiptQuantity + 1,
          productIndex: index);
    }
    receiptProducts.refresh();
    removeUnpickProduct();
  }

  void removeProduct(int productIndex) {
    receiptProducts.removeAt(productIndex);
    receiptProducts.refresh();
    playSound('success_remove_product');
  }

  void setProductQuantity({required int newQuantity, required productIndex}) {
    if (receiptProducts[productIndex].stock != null) {
      if (newQuantity > receiptProducts[productIndex].stock!) {
        Get.snackbar(
          "Notifikasi",
          "Stok produk ${receiptProducts[productIndex].name} sudah digunakan semua",
          backgroundColor: const Color(0xffF0DA4E),
          boxShadows: [
            BoxShadow(
              color: const Color.fromARGB(0, 96, 96, 96).withOpacity(1),
              offset: const Offset(0, 3),
              blurRadius: 8,
              spreadRadius: 1,
            )
          ],
        );
        return;
      }
    }
    receiptProducts[productIndex].receiptQuantity = newQuantity;
    receiptProducts.refresh();
    Get.back();
    playSound('success_add_product');
  }

  Future<void> addProductByScanner(String barcodeNumber) async {
    final HomeController homeController = Get.find<HomeController>();
    try {
      Product selectedProduct =
          await productRepository.getProductByBarcodeNumber(
              businessId: homeController.loggedInBusiness.id,
              barcodeNumber: barcodeNumber);
      addProduct(selectedProduct);
      scrollToBottom();
    } catch (e) {
      Get.snackbar(
        "Notifikasi",
        "Barcode tidak ditemukan!",
        backgroundColor: const Color(0xffF0DA4E),
        boxShadows: [
          BoxShadow(
            color: const Color.fromARGB(0, 96, 96, 96).withOpacity(1),
            offset: const Offset(0, 3),
            blurRadius: 8,
            spreadRadius: 1,
          )
        ],
      );
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (receiptProductsScrollController.hasClients) {
        receiptProductsScrollController.animateTo(
          receiptProductsScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
      if (summaryReceiptScrollController.hasClients) {
        summaryReceiptScrollController.animateTo(
          summaryReceiptScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> playSound(String soundName) async {
    try {
      // await audioPlayer.setAsset('assets/sounds/$soundName.mp3');
      // await audioPlayer.play();
      await audioPlayer.play(AssetSource('sounds/$soundName.mp3'));
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
