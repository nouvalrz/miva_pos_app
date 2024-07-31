import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/category_form_controller.dart';

class CategoryFormView extends GetView<CategoryFormController> {
  const CategoryFormView({super.key});
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
                controller.isEdit.value ? 'Edit Kategori' : 'Tambah Kategori',
                style: const TextStyle(
                    fontFamily: "Inter", color: Colors.white, fontSize: 18),
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
                      const EdgeInsets.symmetric(horizontal: 240, vertical: 16),
                  child: Column(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        child: FormBuilder(
                          initialValue: controller.isEdit.value
                              ? controller.initialCurrentCategoryFormData!
                              : {"": ""},
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Informasi Kategori",
                                style: TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 16,
                                    color: Color(0xff333333),
                                    fontWeight: FontWeight.w600),
                              ),
                              const Gap(24),
                              const Text("Nama Kategori"),
                              const Gap(10),
                              FormBuilderTextField(
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.minLength(4,
                                      checkNullOrEmpty: true)
                                ]),
                                name: 'name',
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const Gap(42),
                              Obx(() => SizedBox(
                                    width: double.infinity,
                                    child: FilledButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                const Color(0xff40228C)),
                                      ),
                                      onPressed: () {
                                        // Aksi ketika tombol ditekan
                                        controller.submitCategory();
                                      },
                                      child: controller.isLoading.value
                                          ? const CircularProgressIndicator()
                                          : const Text("Simpan"),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
        ));
  }
}
