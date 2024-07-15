import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:miva_pos_app/app/data/models/category.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        title: const Text(
          'Tambah Produk',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF40228C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Gambar Produk",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff333333),
                                  fontWeight: FontWeight.w600),
                            ),
                            const Gap(10),
                            DottedBorder(
                              borderType: BorderType.RRect,
                              strokeWidth: 2,
                              dashPattern: const [12, 4],
                              radius: const Radius.circular(12),
                              color: const Color(0xff40228C),
                              child: const SizedBox(
                                width: 300,
                                height: 300,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(FontAwesomeIcons.image),
                                      Text("Pilih Gambar")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(100),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Informasi Produk",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff333333),
                                    fontWeight: FontWeight.w600),
                              ),
                              const Gap(10),
                              const Text("Nama Produk"),
                              const Gap(10),
                              SizedBox(
                                height: 45,
                                child: FormBuilderTextField(
                                  name: 'name',
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const Gap(10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Nomor Barcode"),
                                        const Gap(10),
                                        SizedBox(
                                          height: 45,
                                          child: FormBuilderTextField(
                                            keyboardType: TextInputType.number,
                                            name: 'barcode_number',
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(8),
                                  SizedBox(
                                    width: 45,
                                    height: 45,
                                    child: FilledButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  const Color(0xff40228C)),
                                          padding: WidgetStateProperty.all(
                                              EdgeInsets.zero),
                                          alignment: Alignment.center,
                                          shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4)))),
                                      onPressed: () {},
                                      label:
                                          const FaIcon(FontAwesomeIcons.expand),
                                    ),
                                  ),
                                  const Gap(8),
                                  SizedBox(
                                    height: 45,
                                    child: FilledButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all<Color>(
                                                    const Color(0xffF0DA4E)),
                                            shape: WidgetStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)))),
                                        onPressed: () {},
                                        child: const Text(
                                          "Generate",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff333333)),
                                        )),
                                  ),
                                ],
                              ),
                              const Gap(10),
                              const Text("Kategori"),
                              const Gap(10),
                              SizedBox(
                                height: 45,
                                child: GestureDetector(
                                  onTap: () {
                                    showMaterialModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(12))),
                                      context: context,
                                      builder: (context) =>
                                          const PickCategoryBottomSheet(),
                                    );
                                  },
                                  child: FormBuilderDropdown(
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    items: const [],
                                    name: 'category_id',
                                  ),
                                ),
                              ),
                              const Gap(10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Stok"),
                                        const Gap(10),
                                        SizedBox(
                                          height: 45,
                                          child: Obx(() => FormBuilderTextField(
                                                enabled:
                                                    controller.withStock.value,
                                                keyboardType:
                                                    TextInputType.number,
                                                name: 'stock',
                                                decoration:
                                                    const InputDecoration(
                                                  isDense: true,
                                                  border: OutlineInputBorder(),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(8),
                                  Obx(() => Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(controller.withStock.value
                                              ? "Dengan Stok"
                                              : "Tanpa Stok"),
                                          const Gap(4),
                                          Switch(
                                            // This bool value toggles the switch.
                                            value: controller.withStock.value,
                                            activeColor:
                                                const Color(0xff40228C),
                                            onChanged: (bool value) {
                                              // This is called when the user toggles the switch.
                                              controller.setWithStock(value);
                                            },
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                              const Gap(10),
                              Row(
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Harga Pokok"),
                                        const Gap(10),
                                        SizedBox(
                                          height: 45,
                                          child: FormBuilderTextField(
                                            keyboardType: TextInputType.number,
                                            name: 'cost_price',
                                            decoration: const InputDecoration(
                                              prefixIcon: Icon(
                                                  FontAwesomeIcons.rupiahSign),
                                              isDense: true,
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(10),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Harga Jual"),
                                        const Gap(10),
                                        SizedBox(
                                          height: 45,
                                          child: FormBuilderTextField(
                                            keyboardType: TextInputType.number,
                                            name: 'sale_price',
                                            decoration: const InputDecoration(
                                              prefixIcon: Icon(
                                                  FontAwesomeIcons.rupiahSign),
                                              isDense: true,
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Gap(12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(const Color(0xff40228C)),
                ),
                onPressed: () {
                  // Aksi ketika tombol ditekan
                },
                child: const Text("Simpan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PickCategoryBottomSheet extends StatelessWidget {
  const PickCategoryBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AddProductController controller = Get.find<AddProductController>();
    return SizedBox(
      height: 620,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pilih Kategori"),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: controller.categorySearchController.value,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            labelText: 'Cari nama kategori',
                            labelStyle: TextStyle(fontSize: 14)),
                      )),
                ),
                const Gap(12),
                SizedBox(
                  height: 40,
                  child: FilledButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xffF0DA4E)),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)))),
                      onPressed: () {
                        showMaterialModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12))),
                            builder: (context) => const SizedBox(
                                  height: 580,
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Tambah Kategori"),
                                        Gap(12),
                                        SizedBox(
                                          height: 45,
                                          child: TextField(
                                            decoration: InputDecoration(
                                                isDense: true,
                                                border: OutlineInputBorder()),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                      },
                      child: const Text(
                        "Tambah",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff333333)),
                      )),
                )
              ],
            ),
            Expanded(
                child: RefreshIndicator(
              onRefresh: () async {
                controller.pagingController.refresh();
              },
              child: PagedMasonryGridView.count(
                padding: const EdgeInsets.only(top: 8),
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                pagingController: controller.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Category>(
                    itemBuilder: (context, item, index) {
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                    ),
                  );
                }),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
