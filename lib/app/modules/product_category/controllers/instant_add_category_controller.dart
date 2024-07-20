import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/models/category.dart';
import 'package:miva_pos_app/app/data/repositories/category_repository.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';

class InstantAddCategoryController extends GetxController {
  InstantAddCategoryController({required this.categoryRepository});

  final formKey = GlobalKey<FormBuilderState>();
  final CategoryRepository categoryRepository;

  RxBool isLoading = false.obs;

  Future<bool> addCategory() async {
    isLoading.value = true;
    try {
      final HomeController homeController = Get.find<HomeController>();
      if (!(formKey.currentState?.saveAndValidate() ?? false)) {
        isLoading.value = false;
        return false;
      }

      Map<String, dynamic> categoryData = formKey.currentState!.value;

      if (!(await isCategoryNameUnique(categoryData['name']))) {
        formKey.currentState?.fields["name"]!
            .invalidate("Nama kategori sudah digunakan!");
        isLoading.value = false;
        return false;
      }

      Category storedCategory = await categoryRepository.createCategory(
          Category(
              id: "0",
              businessId: homeController.loggedInBusiness.id,
              name: categoryData["name"],
              createdAt: DateTime.now(),
              totalProduct: 0));
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
    return true;
  }

  Future<bool> isCategoryNameUnique(String categoryName) async {
    final HomeController homeController = Get.find<HomeController>();
    return await categoryRepository.getCountCategoryByName(
            businessId: homeController.loggedInBusiness.id,
            categoryName: categoryName) <
        1;
  }
}
