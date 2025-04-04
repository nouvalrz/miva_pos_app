import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:miva_pos_app/app/data/models/receipt.dart';
import 'package:miva_pos_app/app/data/repositories/receipt_repository.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';

class HistoryController extends GetxController {
  //TODO: Implement HistoryController

  ReceiptRepository receiptRepository;

  HistoryController({required this.receiptRepository});

  Rx<TextEditingController> searchInputController = TextEditingController().obs;

  final List<String> sortOptions = [
    "Terbaru",
    "Terlama",
    "Terbesar",
    "Terkecil"
  ];

  Map<String, String> sortOptions2 = {
    ReceiptRepository.ORDER_BY_DATE_DESC: "Terbaru",
    ReceiptRepository.ORDER_BY_DATE_ASC: "Terlama",
    ReceiptRepository.ORDER_BY_TOTAL_BILL_DESC: "Terbesar",
    ReceiptRepository.ORDER_BY_TOTAL_BILL_ASC: "Terkecil"
  };

  var endDateRange = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 23, 59, 59)
      .obs;
  var startDateRange = DateTime.now()
      .subtract(const Duration(days: 7))
      .copyWith(hour: 0, minute: 0, second: 0)
      .obs;

  var selectedOption = ReceiptRepository.ORDER_BY_DATE_DESC.obs;

  var receiptCount = 0.obs;
  var totalReceiptBill = 0.obs;
  var totalReceiptProfit = 0.obs;

  var dateChange = false;

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      getAllReceipt(pageKey);
    });
    searchInputController.value.addListener(() {
      pagingController.refresh();
    });
    updateReceiptSummary();
  }

  final PagingController<int, Receipt> pagingController =
      PagingController(firstPageKey: 0);

  final pageSize = 12;

  void setSelectedOption(String value) {
    selectedOption.value = value;
  }

  Future<void> getAllReceipt(pageKey) async {
    try {
      final HomeController homeController = Get.find<HomeController>();
      List<Receipt> productList =
          await receiptRepository.getAllReceiptFromDateRange(
              businessId: homeController.loggedInBusiness.id,
              limit: pageSize,
              offset: pageKey,
              searchKeyword: searchInputController.value.text,
              startDate: startDateRange.value,
              endDate: endDateRange.value,
              orderQuery: selectedOption.value);
      final isLastPage = productList.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(productList);
      } else {
        final nextPageKey = pageKey + productList.length;
        pagingController.appendPage(productList, nextPageKey);
      }
    } catch (e) {
      pagingController.error = e;
      Get.snackbar("Error", e.toString());
    }
  }

  void changeDate() {
    pagingController.refresh();
    updateReceiptSummary();
  }

  Future<void> updateReceiptSummary() async {
    final HomeController homeController = Get.find<HomeController>();
    receiptCount.value = await receiptRepository.getReceiptCountFromDateRange(
        businessId: homeController.loggedInBusiness.id,
        startDate: startDateRange.value,
        endDate: endDateRange.value);
    totalReceiptBill.value =
        await receiptRepository.getTotalReceiptBillFromDateRange(
            businessId: homeController.loggedInBusiness.id,
            startDate: startDateRange.value,
            endDate: endDateRange.value);
    totalReceiptProfit.value =
        await receiptRepository.getTotalReceiptProfitFromDateRange(
            businessId: homeController.loggedInBusiness.id,
            startDate: startDateRange.value,
            endDate: endDateRange.value);
  }

  // void updateReceiptSummary() {
  //   if (pagingController.itemList == null) {
  //     return;
  //   }
  //   final receiptList = pagingController.itemList!;

  //   receiptCount.value = receiptList.length;

  //   totalReceiptBill.value = receiptList.fold(0, (sum, receipt) {
  //     return sum + receipt.totalBill;
  //   });

  //   totalReceiptProfit.value = receiptList.fold(0, (sum, receipt) {
  //     return sum + receipt.totalProfit;
  //   });
  // }
}
