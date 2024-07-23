import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:miva_pos_app/app/data/models/product.dart';
import 'package:miva_pos_app/app/modules/product_category/controllers/product_list_controller.dart';
import 'package:miva_pos_app/app/modules/product_category/widgets/product_list_card.dart';
import 'package:miva_pos_app/app/routes/app_pages.dart';
import 'package:miva_pos_app/main.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> with RouteAware {
  final ProductListController productListController =
      Get.find<ProductListController>();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    productListController.getAllCategory();
    productListController.pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final ProductListController productListController =
        Get.find<ProductListController>();
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          BarcodeKeyboardListener(
              child: const SizedBox.shrink(),
              onBarcodeScanned: (String barcode) {
                productListController.searchInputController.value.text =
                    barcode;
              }),
          Obx(() => productListController.isTopPanelLoading.value
              ? LoadingAnimationWidget.prograssiveDots(
                  color: const Color(0xff40228C), size: 36)
              : Row(
                  children: [
                    const Expanded(
                      child: ProductSearch(),
                    ),
                    const FilterMenuButton(),
                    const Gap(8),
                    const SortMenuButton(),
                    const Gap(8),
                    OutlinedButton(
                        onPressed: () {
                          productListController.resetQuery();
                        },
                        child: const Text("Reset")),
                    const Gap(8)
                  ],
                )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: RefreshIndicator(
              onRefresh: () async {
                productListController.getAllCategory();
                productListController.pagingController.refresh();
              },
              child: PagedMasonryGridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                pagingController: productListController.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Product>(
                    itemBuilder: (context, item, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.ADD_PRODUCT,
                          arguments: {'productId': item.id});
                    },
                    child: ProductListCard(
                      item: item,
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

// class ProductListView extends GetView with RouteAware {
//   const ProductListView({super.key});

// }

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
      child: Obx(() => DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              buttonStyleData: ButtonStyleData(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[600]!, // Warna border
                      width: 1.0, // Ketebalan border
                    ),
                    borderRadius: BorderRadius.circular(4.0), // Sudut border
                  )),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 450,
              ),
              value: productListController.selectedCategoryFilter.value,
              onChanged: (value) {
                productListController.selectedCategoryFilter.value = value!;
                productListController.pagingController.refresh();
              },
              isDense: true,
              isExpanded: false,
              items: productListController.categoryFilterOptions.entries
                  .map((item) => DropdownMenuItem(
                        value: item.key,
                        child: Text(
                          item.value,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ))
                  .toList(),
            ),
          )),
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
      child: Obx(() => DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              buttonStyleData: ButtonStyleData(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[600]!, // Warna border
                      width: 1.0, // Ketebalan border
                    ),
                    borderRadius: BorderRadius.circular(4.0), // Sudut border
                  )),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 550,
              ),
              value: productListController.selectedSort.value,
              onChanged: (value) {
                productListController.selectedSort.value = value!;
                productListController.pagingController.refresh();
              },
              isDense: true,
              isExpanded: false,
              items: productListController.sortOptions.entries
                  .map((item) => DropdownMenuItem(
                        value: item.key,
                        child: Text(
                          item.value,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ))
                  .toList(),
            ),
          )),
    );
  }
}
