import 'dart:async';

import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/models/expense.dart';
import 'package:miva_pos_app/app/data/models/receipt.dart';
import 'package:miva_pos_app/app/data/repositories/transaction_repository.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';

class DashboardController extends GetxController {
  final TransactionRepository transactionRepository;
  final transactions = <dynamic>[].obs;
  late StreamSubscription<List<dynamic>> _transactionSubscription;
  RxBool isDashboardShowAll = true.obs;
  RxBool isLoading = false.obs;
  final HomeController homeController;

  /// Jumlah receipt
  RxInt todayReceiptsCount = 0.obs;

  /// Jumlah pengeluaran
  RxInt todayExpensesCount = 0.obs;

  /// Jumlah pemasukkan kotor
  RxInt todayIncomeTotal = 0.obs;

  /// Jumlah pengeluaran
  RxInt todayExpenseTotal = 0.obs;

  /// Jumlah profit dari semua receipt
  RxInt todayGrossProfitTotal = 0.obs;

  /// Jumlah profit dari semua receipt, lalu dikurangi pengeluaran
  RxInt todayNetProfitTotal = 0.obs;

  DashboardController(
      {required this.transactionRepository, required this.homeController});

  @override
  void onInit() {
    super.onInit();
    _transactionSubscription = transactionRepository
        .watchTodayTransactions(homeController.loggedInBusiness.id)
        .listen((data) {
      transactions.assignAll(data);
      var todayReceiptsCount = 0;
      var todayExpensesCount = 0;
      var todayExpenseTotal = 0;
      var todayIncomeTotal = 0;
      var todayGrossProfitTotal = 0;
      var todayNetProfitTotal = 0;
      for (var item in transactions) {
        if (item is Receipt) {
          todayReceiptsCount++;
          todayIncomeTotal += item.totalBill;
          todayGrossProfitTotal += item.totalProfit;
        } else if (item is Expense) {
          todayExpensesCount++;
          todayExpenseTotal += item.amount;
        }
        this.todayReceiptsCount.value = todayReceiptsCount;
        this.todayIncomeTotal.value = todayIncomeTotal;
        this.todayExpensesCount.value = todayExpensesCount;
        this.todayExpenseTotal.value = todayExpenseTotal;
        this.todayGrossProfitTotal.value = todayGrossProfitTotal;
        this.todayNetProfitTotal.value =
            todayGrossProfitTotal - todayExpenseTotal;
      }
    });
  }

  void setIsDashboardShowAll(bool value) {
    isDashboardShowAll.value = value;
  }

  @override
  void onClose() {
    _transactionSubscription.cancel();
    super.onClose();
  }
}
