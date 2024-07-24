import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/models/category.dart';
import 'package:miva_pos_app/app/data/repositories/category_repository.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';
import 'package:miva_pos_app/app/modules/product_category/controllers/category_list_controller.dart';

class CategoryFormController extends GetxController {
  CategoryFormController({required this.categoryRepository});

  final formKey = GlobalKey<FormBuilderState>();
  final CategoryRepository categoryRepository;
  RxBool isLoading = false.obs;
  RxBool isEdit = false.obs;
  RxBool isPageLoading = true.obs;
  Category? currentCategory;
  Map<String, dynamic>? initialCurrentCategoryFormData;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['categoryId'] != null) {
      buildEditForm();
    } else {
      isPageLoading.value = false;
    }
  }

  Future<void> buildEditForm() async {
    isPageLoading.value = true;
    try {
      await getCurrentCategory();
      initialCurrentCategoryFormData = currentCategory!.toMapForForm();
    } catch (e) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Sorryyyy',
        desc: e.toString(),
        btnOkOnPress: () {},
      ).show();
    }
    isEdit.value = true;
    isPageLoading.value = false;
  }

  Future<void> getCurrentCategory() async {
    final categoryId = Get.arguments["categoryId"];
    currentCategory = await categoryRepository.getCategory(id: categoryId);
  }

  Future<void> submitCategory() async {
    isLoading.value = true;
    try {
      // form input validation
      if (!(formKey.currentState?.saveAndValidate() ?? false)) {
        isLoading.value = false;
        return;
      }

      //collect data from form
      Map<String, dynamic> categoryData = formKey.currentState!.value;

      // check uniqueness of category name
      if ((isEdit.value &&
              currentCategory!.name !=
                  formKey.currentState?.fields['name']?.value.toString()) ||
          !isEdit.value) {
        if (!(await isCategoryNameUnique(categoryData['name']))) {
          formKey.currentState?.fields["name"]!
              .invalidate("Nama kategori sudah digunakan!");
          isLoading.value = false;
          return;
        }
      }

      if (!isEdit.value) {
        await addCategory(categoryData: categoryData);
      } else {
        await editCategory(categoryData: categoryData);
      }
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
    isLoading.value = false;
  }

  Future<bool> isCategoryNameUnique(String categoryName) async {
    final HomeController homeController = Get.find<HomeController>();
    return await categoryRepository.getCountCategoryByName(
            businessId: homeController.loggedInBusiness.id,
            categoryName: categoryName) <
        1;
  }

  Future<void> addCategory({required Map<String, dynamic> categoryData}) async {
    final HomeController homeController = Get.find<HomeController>();
    Category storedCategory = await categoryRepository.createCategory(Category(
        id: "0",
        businessId: homeController.loggedInBusiness.id,
        name: categoryData["name"],
        createdAt: DateTime.now(),
        totalProduct: 0));
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: 'Sukses!',
      desc:
          "Kategori dengan nama #${storedCategory.name} berhasil ditambahkan!",
      btnOkOnPress: () {
        final CategoryListController categoryListController =
            Get.find<CategoryListController>();
        categoryListController.pagingController.refresh();
        Get.back();
      },
    ).show();
  }

  Future<void> editCategory(
      {required Map<String, dynamic> categoryData}) async {
    final HomeController homeController = Get.find<HomeController>();
    Category storedCategory = await categoryRepository.updateCategory(Category(
        id: currentCategory!.id,
        businessId: homeController.loggedInBusiness.id,
        name: categoryData["name"],
        createdAt: DateTime.now(),
        totalProduct: 0));
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: 'Sukses!',
      desc: "Kategori dengan nama #${storedCategory.name} berhasil diubah!",
      btnOkOnPress: () {
        final CategoryListController categoryListController =
            Get.find<CategoryListController>();
        categoryListController.pagingController.refresh();
        Get.back();
      },
    ).show();
  }
}
