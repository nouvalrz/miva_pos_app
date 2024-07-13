import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:miva_pos_app/app/data/models/category.dart';
import 'package:miva_pos_app/app/modules/product_category/controllers/category_list_controller.dart';

class CategoryListView extends GetView {
  const CategoryListView({super.key});
  @override
  Widget build(BuildContext context) {
    final CategoryListController categoryListController =
        Get.find<CategoryListController>();
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: CategorySearch()),
              Padding(
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
                              borderRadius:
                                  BorderRadius.circular(4.0), // Sudut border
                            )),
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 550,
                        ),
                        value: categoryListController.selectedSort.value,
                        onChanged: (value) {
                          categoryListController.selectedSort.value = value!;
                          categoryListController.pagingController.refresh();
                        },
                        isDense: true,
                        isExpanded: false,
                        items: categoryListController.sortOptions.entries
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
              ),
              const Gap(8)
            ],
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: RefreshIndicator(
              onRefresh: () async {
                categoryListController.pagingController.refresh();
              },
              child: PagedMasonryGridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                pagingController: categoryListController.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Category>(
                    itemBuilder: (context, item, index) {
                  return GestureDetector(
                    onTap: () {
                      categoryListController.goToProductList(item.id);
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(item.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                            "Total produk : ${item.totalProduct!.toString()}"),
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

class CategorySearch extends StatelessWidget {
  const CategorySearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final CategoryListController categoryListController =
        Get.find<CategoryListController>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 40,
        child: Obx(() => TextField(
              controller: categoryListController.categorySearchController.value,
              onChanged: (value) {
                categoryListController.categorySearchController.refresh();
              },
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  labelText: 'Cari nama kategori',
                  suffixIcon: categoryListController
                          .categorySearchController.value.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            categoryListController
                                .categorySearchController.value
                                .clear();
                            categoryListController.categorySearchController
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
