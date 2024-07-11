import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:miva_pos_app/app/data/models/product.dart';
import 'package:miva_pos_app/app/modules/product_category/controllers/product_list_controller.dart';

class ProductListView extends GetView {
  const ProductListView({super.key});
  @override
  Widget build(BuildContext context) {
    final ProductListController productListController =
        Get.find<ProductListController>();
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Obx(() => productListController.isTopPanelLoading.value
              ? LoadingAnimationWidget.prograssiveDots(
                  color: const Color(0xff40228C), size: 36)
              : Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 40,
                          child: Obx(() => TextField(
                                controller: productListController
                                    .searchInputController.value,
                                onChanged: (value) {
                                  productListController.searchInputController
                                      .refresh();
                                },
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.search),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Cari nama atau barcode',
                                    suffixIcon: productListController
                                            .searchInputController
                                            .value
                                            .text
                                            .isNotEmpty
                                        ? IconButton(
                                            onPressed: () {
                                              productListController
                                                  .searchInputController.value
                                                  .clear();
                                              productListController
                                                  .searchInputController
                                                  .refresh();
                                            },
                                            icon: const Icon(
                                                Icons.cancel_outlined))
                                        : null,
                                    labelStyle: const TextStyle(fontSize: 14)),
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      // ignore: sized_box_for_whitespace
                      child: DropdownMenu<String>(
                        width: 280,
                        leadingIcon: const Icon(Icons.category_outlined),
                        textStyle: const TextStyle(fontSize: 14),
                        inputDecorationTheme: const InputDecorationTheme(
                            constraints: BoxConstraints(maxHeight: 40),
                            isDense: true,
                            border: OutlineInputBorder()),
                        menuHeight: 450,
                        initialSelection: productListController
                            .categoryFilterOptions.entries.first.key,
                        dropdownMenuEntries: productListController
                            .categoryFilterOptions.entries
                            .map((item) => DropdownMenuEntry(
                                value: item.key, label: item.value))
                            .toList(),
                        onSelected: (value) {
                          productListController.selectedCategoryFilter.value =
                              value!;
                        },
                      ),
                    ),
                    const Gap(8),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Row(
                          children: [Icon(Icons.sort), Text("Sort")],
                        ),
                      ),
                    ),
                    const Gap(8)
                  ],
                )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: RefreshIndicator(
              onRefresh: () async {
                productListController.pagingController.refresh();
              },
              child: PagedMasonryGridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                pagingController: productListController.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Product>(
                    itemBuilder: (context, item, index) {
                  return Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.rectangle_rounded,
                            size: 35,
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.tag_outlined,
                                      size: 12,
                                    ),
                                    Text(
                                      item.barcodeNumber,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                const Gap(6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Terjual : ${item.totalSold!}"),
                                    const Gap(22),
                                    Text(
                                        "Stok : ${item.stock != null ? item.stock! : '-'}")
                                  ],
                                ),
                                const Gap(4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      NumberFormat.currency(
                                              locale: 'id',
                                              symbol: 'Rp',
                                              decimalDigits: 0)
                                          .format(item.salePrice),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Icon(
                                      Icons.delete_outline_outlined,
                                      color: Colors.red,
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
