import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:miva_pos_app/app/modules/home/widgets/drawer_navigation_widget.dart';
import 'package:miva_pos_app/app/modules/home/widgets/miva_navigation_rail_widget.dart';
import 'package:miva_pos_app/app/modules/home/widgets/miva_v2_navigation.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  SizedBox(
                      width: 220,
                      child: controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : const MivaV2Navigation()),
                  // const VerticalDivider(
                  //   width: 0.7,
                  // ),
                  Expanded(
                      child: Obx(() => LazyLoadIndexedStack(
                            index: controller.selectedPage.value,
                            children: controller.pages,
                          )))
                ],
              )));
  }
}
