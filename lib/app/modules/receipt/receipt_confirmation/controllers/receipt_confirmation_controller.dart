import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miva_pos_app/app/data/models/payment_method.dart';
import 'package:miva_pos_app/app/data/models/product.dart';
import 'package:miva_pos_app/app/data/models/receipt.dart';
import 'package:miva_pos_app/app/data/models/receipt_additional_fee.dart';
import 'package:miva_pos_app/app/data/models/receipt_discount.dart';
import 'package:miva_pos_app/app/data/models/receipt_product.dart';
import 'package:miva_pos_app/app/data/repositories/payment_method_repository.dart';
import 'package:miva_pos_app/app/data/repositories/receipt_repository.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';
import 'package:miva_pos_app/app/modules/receipt/controllers/receipt_controller.dart';
import 'package:miva_pos_app/app/routes/app_pages.dart';

class ReceiptConfirmationController extends GetxController {
  final PaymentMethodRepository paymentMethodRepository;
  final ReceiptRepository receiptRepository;

  ReceiptConfirmationController(
      {required this.paymentMethodRepository, required this.receiptRepository});

  Map<String, String> paymentMethodOptions = {};

  RxList<Product> receiptProducts = <Product>[].obs;

  Rx<int> get totalPrice => Rx<int>(receiptProducts.fold<int>(0,
      (sum, product) => sum + (product.salePrice * product.receiptQuantity)));

  Rx<int> get totalQuantity => Rx<int>(receiptProducts.fold<int>(
      0, (sum, product) => sum + product.receiptQuantity));

  RxList<int> cashChoices = <int>[].obs;

  Rxn<int> selectedCashChoice = Rxn<int>();

  RxList<Map<String, dynamic>> receiptDiscounts = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> receiptAdditionalFees =
      <Map<String, dynamic>>[].obs;

  TextEditingController cashGivenTextController = TextEditingController();

  RxBool isPageLoading = false.obs;
  RxBool isProcessLoading = false.obs;

  RxInt receiptCashGiven = 0.obs;

  /// 0 is Rupiah, 1 is Percent
  RxInt discountModeOption = 0.obs;

  RxString selectedPaymentMethodId = "".obs;
  RxString selectedPaymentMethodName = "".obs;

  final discountFormKey = GlobalKey<FormBuilderState>();
  final additionalFeeFormKey = GlobalKey<FormBuilderState>();
  final cashGivenFormKey = GlobalKey<FormBuilderState>();

  Rx<int> get totalDiscountPrice => (receiptDiscounts
          .fold(0, (sum, discount) => sum + (discount["amount"] as int))
          .toInt())
      .obs;

  Rx<int> get totalAdditionalFeePrice => (receiptAdditionalFees
          .fold(0, (sum, additonalFee) => sum + (additonalFee["amount"] as int))
          .toInt())
      .obs;

  Rx<int> get finalPrice => (totalPrice.value +
          totalAdditionalFeePrice.value -
          totalDiscountPrice.value)
      .obs;

  Rx<int> get cashChange => (receiptCashGiven.value - finalPrice.value).obs;

  @override
  void onInit() async {
    super.onInit();
    isPageLoading.value = true;

    await getAllPaymentMethod();

    receiptProducts.value = Get.arguments!['receiptProducts'];

    generateCashSuggestions();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setDefaultCashGiven();
    });

    isPageLoading.value = false;
  }

  void generateCashSuggestions() {
    cashChoices.clear();
    cashChoices.add(finalPrice.value);
    List<int> denominations = [1000, 2000, 5000, 10000, 20000, 50000, 100000];
    int remaining = finalPrice.value;
    Set<int> suggestions = {};

    // Generate suggestions
    for (int denomination in denominations.reversed) {
      int suggestedAmount = ((remaining / denomination).ceil()) * denomination;
      if (suggestedAmount > finalPrice.value) {
        suggestions.add(suggestedAmount);
      }
    }

    // Convert set to list and sort
    List<int> sortedSuggestions = suggestions.toList()..sort();

    // Limit the suggestions to a maximum of 5
    List<int> limitedSuggestions = [];
    for (int i = 0; i < sortedSuggestions.length && i < 5; i++) {
      limitedSuggestions.add(sortedSuggestions[i]);
    }

    // Add suggestions to cashChoices
    cashChoices.addAll(limitedSuggestions);
    cashChoices.refresh();
  }

  void changeCashChoice(int? value) {
    // selectedCashChoice.value = value ?? 0;
    receiptCashGiven.value = value ?? 0;
    cashGivenTextController.text = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: 0,
    ).format(value ?? 0);
  }

  void addDiscount() {
    if (!(discountFormKey.currentState?.saveAndValidate() ?? false)) {
      return;
    }
    Map<String, dynamic> discountData = discountFormKey.currentState!.value;
    receiptDiscounts.add({
      "name": discountData["name"],
      "amount": int.tryParse(
          discountData["amount"].toString().replaceAll(".", "") ?? "0")
    });
    generateCashSuggestions();
    setDefaultCashGiven();
    Get.back();
  }

  void removeDiscount(index) {
    receiptDiscounts.removeAt(index);
    generateCashSuggestions();
    setDefaultCashGiven();
  }

  void addAdditonalFee() {
    if (!(additionalFeeFormKey.currentState?.saveAndValidate() ?? false)) {
      return;
    }
    Map<String, dynamic> additionalFeeData =
        additionalFeeFormKey.currentState!.value;
    receiptAdditionalFees.add({
      "name": additionalFeeData["name"],
      "amount": int.tryParse(
          additionalFeeData["amount"].toString().replaceAll(".", "") ?? "0")
    });
    generateCashSuggestions();
    setDefaultCashGiven();
    Get.back();
  }

  void removeAdditionalFee(index) {
    receiptAdditionalFees.removeAt(index);
    generateCashSuggestions();
    setDefaultCashGiven();
  }

  void setDefaultCashGiven() {
    selectedCashChoice.value = finalPrice.value;
    receiptCashGiven.value = finalPrice.value;
    cashGivenTextController.text = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: 0,
    ).format(int.tryParse(finalPrice.value.toString()) ?? 0);
  }

  Future<void> getAllPaymentMethod() async {
    try {
      final HomeController homeController = Get.find<HomeController>();
      List<PaymentMethod> paymentMethodList =
          await paymentMethodRepository.getAllPaymentMethods(
        businessId: homeController.loggedInBusiness.id,
      );
      paymentMethodOptions
          .addAll({for (var item in paymentMethodList) item.id: item.name});
      selectedPaymentMethodId.value = paymentMethodList
          .firstWhere((paymentMethod) => paymentMethod.name == "CASH")
          .id;
      selectedPaymentMethodName.value = "CASH";
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<bool> addReceipt() async {
    isProcessLoading.value = true;
    try {
      final HomeController homeController = Get.find<HomeController>();
      if (!isCashGivenValid()) {
        return false;
      }
      String receiptNumber = await generateReceiptNumber();
      int finalTotalProfit = calculateTotalProfit();

      Receipt receiptData = Receipt(
          id: "",
          totalDiscountPrice: totalDiscountPrice.value,
          totalAdditionalFeePrice: totalAdditionalFeePrice.value,
          businessId: homeController.loggedInBusiness.id,
          userId: homeController.loggedInUser.id,
          paymentMethodId: selectedPaymentMethodId.value,
          receiptNumber: receiptNumber,
          totalProductPrice: totalPrice.value,
          totalBill: finalPrice.value,
          totalItem: totalQuantity.value,
          cashGiven:
              int.parse(cashGivenTextController.text.replaceAll(".", "")),
          cashChange: cashChange.value,
          totalProfit: finalTotalProfit,
          createdAt: DateTime.now(),
          firstProductName: "",
          productsCount: 0);
      List<ReceiptProduct> receiptProductList = mapReceiptProducts();
      List<ReceiptDiscount> receiptDiscountList = mapReceiptDiscounts();
      List<ReceiptAdditionalFee> receiptAdditionalFeeList =
          mapReceiptAdditionalFees();

      Receipt storedReceipt = await receiptRepository.createReceipt(
          businessId: homeController.loggedInBusiness.id,
          userId: homeController.loggedInUser.id,
          receipt: receiptData,
          receiptAdditionalFees: receiptAdditionalFeeList,
          receiptProducts: receiptProductList,
          receiptDiscounts: receiptDiscountList);

      final ReceiptController receiptController = Get.find<ReceiptController>();
      receiptController.receiptProducts.clear();

      Get.offNamed(Routes.RECEIPT_SUCCESS, arguments: {
        "receipt": storedReceipt,
        "receiptProducts": receiptProductList,
        "receiptAdditionalFees": receiptAdditionalFeeList,
        "receiptDiscounts": receiptDiscountList,
        "receiptPaymentMethodName": selectedPaymentMethodName.value
      });
      // AwesomeDialog(
      //   context: Get.context!,
      //   dialogType: DialogType.success,
      //   animType: AnimType.bottomSlide,
      //   title: 'Sukses',
      //   desc:
      //       "Struk dengan nomor ${storedReceipt.receiptNumber} berhasil di simpan",
      //   btnOkOnPress: () {
      //     Get.back();
      //   },
      // ).show();
      isProcessLoading.value = false;
      return true;
    } catch (e) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Sorryyyy',
        desc: e.toString(),
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
      isProcessLoading.value = false;
      return false;
    }
  }

  bool isCashGivenValid() {
    return cashGivenFormKey.currentState?.saveAndValidate() ?? false;
  }

  Future<String> generateReceiptNumber() async {
    final HomeController homeController = Get.find<HomeController>();
    String randomReceiptNumber = "";
    int receiptFoundCount = 1;

    do {
      DateTime now = DateTime.now();
      String formattedNowDate = DateFormat('yyMMdd').format(now);
      Random random = Random();
      int randomNumber = random.nextInt(900) + 100;

      randomReceiptNumber = "$randomNumber/$formattedNowDate";

      receiptFoundCount =
          await receiptRepository.getCountReceiptByReceiptNumber(
              businessId: homeController.loggedInBusiness.id,
              receiptNumber: randomReceiptNumber);
    } while (receiptFoundCount > 0);
    return randomReceiptNumber;
  }

  int calculateTotalProfit() {
    int rawTotalProfit = receiptProducts.fold<int>(
        0, (sum, product) => sum + (product.salePrice - product.costPrice));
    return rawTotalProfit - totalDiscountPrice.value;
  }

  List<ReceiptProduct> mapReceiptProducts() {
    return receiptProducts
        .map((element) => ReceiptProduct(
            id: "",
            receiptId: "",
            productId: element.id,
            productCostPrice: element.costPrice,
            productSalePrice: element.salePrice,
            quantity: element.receiptQuantity,
            createdAt: DateTime.now(),
            productName: element.name,
            businessId: ""))
        .toList();
  }

  List<ReceiptDiscount> mapReceiptDiscounts() {
    return receiptDiscounts
        .map((element) => ReceiptDiscount(
            id: "",
            receiptId: "",
            name: element["name"],
            amount: element["amount"],
            createdAt: DateTime.now(),
            businessId: ""))
        .toList();
  }

  List<ReceiptAdditionalFee> mapReceiptAdditionalFees() {
    return receiptAdditionalFees
        .map((element) => ReceiptAdditionalFee(
            id: "",
            receiptId: "",
            name: element["name"],
            amount: element["amount"],
            createdAt: DateTime.now(),
            businessId: ""))
        .toList();
  }
}
