import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:miva_pos_app/app/routes/app_pages.dart';

import '../controllers/product_category_controller.dart';

class ProductCategoryView extends GetView<ProductCategoryController> {
  const ProductCategoryView({super.key});
  @override
  Widget build(BuildContext context) {
    // final ProductCategoryController productCategoryController =
    //     Get.put(ProductCategoryController());
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Obx(() => controller.selectedTab.value == 0
                ? FilledButton.tonal(
                    onPressed: () {
                      Get.toNamed(Routes.ADD_PRODUCT);
                    },
                    child: const Text("Tambah Produk"),
                  )
                : FilledButton.tonal(
                    onPressed: () {
                      Get.toNamed(Routes.ADD_CATEGORY);
                    },
                    child: const Text("Tambah Kategori"))),
          )
        ],
        title: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.selectedTab.value == 0
                      ? "Kelola Produk"
                      : "Kelola Kategori",
                  style: const TextStyle(
                      fontFamily: "Inter",
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                    controller.selectedTab.value == 0
                        ? "Total semua : ${controller.productsCount.value} Produk"
                        : "Total semua : ${controller.categoriesCount.value} Kategori",
                    style: const TextStyle(
                        fontFamily: "Inter",
                        color: Colors.white,
                        fontSize: 15)),
              ],
            )),
        backgroundColor: const Color(0xFF40228C),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: SizedBox(
            height: 40,
            child: TabBar(
              dragStartBehavior: DragStartBehavior.start,
              dividerHeight: 0,
              controller: controller.tabController,
              labelColor: const Color(0xFFF0DA4E),
              unselectedLabelColor: Colors.white,
              dividerColor: Colors.white,
              indicatorWeight: 5,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: const Color(0xFFF0DA4E),
              tabs: const <Widget>[
                Tab(
                  icon: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          size: 20,
                          Icons.all_inbox_rounded,
                          color: Colors.white,
                        ),
                        Gap(8),
                        Text("Produk")
                      ],
                    ),
                  ),
                ),
                Tab(
                  icon: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          size: 20,
                          Icons.category,
                          color: Colors.white,
                        ),
                        Gap(8),
                        Text("Kategori")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
          controller: controller.tabController, children: controller.tabViews),
    );
  }
}
