import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:miva_pos_app/app/data/models/category.dart';
import 'package:miva_pos_app/app/modules/product_category/controllers/instant_add_category_controller.dart';
import 'package:miva_pos_app/app/utils/currency_formatter.dart';
import 'package:miva_pos_app/app/utils/currency_validators.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../controllers/product_form_controller.dart';

class ProductFormView extends GetView<ProductFormController> {
  const ProductFormView({super.key});

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
          title: Obx(() => Text(
                controller.isEdit.value ? "Edit Produk" : 'Tambah Produk',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              )),
          backgroundColor: const Color(0xFF40228C),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Obx(
          () => controller.isPageLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 120, vertical: 16),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: FormBuilder(
                            initialValue: controller.isEdit.value
                                ? controller.initialCurrentProductFormData!
                                : {"": ""},
                            key: controller.formKey,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Gambar Produk",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff333333),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Gap(10),
                                        Obx(() => !controller.isImagePick.value
                                            ? GestureDetector(
                                                onTap: () {
                                                  // controller.pickImage(
                                                  //     ImageSource.camera);
                                                  showPickImageBottomSheet(
                                                      context);
                                                },
                                                child: DottedBorder(
                                                  borderType: BorderType.RRect,
                                                  strokeWidth: 2,
                                                  dashPattern: const [12, 4],
                                                  radius:
                                                      const Radius.circular(12),
                                                  color:
                                                      const Color(0xff40228C),
                                                  child: const SizedBox(
                                                    width: 300,
                                                    height: 300,
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(FontAwesomeIcons
                                                              .image),
                                                          Text("Pilih Gambar")
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: SizedBox(
                                                        width: 300,
                                                        height: 300,
                                                        child: InstaImageViewer(
                                                          backgroundIsTransparent:
                                                              true,
                                                          child: Image(
                                                            image: controller
                                                                        .isEdit
                                                                        .value &&
                                                                    !controller
                                                                        .isImageChangeOnEdit
                                                                        .value
                                                                ? CachedNetworkImageProvider(
                                                                    controller
                                                                        .currentProduct!
                                                                        .imageUrl!)
                                                                : FileImage(
                                                                    controller
                                                                        .image!,
                                                                  ),
                                                            loadingBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
                                                                    ImageChunkEvent?
                                                                        loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              }
                                                              return Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  value: loadingProgress
                                                                              .expectedTotalBytes !=
                                                                          null
                                                                      ? loadingProgress
                                                                              .cumulativeBytesLoaded /
                                                                          loadingProgress
                                                                              .expectedTotalBytes!
                                                                      : null,
                                                                ),
                                                              );
                                                            },
                                                            fit: BoxFit
                                                                .fitHeight,
                                                          ),
                                                        ),
                                                      )),
                                                  const Gap(8),
                                                  TextButton.icon(
                                                    onPressed: () {
                                                      showPickImageBottomSheet(
                                                          context);
                                                    },
                                                    label: const Text(
                                                        "Ganti Gambar"),
                                                    icon: const Icon(
                                                        FontAwesomeIcons.image),
                                                  ),
                                                  const Gap(4),
                                                  TextButton.icon(
                                                    onPressed: () {
                                                      controller.removeImage();
                                                    },
                                                    label: const Text(
                                                        "Hapus Gambar"),
                                                    icon: const Icon(
                                                        FontAwesomeIcons
                                                            .trashCan),
                                                  )
                                                ],
                                              )),
                                      ],
                                    ),
                                    const Gap(100),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          FormBuilderTextField(
                                            validator:
                                                FormBuilderValidators.compose([
                                              FormBuilderValidators.minLength(4,
                                                  checkNullOrEmpty: true)
                                            ]),
                                            name: 'name',
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 10),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const Gap(10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Nomor Barcode"),
                                              const Gap(10),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    fit: FlexFit.loose,
                                                    child: FormBuilderTextField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      validator:
                                                          FormBuilderValidators
                                                              .compose([
                                                        FormBuilderValidators
                                                            .minLength(10,
                                                                checkNullOrEmpty:
                                                                    true,
                                                                errorText:
                                                                    "Min. 10 digit")
                                                      ]),
                                                      name: 'barcode_number',
                                                      decoration:
                                                          const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        10),
                                                        isDense: true,
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                  const Gap(8),
                                                  SizedBox(
                                                    width: 44,
                                                    height: 44,
                                                    child: FilledButton.icon(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              WidgetStateProperty.all<Color>(
                                                                  const Color(
                                                                      0xff40228C)),
                                                          padding: WidgetStateProperty.all(
                                                              EdgeInsets.zero),
                                                          alignment:
                                                              Alignment.center,
                                                          shape: WidgetStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          4)))),
                                                      onPressed: () async {
                                                        var res =
                                                            await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const SimpleBarcodeScannerPage(),
                                                                ));
                                                        if (res is String) {
                                                          if (res != '-1') {
                                                            controller
                                                                .formKey
                                                                .currentState
                                                                ?.fields[
                                                                    'barcode_number']!
                                                                .didChange(res);
                                                          }
                                                        }
                                                      },
                                                      label: const FaIcon(
                                                          FontAwesomeIcons
                                                              .expand),
                                                    ),
                                                  ),
                                                  const Gap(8),
                                                  SizedBox(
                                                    height: 44,
                                                    child: FilledButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                WidgetStateProperty.all<
                                                                        Color>(
                                                                    const Color(
                                                                        0xffF0DA4E)),
                                                            shape: WidgetStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4)))),
                                                        onPressed: () {
                                                          controller
                                                              .generateRandomBarcodeNumber();
                                                        },
                                                        child: controller
                                                                .isProcessLoading
                                                                .value
                                                            ? const CircularProgressIndicator()
                                                            : const Text(
                                                                "Generate",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color(
                                                                        0xff333333)),
                                                              )),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Gap(10),
                                          const Text("Kategori"),
                                          const Gap(10),
                                          FormBuilderTextField(
                                            validator:
                                                FormBuilderValidators.compose([
                                              FormBuilderValidators.required()
                                            ]),
                                            readOnly: true,
                                            onTapOutside: (event) {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            onTap: () {
                                              showMaterialModalBottomSheet(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        12))),
                                                context: context,
                                                builder: (context) =>
                                                    const PickCategoryBottomSheet(),
                                              );
                                            },
                                            decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 10),
                                                hintText: "Pilih Kategori",
                                                hintStyle:
                                                    TextStyle(fontSize: 14),
                                                isDense: true,
                                                border: OutlineInputBorder(),
                                                suffixIcon: Icon(
                                                  Icons.arrow_drop_down_rounded,
                                                  size: 28,
                                                )),
                                            name: 'category_name',
                                          ),
                                          const Gap(10),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("Satuan"),
                                                    const Gap(10),
                                                    FormBuilderTextField(
                                                      validator:
                                                          FormBuilderValidators
                                                              .compose([
                                                        FormBuilderValidators
                                                            .minLength(1,
                                                                checkNullOrEmpty:
                                                                    true,
                                                                errorText:
                                                                    "Min. 1 huruf")
                                                      ]),
                                                      name: 'unit',
                                                      decoration:
                                                          const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        10),
                                                        isDense: true,
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Gap(12),
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("Stok"),
                                                    const Gap(10),
                                                    Obx(() =>
                                                        FormBuilderTextField(
                                                          validator: controller
                                                                  .withStock
                                                                  .value
                                                              ? FormBuilderValidators
                                                                  .compose([
                                                                  FormBuilderValidators.min(
                                                                      0,
                                                                      checkNullOrEmpty:
                                                                          true,
                                                                      errorText:
                                                                          "Minimal 0")
                                                                ])
                                                              : FormBuilderValidators
                                                                  .compose([]),
                                                          enabled: controller
                                                              .withStock.value,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          name: 'stock',
                                                          decoration:
                                                              const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            10),
                                                            isDense: true,
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              const Gap(8),
                                              Obx(() => Column(
                                                    children: [
                                                      const Gap(16),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(controller
                                                                  .withStock
                                                                  .value
                                                              ? "Dengan Stok"
                                                              : "Tanpa Stok"),
                                                          const Gap(4),
                                                          Switch(
                                                            // This bool value toggles the switch.
                                                            value: controller
                                                                .withStock
                                                                .value,
                                                            activeColor:
                                                                const Color(
                                                                    0xff40228C),
                                                            onChanged:
                                                                (bool value) {
                                                              // This is called when the user toggles the switch.
                                                              controller
                                                                  .setWithStock(
                                                                      value);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ))
                                            ],
                                          ),
                                          const Gap(10),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("Harga Pokok"),
                                                    const Gap(10),
                                                    FormBuilderTextField(
                                                      inputFormatters: [
                                                        CurrencyFormatter()
                                                      ],
                                                      validator:
                                                          FormBuilderValidators
                                                              .compose([
                                                        FormBuilderValidators
                                                            .required(),
                                                        (val) => currrencyMaxValidator(
                                                            value: val ?? "0",
                                                            max: controller
                                                                    .formKey
                                                                    .currentState
                                                                    ?.fields[
                                                                        'sale_price']
                                                                    ?.value ??
                                                                "0")

                                                        // (val) => currrencyMinValidator(
                                                        //     val ?? ''),
                                                        // (val) => currrencyMaxValidator(
                                                        //     val ?? '',
                                                        //     int.parse(controller
                                                        //             .formKey
                                                        //             .currentState
                                                        //             ?.fields['sale_price']
                                                        //             ?.value
                                                        //             ?.replaceAll(
                                                        //                 '.', '') ??
                                                        //         "0")),
                                                      ]),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      name: 'cost_price',
                                                      decoration:
                                                          const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        10),
                                                        prefixIcon: Icon(
                                                            FontAwesomeIcons
                                                                .rupiahSign),
                                                        isDense: true,
                                                        border:
                                                            OutlineInputBorder(),
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
                                                    FormBuilderTextField(
                                                      inputFormatters: [
                                                        // CurrencyFormatter()
                                                        CurrencyFormatter()
                                                      ],
                                                      validator:
                                                          FormBuilderValidators
                                                              .compose([
                                                        FormBuilderValidators
                                                            .required(),
                                                        (val) => currrencyMinValidator(
                                                            value: val ?? "0",
                                                            min: controller
                                                                    .formKey
                                                                    .currentState
                                                                    ?.fields[
                                                                        'cost_price']
                                                                    ?.value ??
                                                                "0")
                                                        // FormBuilderValidators.min(
                                                        //     int.parse(controller
                                                        //             .formKey
                                                        //             .currentState
                                                        //             ?.fields['sale_price']
                                                        //             ?.value ??
                                                        //         "0")),
                                                      ]),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      name: 'sale_price',
                                                      decoration:
                                                          const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        10),
                                                        prefixIcon: Icon(
                                                            FontAwesomeIcons
                                                                .rupiahSign),
                                                        isDense: true,
                                                        border:
                                                            OutlineInputBorder(),
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
                      ),
                      const Gap(12),
                      Obx(() => SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    const Color(0xff40228C)),
                              ),
                              onPressed: () {
                                // Aksi ketika tombol ditekan
                                controller.submitProductForm();
                              },
                              child: controller.isProcessLoading.value
                                  ? const CircularProgressIndicator()
                                  : const Text("Simpan"),
                            ),
                          )),
                    ],
                  ),
                ),
        ));
  }

  void showPickImageBottomSheet(BuildContext context) {
    showMaterialModalBottomSheet(
        expand: false,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        builder: (context) => SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(8),
                  ListTile(
                    title: const Text("Ambil Kamera"),
                    leading: const Icon(FontAwesomeIcons.camera),
                    onTap: () async {
                      await controller.pickImage(ImageSource.camera);
                      Get.back();
                    },
                  ),
                  ListTile(
                    title: const Text("Ambil dari Galeri"),
                    leading: const Icon(FontAwesomeIcons.solidImages),
                    onTap: () async {
                      await controller.pickImage(ImageSource.gallery);
                      Get.back();
                    },
                  ),
                ],
              ),
            ));
  }
}

class PickCategoryBottomSheet extends StatelessWidget {
  const PickCategoryBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ProductFormController controller = Get.find<ProductFormController>();
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
                            builder: (context) =>
                                const InstantAddCategoryBottomSheet());
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
                child: PagedMasonryGridView.count(
              padding: const EdgeInsets.only(top: 8),
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              pagingController: controller.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Category>(
                  itemBuilder: (context, item, index) {
                return InkWell(
                  onTap: () {
                    controller.setSelectedCategoryId(
                        id: item.id, name: item.name);
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(item.name),
                    ),
                  ),
                );
              }),
            ))
          ],
        ),
      ),
    );
  }
}

class InstantAddCategoryBottomSheet extends StatelessWidget {
  const InstantAddCategoryBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final InstantAddCategoryController controller =
        Get.find<InstantAddCategoryController>();
    return SizedBox(
      height: 580,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Tambah Kategori"),
              const Gap(24),
              const Text("Nama Kategori"),
              const Gap(12),
              FormBuilderTextField(
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.minLength(4, checkNullOrEmpty: true)
                ]),
                name: 'name',
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(12),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xff40228C)),
                      ),
                      onPressed: () async {
                        // Aksi ketika tombol ditekan
                        bool success = await controller.addCategory();
                        if (success) {
                          AwesomeDialog(
                            context: Get.context!,
                            dialogType: DialogType.success,
                            animType: AnimType.bottomSlide,
                            title: 'Sukses!',
                            desc: "Kategori berhasil ditambahkan!",
                            btnOkOnPress: () {
                              final ProductFormController
                                  categoryListController =
                                  Get.find<ProductFormController>();
                              categoryListController.pagingController.refresh();
                              Get.back();
                            },
                          ).show();
                        }
                      },
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : const Text("Simpan"),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
