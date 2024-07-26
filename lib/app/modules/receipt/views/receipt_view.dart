import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:miva_pos_app/app/data/models/product.dart';
import 'package:miva_pos_app/app/modules/product_category/widgets/product_list_card.dart';

import 'package:miva_pos_app/app/widgets/miva_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../controllers/receipt_controller.dart';

class ReceiptView extends GetView<ReceiptController> {
  const ReceiptView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 65,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kasir',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
            Obx(() => Text(controller.currentTime.value,
                style: const TextStyle(color: Colors.white, fontSize: 15)))
          ],
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFF40228C),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "List Barang",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          BarcodeKeyboardListener(
                              bufferDuration: const Duration(milliseconds: 200),
                              child: const SizedBox.shrink(),
                              onBarcodeScanned: (String barcode) {
                                controller.addProductByScanner(barcode);
                              }),
                        ],
                      ),
                      SizedBox(
                        height: 32,
                        child: TextButton.icon(
                          onPressed: () {
                            controller.addUnpickProduct();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 6),
                            alignment: Alignment.center,
                          ),
                          icon: const Icon(
                            FontAwesomeIcons.plus,
                            size: 16,
                          ),
                          label: const Text("Tambah Item"),
                        ),
                      )
                    ],
                  ),
                  const Gap(3),
                  Expanded(
                      child: Obx(() => ListView.builder(
                            controller:
                                controller.receiptProductsScrollController,
                            itemBuilder: (context, index) {
                              final totalItem =
                                  controller.receiptProducts.length +
                                      controller.unpickProductCount.value;
                              final unpickStartIndex = totalItem -
                                  controller.unpickProductCount.value;
                              final unpickEndIndex = totalItem - 1;
                              if (!(index >= unpickStartIndex &&
                                  index <= unpickEndIndex)) {
                                return PickedReceiptProductCard(
                                  productIndex: index,
                                );
                              } else {
                                return const UnpickedReceiptProductCard();
                              }
                            },
                            itemCount: controller.receiptProducts.length +
                                controller.unpickProductCount.value,
                          )))
                ],
              ),
            ),
          ),
          VerticalDivider(
            color: Colors.grey.withOpacity(0.25),
            width: 0,
          ),
          Expanded(
            flex: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(6),
                  const Text(
                    "Rangkuman",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                      child: MivaCard.filled(
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Obx(() => controller
                                        .receiptProducts.isEmpty
                                    ? const Center(
                                        child: Text("Produk masih kosong"),
                                      )
                                    : ListView.builder(
                                        controller: controller
                                            .summaryReceiptScrollController,
                                        itemBuilder: (context, index) {
                                          final receiptProduct =
                                              controller.receiptProducts[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  receiptProduct.name,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        "${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(receiptProduct.salePrice)} x${receiptProduct.receiptQuantity}"),
                                                    Text(NumberFormat.currency(
                                                            locale: 'id',
                                                            symbol: 'Rp',
                                                            decimalDigits: 0)
                                                        .format(receiptProduct
                                                                .salePrice *
                                                            receiptProduct
                                                                .receiptQuantity)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        itemCount:
                                            controller.receiptProducts.length,
                                      ))),
                            const Gap(6),
                            Divider(
                              color: Colors.grey.withOpacity(0.25),
                              height: 0,
                            ),
                            const Gap(6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Barang :",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(() => Text(
                                      controller.totalQuantity.value.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ],
                            ),
                            const Gap(8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Harga :",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(() => Text(
                                      NumberFormat.currency(
                                              locale: 'id',
                                              symbol: 'Rp',
                                              decimalDigits: 0)
                                          .format(controller.totalPrice.value),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ],
                            ),
                            const Gap(8),
                          ],
                        ),
                      ),
                    ),
                  )),
                  const Gap(6),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xff40228C)),
                      ),
                      onPressed: () {
                        // Aksi ketika tombol ditekan
                      },
                      child: const Text(
                        "Checkout",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PickedReceiptProductCard extends StatelessWidget {
  final int productIndex;

  const PickedReceiptProductCard({super.key, required this.productIndex});

  @override
  Widget build(BuildContext context) {
    final ReceiptController receiptController = Get.find<ReceiptController>();
    final product = receiptController.receiptProducts[productIndex];
    return MivaCard.outline(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              product.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl!,
                        width: 35,
                        height: 35,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.grey,
                      ),
                      width: 35,
                      height: 35,
                      child: const SizedBox.shrink(),
                    ),
            ],
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const Gap(4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InputQty(
                      maxVal: product.stock ?? double.infinity,
                      key: Key(product.receiptQuantity.toString()),
                      initVal: product.receiptQuantity,
                      qtyFormProps: const QtyFormProps(),
                      minVal: 1,
                      onQtyChanged: (value) {
                        receiptController.setProductQuantity(
                            newQuantity: value.toInt(),
                            productIndex: productIndex);
                      },
                      decoration: QtyDecorationProps(
                          plusBtn: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: const Color(0xffDAF8E0)),
                              child: const Icon(
                                FontAwesomeIcons.plus,
                                size: 16,
                                color: Color(0xff003B0D),
                              ),
                            ),
                          ),
                          minusBtn: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: const Color(0xffFFE4E4)),
                              child: const Icon(
                                FontAwesomeIcons.minus,
                                size: 16,
                                color: Color(0xff7D070D),
                              ),
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(6),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.25)))),
                    ),
                    const Gap(8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.stock != null)
                          Text(
                            "Sisa stok : ${product.stock!}",
                            style: const TextStyle(fontSize: 13),
                          ),
                        Text(
                          "${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(product.salePrice)} x${product.receiptQuantity}",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Text(
            NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0)
                .format(product.salePrice * product.receiptQuantity),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const Gap(4),
          IconButton(
              onPressed: () {
                receiptController.removeProduct(productIndex);
              },
              icon: const Icon(
                size: 16,
                FontAwesomeIcons.trash,
                color: Color.fromARGB(255, 209, 66, 56),
              ))
        ],
      ),
    );
  }
}

class UnpickedReceiptProductCard extends StatelessWidget {
  const UnpickedReceiptProductCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ReceiptController controller = Get.find<ReceiptController>();
    return MivaCard.outline(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color.fromARGB(255, 207, 207, 207),
                ),
                width: 35,
                height: 35,
                child: const SizedBox.shrink(),
              ),
            ],
          ),
          const Gap(14),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                    onPressed: () {
                      showPickProductBottomSheet(context);
                    },
                    child: const Text(
                      "Pilih Barang >",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(0xff40228C)),
                    )),
              ],
            ),
          ),
          const Text(
            "Rp 0",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Gap(4),
          IconButton(
              onPressed: () {
                controller.removeUnpickProduct();
              },
              icon: const Icon(
                size: 16,
                FontAwesomeIcons.trash,
                color: Color.fromARGB(255, 209, 66, 56),
              ))
        ],
      ),
    );
  }

  Future<dynamic> showPickProductBottomSheet(BuildContext context) {
    final ReceiptController controller = Get.find<ReceiptController>();
    return showMaterialModalBottomSheet(
      expand: false,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (context) => Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height - 65,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pilih Produk",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Obx(() => controller.isTopPanelLoading.value
                  ? LoadingAnimationWidget.prograssiveDots(
                      color: const Color(0xff40228C), size: 36)
                  : Row(
                      children: [
                        const Expanded(
                          child: ProductSearch(),
                        ),
                        const FilterMenuButton(),
                        const Gap(8),
                        OutlinedButton(
                            onPressed: () {
                              controller.resetQuery();
                            },
                            child: const Text("Reset")),
                      ],
                    )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: PagedMasonryGridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  pagingController: controller.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Product>(
                      itemBuilder: (context, item, index) {
                    return GestureDetector(
                      onTap: () {
                        controller.addProduct(item);
                        // Get.back();
                        controller.scrollToBottom();
                      },
                      child: ProductListCard(
                        item: item,
                      ),
                    );
                  }),
                ),
              ))
            ],
          ),
        ),
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
    final ReceiptController receiptController = Get.find<ReceiptController>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 40,
        child: Obx(() => TextField(
              controller: receiptController.searchInputController.value,
              onChanged: (value) {
                receiptController.searchInputController.refresh();
              },
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  labelText: 'Cari nama atau barcode',
                  suffixIcon: receiptController
                          .searchInputController.value.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            receiptController.searchInputController.value
                                .clear();
                            receiptController.searchInputController.refresh();
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
    final ReceiptController receiptController = Get.find<ReceiptController>();
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
              value: receiptController.selectedCategoryFilter.value,
              onChanged: (value) {
                receiptController.selectedCategoryFilter.value = value!;
                receiptController.pagingController.refresh();
              },
              isDense: true,
              isExpanded: false,
              items: receiptController.categoryFilterOptions.entries
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
