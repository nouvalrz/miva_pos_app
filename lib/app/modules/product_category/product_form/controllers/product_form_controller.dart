import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:miva_pos_app/app/data/models/category.dart';
import 'package:miva_pos_app/app/data/models/product.dart';
import 'package:miva_pos_app/app/data/repositories/category_repository.dart';
import 'package:miva_pos_app/app/data/repositories/product_repository.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';
import 'package:miva_pos_app/app/utils/barcode_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductFormController extends GetxController {
  ProductFormController(
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
  final ImagePicker imagePicker = ImagePicker();
  File? image;
  RxBool isImagePick = false.obs;
  RxBool isProcessLoading = false.obs;
  RxBool isPageLoading = true.obs;

  RxBool isEdit = false.obs;
  RxBool isImagePickOnEdit = false.obs;
  Product? currentProduct;
  Map<String, dynamic>? initialCurrentProductFormData;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['productId'] != null) {
      buildEditForm();
    } else {
      isPageLoading.value = false;
    }
    pagingController.addPageRequestListener((pageKey) {
      getAllCategory(pageKey);
    });
    categorySearchController.value.addListener(() {
      pagingController.refresh();
    });
  }

  Future<void> buildEditForm() async {
    isPageLoading.value = true;
    try {
      await getCurrentProduct();
      initialCurrentProductFormData = currentProduct!.toMapForForm();
      if (currentProduct!.imageUrl != null) {
        isImagePick.value = true;
      }
      if (currentProduct!.stock != null) {
        withStock.value = true;
      }
      selectedCategoryId.value = currentProduct!.categoryId;
    } catch (e) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Sorryyyy',
        desc: e.toString(),
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    }
    isEdit.value = true;
    isPageLoading.value = false;
  }

  Future<void> getCurrentProduct() async {
    final productId = Get.arguments["productId"];
    currentProduct =
        await productRepository.getProduct(id: productId.toString());
    print(currentProduct!);
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
    formKey.currentState?.fields['category_name']?.didChange(name);
    Get.back();
  }

  Future<void> pickImage(ImageSource source) async {
    if (!(await InternetConnection().hasInternetAccess)) {
      isImagePick.value = false;
      image = null;
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'Gambar tidak bisa diupload!',
        desc:
            "Maaf saat ini tidak ada internet, anda masih bisa input produk tanpa gambar",
        btnOkOnPress: () {},
      ).show();
      return;
    }
    // isImagePick.value = false;
    final pickedFile = await imagePicker.pickImage(
        source: source, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));
      if (croppedFile != null) {
        if (isEdit.value) {
          isImagePickOnEdit.value = true;
        }
        image = File(croppedFile.path);
        isImagePick.value = false;
        isImagePick.value = true;
      }
    }
  }

  void removeImage() {
    isImagePick.value = false;
    image = null;
  }

  Future<String> uploadImageToSupabase() async {
    final HomeController homeController = Get.find<HomeController>();
    final String fileName =
        'public/product-${homeController.loggedInBusiness.id}-${DateTime.now().millisecondsSinceEpoch}.png';
    await Supabase.instance.client.storage
        .from('miva_pos_app_product_images')
        .upload(fileName, image!);
    return Supabase.instance.client.storage
        .from('miva_pos_app_product_images')
        .getPublicUrl(fileName);
  }

  void generateRandomBarcodeNumber() async {
    isProcessLoading.value = true;
    try {
      final HomeController homeController = Get.find<HomeController>();
      String randomBarcodeNumber = "";
      int barcodeFoundCount = 1;
      do {
        randomBarcodeNumber = generateBarcodeNumber();
        barcodeFoundCount =
            await productRepository.getCountProductByBarcodeNumber(
                businessId: homeController.loggedInBusiness.id,
                barcodeNumber: randomBarcodeNumber);
      } while (barcodeFoundCount > 0);
      formKey.currentState?.fields['barcode_number']
          ?.didChange(randomBarcodeNumber);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    isProcessLoading.value = false;
  }

  Future<bool> isBarcodeNumberUnique(String barcodeNumber) async {
    final HomeController homeController = Get.find<HomeController>();
    return await productRepository.getCountProductByBarcodeNumber(
            businessId: homeController.loggedInBusiness.id,
            barcodeNumber: barcodeNumber) <
        1;
  }

  void scanExistingBarcode() {}

  Future<void> addProduct() async {
    isProcessLoading.value = true;
    bool imageUploadProblem = false;
    try {
      final HomeController homeController = Get.find<HomeController>();
      String? publicImageUrl;
      if (!(formKey.currentState?.saveAndValidate() ?? false)) {
        isProcessLoading.value = false;
        return;
      }
      if (image != null) {
        if (await InternetConnection().hasInternetAccess) {
          publicImageUrl = await uploadImageToSupabase();
        } else {
          imageUploadProblem = true;
          isImagePick.value = false;
          image = null;
        }
      }

      Map<String, dynamic> productData = formKey.currentState!.value;

      if (!(await isBarcodeNumberUnique(productData["barcode_number"]))) {
        formKey.currentState?.fields["barcode_number"]!
            .invalidate("Barcode sudah digunakan!");
        isProcessLoading.value = false;

        return;
      }

      Product storedProduct = await productRepository.createProduct(Product(
          categoryName: null,
          id: "-",
          businessId: homeController.loggedInBusiness.id,
          categoryId: selectedCategoryId.value,
          barcodeNumber: productData["barcode_number"],
          name: productData["name"],
          salePrice: int.parse(
              productData["sale_price"].toString().replaceAll(".", "")),
          costPrice: int.parse(
              productData["cost_price"].toString().replaceAll(".", "")),
          stock: productData["stock"] != null
              ? int.parse(productData["stock"])
              : null,
          unit: productData["unit"],
          createdAt: DateTime.now(),
          imageUrl: publicImageUrl,
          totalSold: 0));
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Sukses!',
        desc:
            "Produk barcode #${storedProduct.barcodeNumber} berhasil ditambahkan! ${imageUploadProblem ? 'Namun gambar tidak bisa di-upload, karena tidak ada internet. Anda bisa upload pada menu Update Produk ketika sudah ada internet ya!' : ''}",
        btnOkOnPress: () {
          Get.back();
        },
      ).show();
    } catch (e) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Sorryyyy',
        desc: e.toString(),
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    }
    isProcessLoading.value = false;
  }
}
