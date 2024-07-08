import 'dart:async';

import 'package:get/get.dart';
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

  DashboardController(
      {required this.transactionRepository, required this.homeController});

  @override
  void onInit() {
    super.onInit();
    _transactionSubscription = transactionRepository
        .watchTodayTransactions(homeController.loggedInBusiness.id)
        .listen((data) {
      transactions.assignAll(data);
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
