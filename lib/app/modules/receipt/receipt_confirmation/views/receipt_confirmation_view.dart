import 'package:action_slider/action_slider.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:choice/choice.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miva_pos_app/app/utils/currency_formatter.dart';
import 'package:miva_pos_app/app/utils/currency_validators.dart';
import 'package:miva_pos_app/app/widgets/miva_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../controllers/receipt_confirmation_controller.dart';

class ReceiptConfirmationView extends GetView<ReceiptConfirmationController> {
  const ReceiptConfirmationView({super.key});
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController1 = ScrollController();
    final ScrollController scrollController2 = ScrollController();
    final ScrollController scrollController3 = ScrollController();
    final screenHeight = MediaQuery.of(context).size.height;

    // Height of the keyboard or other view insets
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Available height after subtracting the keyboard height
    final availableHeight = screenHeight - keyboardHeight;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 50,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF40228C),
          title: const Text(
            'Konfirmasi Kasir',
            style: TextStyle(
                fontFamily: "Inter",
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body: Obx(
          () => controller.isPageLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: availableHeight - 50,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 35,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 16),
                                    child: ReceiptProductListSummaryCard(
                                        scrollController1: scrollController1,
                                        controller: controller),
                                  ),
                                ),
                                Expanded(
                                  flex: 65,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10, right: 16),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 30,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        "Diskon",
                                                        style: TextStyle(
                                                          fontFamily: "Inter",
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                        child: TextButton.icon(
                                                          style: TextButton
                                                              .styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        6),
                                                            alignment: Alignment
                                                                .center,
                                                          ),
                                                          label: const Text(
                                                              "Tambah"),
                                                          icon: const Icon(
                                                            FontAwesomeIcons
                                                                .plus,
                                                            size: 14,
                                                          ),
                                                          onPressed: () {
                                                            addDiscountBottomSheet(
                                                                context);
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Gap(6),
                                                  Expanded(
                                                    child: MivaCard.outline(
                                                      margin: EdgeInsets.zero,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: Obx(() => controller
                                                              .receiptDiscounts
                                                              .isEmpty
                                                          ? const Center(
                                                              child: Center(
                                                                child: Text(
                                                                    "Diskon masih kosong"),
                                                              ),
                                                            )
                                                          : RawScrollbar(
                                                              controller:
                                                                  scrollController2,
                                                              thickness: 5,
                                                              radius:
                                                                  const Radius
                                                                      .circular(
                                                                      12),
                                                              thumbColor:
                                                                  const Color(
                                                                      0xffD9D9D9),
                                                              thumbVisibility:
                                                                  true,
                                                              child: ListView
                                                                  .builder(
                                                                shrinkWrap:
                                                                    true,
                                                                controller:
                                                                    scrollController2,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        controller.receiptDiscounts[index]
                                                                            [
                                                                            "name"],
                                                                        style: const TextStyle(
                                                                            fontFamily:
                                                                                'Inter',
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(controller.receiptDiscounts[index]["amount"]),
                                                                            style: const TextStyle(
                                                                                fontFamily: 'Inter',
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                          const Gap(
                                                                              16),
                                                                          SizedBox(
                                                                            height:
                                                                                40,
                                                                            width:
                                                                                40,
                                                                            child: IconButton(
                                                                                onPressed: () {
                                                                                  controller.removeDiscount(index);
                                                                                },
                                                                                icon: const Icon(
                                                                                  size: 14,
                                                                                  FontAwesomeIcons.trash,
                                                                                  color: Color.fromARGB(255, 196, 43, 32),
                                                                                )),
                                                                          ),
                                                                          const Gap(
                                                                              16),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                                itemCount:
                                                                    controller
                                                                        .receiptDiscounts
                                                                        .length,
                                                              ),
                                                            )),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              const Gap(16),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        "Biaya Tambahan",
                                                        style: TextStyle(
                                                          fontFamily: "Inter",
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                        child: TextButton.icon(
                                                          style: TextButton
                                                              .styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        6),
                                                            alignment: Alignment
                                                                .center,
                                                          ),
                                                          label: const Text(
                                                              "Tambah"),
                                                          icon: const Icon(
                                                            FontAwesomeIcons
                                                                .plus,
                                                            size: 14,
                                                          ),
                                                          onPressed: () {
                                                            addAdditionalFeeBottomSheet(
                                                                context);
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Gap(6),
                                                  Expanded(
                                                    child: MivaCard.outline(
                                                      margin: EdgeInsets.zero,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: Obx(() => controller
                                                              .receiptAdditionalFees
                                                              .isEmpty
                                                          ? const Center(
                                                              child: Center(
                                                                child: Text(
                                                                    "Biaya Tambahan masih kosong"),
                                                              ),
                                                            )
                                                          : RawScrollbar(
                                                              controller:
                                                                  scrollController3,
                                                              thickness: 5,
                                                              radius:
                                                                  const Radius
                                                                      .circular(
                                                                      12),
                                                              thumbColor:
                                                                  const Color(
                                                                      0xffD9D9D9),
                                                              thumbVisibility:
                                                                  true,
                                                              child: ListView
                                                                  .builder(
                                                                shrinkWrap:
                                                                    true,
                                                                controller:
                                                                    scrollController3,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        controller.receiptAdditionalFees[index]
                                                                            [
                                                                            "name"],
                                                                        style: const TextStyle(
                                                                            fontFamily:
                                                                                'Inter',
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(controller.receiptAdditionalFees[index]["amount"]),
                                                                            style: const TextStyle(
                                                                                fontFamily: 'Inter',
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                          const Gap(
                                                                              16),
                                                                          SizedBox(
                                                                            height:
                                                                                40,
                                                                            width:
                                                                                40,
                                                                            child: IconButton(
                                                                                onPressed: () {
                                                                                  controller.removeAdditionalFee(index);
                                                                                },
                                                                                icon: const Icon(
                                                                                  size: 14,
                                                                                  FontAwesomeIcons.trash,
                                                                                  color: Color.fromARGB(255, 196, 43, 32),
                                                                                )),
                                                                          ),
                                                                          const Gap(
                                                                              16),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                                itemCount:
                                                                    controller
                                                                        .receiptAdditionalFees
                                                                        .length,
                                                              ),
                                                            )),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                        const Gap(70),
                                        Expanded(
                                          flex: 70,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Metode Pembayaran",
                                                    style: TextStyle(
                                                      fontFamily: "Inter",
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const Gap(6),
                                                  SizedBox(
                                                    width: 230,
                                                    height: 45,
                                                    child: Obx(() =>
                                                        DropdownButtonHideUnderline(
                                                          child:
                                                              DropdownButton2<
                                                                  String>(
                                                            buttonStyleData:
                                                                ButtonStyleData(
                                                                    height: 40,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            232,
                                                                            232,
                                                                            232),
                                                                        width:
                                                                            1, // Ketebalan border
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4.0), // Sudut border
                                                                    )),
                                                            dropdownStyleData:
                                                                const DropdownStyleData(
                                                              maxHeight: 450,
                                                            ),
                                                            value: controller
                                                                .selectedPaymentMethodId
                                                                .value,
                                                            onChanged: (value) {
                                                              controller
                                                                  .selectedPaymentMethodId
                                                                  .value = value!;
                                                              controller
                                                                  .selectedPaymentMethodName
                                                                  .value = controller
                                                                      .paymentMethodOptions[
                                                                  value]!;
                                                            },
                                                            isDense: true,
                                                            isExpanded: false,
                                                            items: controller
                                                                .paymentMethodOptions
                                                                .entries
                                                                .map((item) =>
                                                                    DropdownMenuItem(
                                                                      value: item
                                                                          .key,
                                                                      child:
                                                                          Text(
                                                                        item.value,
                                                                        style: const TextStyle(
                                                                            fontFamily:
                                                                                "Inter",
                                                                            fontSize:
                                                                                14),
                                                                      ),
                                                                    ))
                                                                .toList(),
                                                          ),
                                                        )),
                                                  ),
                                                  const Gap(16),
                                                  const Text(
                                                    "Jumlah Bayar",
                                                    style: TextStyle(
                                                      fontFamily: "Inter",
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const Gap(6),
                                                  SizedBox(
                                                    width: 230,
                                                    height: 45,
                                                    child: FormBuilder(
                                                      key: controller
                                                          .cashGivenFormKey,
                                                      child:
                                                          FormBuilderTextField(
                                                        name: 'cash_given',
                                                        onSubmitted: (value) {
                                                          if (value != null) {
                                                            controller
                                                                .receiptCashGiven
                                                                .value = int
                                                                    .tryParse(value
                                                                        .replaceAll(
                                                                            ".",
                                                                            "")) ??
                                                                0;
                                                          } else {
                                                            controller
                                                                .receiptCashGiven
                                                                .value = 0;
                                                          }

                                                          if ((int.tryParse(controller
                                                                      .cashGivenTextController
                                                                      .text
                                                                      .replaceAll(
                                                                          ".",
                                                                          "")) ??
                                                                  0) !=
                                                              controller
                                                                  .totalPrice
                                                                  .value) {
                                                            controller
                                                                .selectedCashChoice
                                                                .value = null;
                                                          }
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: [
                                                          CurrencyFormatter()
                                                        ],
                                                        controller: controller
                                                            .cashGivenTextController,
                                                        decoration:
                                                            InputDecoration(
                                                                prefixIcon: const Icon(
                                                                    FontAwesomeIcons
                                                                        .rupiahSign),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            232,
                                                                            232,
                                                                            232),
                                                                    width: 1,
                                                                  ),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            232,
                                                                            232,
                                                                            232),
                                                                    width: 1,
                                                                  ),
                                                                ),
                                                                isDense: true),
                                                      ),
                                                    ),
                                                  ),
                                                  const Gap(16),

                                                  Obx(() => InlineChoice<
                                                          int>.single(
                                                      clearable: false,
                                                      onChanged: (value) {
                                                        controller
                                                            .selectedCashChoice
                                                            .value = value ?? 0;
                                                        controller
                                                            .receiptCashGiven
                                                            .value = value ?? 0;
                                                        controller
                                                                .cashGivenTextController
                                                                .text =
                                                            NumberFormat
                                                                .currency(
                                                          locale: 'id',
                                                          symbol: '',
                                                          decimalDigits: 0,
                                                        ).format(value ?? 0);
                                                      },
                                                      value: controller
                                                          .selectedCashChoice
                                                          .value,
                                                      itemCount: controller
                                                          .cashChoices.length,
                                                      itemBuilder: (state, i) {
                                                        return ChoiceChip(
                                                          selected:
                                                              state.selected(
                                                            controller
                                                                .cashChoices[i],
                                                          ),
                                                          onSelected: state
                                                              .onSelected(controller
                                                                  .cashChoices[i]),
                                                          label: i == 0
                                                              ? Text(
                                                                  "PAS (${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(controller.cashChoices[i])})")
                                                              : Text(NumberFormat.currency(
                                                                      locale:
                                                                          'id',
                                                                      symbol:
                                                                          'Rp',
                                                                      decimalDigits:
                                                                          0)
                                                                  .format(controller
                                                                          .cashChoices[
                                                                      i])),
                                                        );
                                                      })),

                                                  // const Wrap(
                                                  //   spacing: 12,
                                                  //   children: [
                                                  //     ChoiceChip(
                                                  //       selected: false,
                                                  //       label: Text('Uang Pas'),
                                                  //       on
                                                  //     ),
                                                  //     ChoiceChip(
                                                  //       selected: true,
                                                  //       label: Text('Rp260.000'),
                                                  //     ),
                                                  //     ChoiceChip(
                                                  //       selected: false,
                                                  //       label: Text('Rp270.000'),
                                                  //     ),
                                                  //     ChoiceChip(
                                                  //       selected: false,
                                                  //       label: Text('Rp.300.000'),
                                                  //     ),
                                                  //   ],
                                                  // )
                                                ],
                                              )),
                                              const Gap(16),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Ringkasan Struk",
                                                        style: TextStyle(
                                                          fontFamily: "Inter",
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Gap(6),
                                                  Expanded(
                                                    child: MivaCard.outline(
                                                      margin: EdgeInsets.zero,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12,
                                                          vertical: 14),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                              child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const Text(
                                                                    "Subtotal Produk",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Inter",
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  Text(
                                                                    NumberFormat
                                                                        .currency(
                                                                      locale:
                                                                          'id',
                                                                      symbol:
                                                                          'Rp',
                                                                      decimalDigits:
                                                                          0,
                                                                    ).format(controller
                                                                        .totalPrice
                                                                        .value),
                                                                    style: const TextStyle(
                                                                        fontFamily:
                                                                            "Inter",
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ],
                                                              ),
                                                              const Gap(12),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const Text(
                                                                    "Biaya Tambahan",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Inter",
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  Text(
                                                                    "+ ${NumberFormat.currency(
                                                                      locale:
                                                                          'id',
                                                                      symbol:
                                                                          'Rp',
                                                                      decimalDigits:
                                                                          0,
                                                                    ).format(controller.totalAdditionalFeePrice.value)}",
                                                                    style: const TextStyle(
                                                                        fontFamily:
                                                                            "Inter",
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ],
                                                              ),
                                                              const Gap(12),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const Text(
                                                                    "Diskon",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Inter",
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  Text(
                                                                    "- ${NumberFormat.currency(
                                                                      locale:
                                                                          'id',
                                                                      symbol:
                                                                          'Rp',
                                                                      decimalDigits:
                                                                          0,
                                                                    ).format(controller.totalDiscountPrice.value)}",
                                                                    style: const TextStyle(
                                                                        fontFamily:
                                                                            "Inter",
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ],
                                                              ),
                                                              const Gap(12),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const Text(
                                                                    "Metode Pembayaran",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Inter",
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  Obx(
                                                                      () =>
                                                                          Text(
                                                                            controller.selectedPaymentMethodName.value,
                                                                            style: const TextStyle(
                                                                                fontFamily: "Inter",
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w700),
                                                                          )),
                                                                ],
                                                              )
                                                            ],
                                                          )),
                                                          const Divider(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      218,
                                                                      218,
                                                                      218)),
                                                          const Gap(8),
                                                          Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const Text(
                                                                    "Total Harga",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Inter",
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Color(
                                                                            0xff3B2387)),
                                                                  ),
                                                                  Text(
                                                                    NumberFormat
                                                                        .currency(
                                                                      locale:
                                                                          'id',
                                                                      symbol:
                                                                          'Rp',
                                                                      decimalDigits:
                                                                          0,
                                                                    ).format(controller
                                                                        .finalPrice
                                                                        .value),
                                                                    style: const TextStyle(
                                                                        fontFamily:
                                                                            "Inter",
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w800,
                                                                        color: Color(
                                                                            0xff3B2387)),
                                                                  ),
                                                                ],
                                                              ),
                                                              const Gap(12),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const Text(
                                                                    "Jumlah Bayar",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Inter",
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  Obx(
                                                                      () =>
                                                                          Text(
                                                                            NumberFormat.currency(
                                                                              locale: 'id',
                                                                              symbol: 'Rp',
                                                                              decimalDigits: 0,
                                                                            ).format(controller.receiptCashGiven.value),
                                                                            style: const TextStyle(
                                                                                fontFamily: "Inter",
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w800),
                                                                          )),
                                                                ],
                                                              ),
                                                              const Gap(12),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const Text(
                                                                    "Kembalian",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Inter",
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  Text(
                                                                    NumberFormat
                                                                        .currency(
                                                                      locale:
                                                                          'id',
                                                                      symbol:
                                                                          'Rp',
                                                                      decimalDigits:
                                                                          0,
                                                                    ).format(controller
                                                                        .cashChange
                                                                        .value),
                                                                    style: const TextStyle(
                                                                        fontFamily:
                                                                            "Inter",
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w800),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const Gap(16),
                                                  ActionSlider.standard(
                                                    icon: const Icon(
                                                      FontAwesomeIcons
                                                          .chevronRight,
                                                      color: Colors.white,
                                                    ),
                                                    loadingIcon:
                                                        const CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                    successIcon: const Icon(
                                                      FontAwesomeIcons.check,
                                                      color: Colors.white,
                                                    ),
                                                    failureIcon: const Icon(
                                                      FontAwesomeIcons
                                                          .triangleExclamation,
                                                      color: Colors.white,
                                                    ),
                                                    boxShadow: const [],
                                                    backgroundColor:
                                                        const Color(0xffF3F1FF),
                                                    toggleColor:
                                                        const Color(0xff3B2387),
                                                    sliderBehavior:
                                                        SliderBehavior.stretch,
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 26),
                                                      child: Text(
                                                        'Geser untuk Simpan Struk',
                                                        style: TextStyle(
                                                            fontFamily: "Inter",
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16,
                                                            color: Color(
                                                                0xff3B2387)),
                                                      ),
                                                    ),
                                                    action:
                                                        (slideController) async {
                                                      slideController
                                                          .loading(); //starts loading animation
                                                      final result =
                                                          await controller
                                                              .addReceipt();
                                                      if (result) {
                                                        slideController
                                                            .success();
                                                      } else {
                                                        slideController
                                                            .failure();
                                                        await Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    500));
                                                        slideController.reset();
                                                      }
                                                    },
                                                  )
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ));
  }

  Future<dynamic> addDiscountBottomSheet(BuildContext context) {
    final ReceiptConfirmationController controller =
        Get.find<ReceiptConfirmationController>();
    return showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        builder: (context) => SizedBox(
              height: 600,
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FormBuilder(
                    key: controller.discountFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tambah Diskon",
                          style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                        const Gap(16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Nama Diskon"),
                                const Gap(24),
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
                              ],
                            )),
                            const Gap(24),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Jumlah Diskon"),
                                    SizedBox(
                                      height: 30,
                                      child: ToggleSwitch(
                                        initialLabelIndex: 0,
                                        totalSwitches: 2,
                                        labels: const ['Rupiah', 'Persen'],
                                        onToggle: (index) {
                                          controller.discountModeOption.value =
                                              index ?? 0;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(12),
                                FormBuilderTextField(
                                  inputFormatters: [
                                    // CurrencyFormatter()
                                    CurrencyFormatter()
                                  ],
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    // FormBuilderValidators.range(1, 100,
                                    //     checkNullOrEmpty: true)
                                    // FormBuilderValidators.min(
                                    //     int.parse(controller
                                    //             .formKey
                                    //             .currentState
                                    //             ?.fields['sale_price']
                                    //             ?.value ??
                                    //         "0")),
                                  ]),
                                  keyboardType: TextInputType.number,
                                  name: 'amount',
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    prefixIcon:
                                        Icon(FontAwesomeIcons.rupiahSign),
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            )),
                            const Gap(24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Setelah Diskon"),
                                Text(
                                    "${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(controller.finalPrice.value)} - "
                                    "${controller.discountFormKey.currentState?.fields['amount']?.value ?? 0} = "
                                    "${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(controller.finalPrice.value - (int.tryParse(controller.discountFormKey.currentState?.fields['amount']?.value?.toString().replaceAll(".", "") ?? '0') ?? 0))}")
                              ],
                            ),
                            const Gap(24),
                          ],
                        ),
                        const Gap(16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color(0xff40228C)),
                            ),
                            onPressed: () {
                              controller.addDiscount();
                            },
                            child: const Text("Simpan"),
                          ),
                        )
                      ],
                    ),
                  )),
            ));
  }

  Future<dynamic> addAdditionalFeeBottomSheet(BuildContext context) {
    final ReceiptConfirmationController controller =
        Get.find<ReceiptConfirmationController>();
    return showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        builder: (context) => SizedBox(
              height: 600,
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FormBuilder(
                    key: controller.additionalFeeFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tambah Biaya Tambahan",
                          style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                        const Gap(16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Nama Biaya Tambahan"),
                                const Gap(24),
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
                              ],
                            )),
                            const Gap(24),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Jumlah Biaya Tambahan"),
                                const Gap(12),
                                FormBuilderTextField(
                                  inputFormatters: [
                                    // CurrencyFormatter()
                                    CurrencyFormatter()
                                  ],
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    // FormBuilderValidators.range(1, 100,
                                    //     checkNullOrEmpty: true)
                                    // FormBuilderValidators.min(
                                    //     int.parse(controller
                                    //             .formKey
                                    //             .currentState
                                    //             ?.fields['sale_price']
                                    //             ?.value ??
                                    //         "0")),
                                  ]),
                                  keyboardType: TextInputType.number,
                                  name: 'amount',
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    prefixIcon:
                                        Icon(FontAwesomeIcons.rupiahSign),
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            )),
                            const Gap(24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Setelah Biaya Tambahan"),
                                Text(
                                    "${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(controller.finalPrice.value)} + "
                                    "${controller.additionalFeeFormKey.currentState?.fields['amount']?.value ?? 0} = "
                                    "${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(controller.finalPrice.value + (int.tryParse(controller.additionalFeeFormKey.currentState?.fields['amount']?.value?.toString().replaceAll(".", "") ?? '0') ?? 0))}")
                              ],
                            ),
                            const Gap(24),
                          ],
                        ),
                        const Gap(16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color(0xff40228C)),
                            ),
                            onPressed: () {
                              controller.addAdditonalFee();
                            },
                            child: const Text("Simpan"),
                          ),
                        )
                      ],
                    ),
                  )),
            ));
  }
}

class ReceiptProductListSummaryCard extends StatelessWidget {
  const ReceiptProductListSummaryCard({
    super.key,
    required this.scrollController1,
    required this.controller,
  });

  final ScrollController scrollController1;
  final ReceiptConfirmationController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "List Barang",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(6),
        Expanded(
            child:
                ReceiptProductListCard(scrollController1: scrollController1)),
        const Gap(8),
        Row(
          children: [
            Expanded(
                child: MivaCard.filled(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Jumlah Item",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                  Obx(() => Text(
                        controller.totalQuantity.value.toString(),
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700),
                      ))
                ],
              ),
            )),
            const Gap(8),
            Expanded(
                child: MivaCard.filled(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Subtotal Harga",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                  Obx(() => Text(
                        NumberFormat.currency(
                                locale: 'id', symbol: 'Rp', decimalDigits: 0)
                            .format(controller.totalPrice.value),
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700),
                      ))
                ],
              ),
            )),
          ],
        ),
      ],
    );
  }
}

class ReceiptProductListCard extends StatelessWidget {
  const ReceiptProductListCard({
    super.key,
    required this.scrollController1,
  });

  final ScrollController scrollController1;

  @override
  Widget build(BuildContext context) {
    final ReceiptConfirmationController controller =
        Get.find<ReceiptConfirmationController>();
    return MivaCard.filled(
      margin: EdgeInsets.zero,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Obx(() => controller.receiptProducts.isEmpty
                      ? const Center(
                          child: Text("Produk masih kosong"),
                        )
                      : RawScrollbar(
                          controller: scrollController1,
                          thickness: 5,
                          radius: const Radius.circular(12),
                          thumbColor: const Color(0xffD9D9D9),
                          thumbVisibility: true,
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: scrollController1,
                            itemBuilder: (context, index) {
                              final receiptProduct =
                                  controller.receiptProducts[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      receiptProduct.name,
                                      style: const TextStyle(
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(receiptProduct.salePrice)} x${receiptProduct.receiptQuantity}",
                                          style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: Text(
                                              NumberFormat.currency(
                                                      locale: 'id',
                                                      symbol: 'Rp',
                                                      decimalDigits: 0)
                                                  .format(
                                                      receiptProduct.salePrice *
                                                          receiptProduct
                                                              .receiptQuantity),
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                            itemCount: controller.receiptProducts.length,
                          ),
                        ))),
              const Gap(8),
            ],
          ),
        ),
      ),
    );
  }
}
