import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/models/business.dart';
import 'package:miva_pos_app/app/data/models/user.dart' as user_model;
import 'package:miva_pos_app/app/data/repositories/business_repository.dart';
import 'package:miva_pos_app/app/data/repositories/user_repository.dart';
import 'package:miva_pos_app/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:miva_pos_app/app/modules/dashboard/views/dashboard_view.dart';
import 'package:miva_pos_app/app/modules/expense/bindings/expense_binding.dart';
import 'package:miva_pos_app/app/modules/expense/views/expense_view.dart';
import 'package:miva_pos_app/app/modules/label_print/bindings/label_print_binding.dart';
import 'package:miva_pos_app/app/modules/label_print/views/label_print_view.dart';
import 'package:miva_pos_app/app/modules/product_category/bindings/product_category_binding.dart';
import 'package:miva_pos_app/app/modules/product_category/views/product_category_view.dart';
import 'package:miva_pos_app/app/modules/receipt/views/receipt_view.dart';
import 'package:miva_pos_app/app/modules/report/bindings/report_binding.dart';
import 'package:miva_pos_app/app/modules/report/views/report_view.dart';
import 'package:miva_pos_app/app/modules/setting/bindings/setting_binding.dart';
import 'package:miva_pos_app/app/modules/setting/views/setting_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  HomeController(
      {required this.userRepository, required this.businessRepository});

  final UserRepository userRepository;
  final BusinessRepository businessRepository;
  final supabaseInstance = Supabase.instance.client;
  late user_model.User loggedInUser;
  late Business loggedInBusiness;
  final RxInt selectedPage = 0.obs;
  final List<Widget> pages = [
    const DashboardView(),
    const ProductCategoryView(),
    const LabelPrintView(),
    const ReportView(),
    const ExpenseView(),
    const SettingView(),
    const ReceiptView()
  ];
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getUser();
    await getBusiness();
    DashboardBinding().dependencies();
  }

  void onDrawerItemTapped(index) {
    selectedPage.value = index;
    switch (index) {
      case 0:
        DashboardBinding().dependencies();
      case 1:
        ProductCategoryBinding().dependencies();
      case 2:
        LabelPrintBinding().dependencies();
      case 3:
        ReportBinding().dependencies();
      case 4:
        ExpenseBinding().dependencies();
      case 5:
        SettingBinding().dependencies();
    }
  }

  Future<void> getUser() async {
    isLoading.value = true;
    loggedInUser = await userRepository
        .getUserByAuthUserId(supabaseInstance.auth.currentSession!.user.id);
    isLoading.value = false;
  }

  Future<void> getBusiness() async {
    isLoading.value = true;
    loggedInBusiness =
        await businessRepository.getBusiness(loggedInUser.businessId);
    isLoading.value = false;
  }
}
