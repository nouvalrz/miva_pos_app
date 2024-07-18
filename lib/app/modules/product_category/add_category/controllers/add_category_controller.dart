import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/models/category.dart';
import 'package:miva_pos_app/app/data/repositories/category_repository.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';
import 'package:miva_pos_app/app/modules/product_category/controllers/category_list_controller.dart';

class AddCategoryController extends GetxController {
  AddCategoryController({required this.categoryRepository});

  final formKey = GlobalKey<FormBuilderState>();
  final CategoryRepository categoryRepository;
  RxBool isLoading = false.obs;

  Future<void> addCategory() async {
    isLoading.value = true;
    try {
      final HomeController homeController = Get.find<HomeController>();
      if (!(formKey.currentState?.saveAndValidate() ?? false)) {
        isLoading.value = false;
        return;
      }
      Map<String, dynamic> categoryData = formKey.currentState!.value;

      if (!(await isCategoryNameUnique(categoryData['name']))) {
        formKey.currentState?.fields["name"]!
            .invalidate("Nama kategori sudah digunakan!");
        isLoading.value = false;
        return;
      }

      Category storedCategory = await categoryRepository.createCategory(
          Category(
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
}
