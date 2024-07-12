import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:miva_pos_app/app/data/models/product.dart';
import 'package:miva_pos_app/app/modules/product_category/controllers/product_list_controller.dart';
import 'package:miva_pos_app/app/modules/product_category/widgets/product_list_card.dart';

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
              : const Row(
                  children: [
                    Expanded(
                      child: ProductSearch(),
                    ),
                    FilterMenuButton(),
                    Gap(8),
                    SortMenuButton(),
                    Gap(8)
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
                  return ProductListCard(
                    item: item,
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

class ProductSearch extends StatelessWidget {
  const ProductSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ProductListController productListController =
        Get.find<ProductListController>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 40,
        child: Obx(() => TextField(
              controller: productListController.searchInputController.value,
              onChanged: (value) {
                productListController.searchInputController.refresh();
              },
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  labelText: 'Cari nama atau barcode',
                  suffixIcon: productListController
                          .searchInputController.value.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            productListController.searchInputController.value
                                .clear();
                            productListController.searchInputController
                                .refresh();
                          },
                          icon: const Icon(Icons.cancel_outlined))
                      : null,
                  labelStyle: const TextStyle(fontSize: 14)),
            )),
      ),
    );
  }
}

class FilterMenuButton extends StatelessWidget {
  const FilterMenuButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ProductListController productListController =
        Get.find<ProductListController>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      // ignore: sized_box_for_whitespace
      child: DropdownMenu<String>(
        width: 260,
        leadingIcon: const Icon(Icons.category_outlined),
        textStyle: const TextStyle(fontSize: 14),
        inputDecorationTheme: const InputDecorationTheme(
            constraints: BoxConstraints(maxHeight: 40),
            isDense: true,
            border: OutlineInputBorder()),
        menuHeight: 450,
        initialSelection:
            productListController.categoryFilterOptions.entries.first.key,
        dropdownMenuEntries: productListController.categoryFilterOptions.entries
            .map(
                (item) => DropdownMenuEntry(value: item.key, label: item.value))
            .toList(),
        onSelected: (value) {
          productListController.selectedCategoryFilter.value = value!;
          productListController.pagingController.refresh();
        },
      ),
    );
  }
}

class SortMenuButton extends StatelessWidget {
  const SortMenuButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ProductListController productListController =
        Get.find<ProductListController>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      // ignore: sized_box_for_whitespace
      child: DropdownMenu<String>(
        width: 200,
        leadingIcon: const Icon(Icons.sort_rounded),
        textStyle: const TextStyle(fontSize: 14),
        inputDecorationTheme: const InputDecorationTheme(
            constraints: BoxConstraints(maxHeight: 40),
            isDense: true,
            border: OutlineInputBorder()),
        menuHeight: 450,
        initialSelection: productListController.sortOptions.entries.first.key,
        dropdownMenuEntries: productListController.sortOptions.entries
            .map(
                (item) => DropdownMenuEntry(value: item.key, label: item.value))
            .toList(),
        onSelected: (value) {
          productListController.selectedSort.value = value!;
          productListController.pagingController.refresh();
        },
      ),
    );
  }
}
