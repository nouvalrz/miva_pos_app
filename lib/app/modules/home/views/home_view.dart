import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:miva_pos_app/app/modules/home/widgets/drawer_navigation_widget.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Obx(() => SizedBox(
            width: 220,
            child: controller.isLoading.value
                ? const CircularProgressIndicator()
                : const DrawerNaigationWidget())),
        Expanded(
            child: Obx(() => LazyLoadIndexedStack(
                  index: controller.selectedPage.value,
                  children: controller.pages,
                )))
      ],
    ));
  }
}
