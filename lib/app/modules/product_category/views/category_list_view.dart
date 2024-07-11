import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:miva_pos_app/app/modules/product_category/controllers/category_list_controller.dart';

class CategoryListView extends GetView {
  const CategoryListView({super.key});
  @override
  Widget build(BuildContext context) {
    final CategoryListController categoryListController =
        Get.find<CategoryListController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('CategoryListView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CategoryListView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
