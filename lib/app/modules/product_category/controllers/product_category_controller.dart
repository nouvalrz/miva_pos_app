import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:miva_pos_app/app/modules/product_category/views/category_list_view.dart';
import 'package:miva_pos_app/app/modules/product_category/views/product_list_view.dart';

class ProductCategoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final List<Widget> tabViews = [
    const ProductListView(),
    const CategoryListView()
  ];
  RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedTab.value = tabController.index;
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
