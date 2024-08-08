import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:miva_pos_app/app/data/models/business.dart';
import 'package:miva_pos_app/app/data/models/business_pref.dart';
import 'package:miva_pos_app/app/data/models/user.dart' as user_model;
import 'package:miva_pos_app/app/data/repositories/business_pref_repository.dart';
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
import 'package:miva_pos_app/app/modules/receipt/bindings/receipt_binding.dart';
import 'package:miva_pos_app/app/modules/receipt/controllers/receipt_controller.dart';
import 'package:miva_pos_app/app/modules/receipt/views/receipt_view.dart';
import 'package:miva_pos_app/app/modules/report/bindings/report_binding.dart';
import 'package:miva_pos_app/app/modules/report/views/report_view.dart';
import 'package:miva_pos_app/app/modules/setting/bindings/setting_binding.dart';
import 'package:miva_pos_app/app/modules/setting/views/setting_view.dart';
import 'package:miva_pos_app/app/routes/app_pages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  HomeController(
      {required this.userRepository,
      required this.businessRepository,
      required this.businessPrefRepository});

  final UserRepository userRepository;
  final BusinessRepository businessRepository;
  final BusinessPrefRepository businessPrefRepository;
  final supabaseInstance = Supabase.instance.client;
  late user_model.User loggedInUser;
  late Business loggedInBusiness;
  late BusinessPref loggedInBusinessPref;
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

  var pages2 = [
    GetRouterOutlet(
      initialRoute: Routes.DASHBOARD,
    ),
    GetRouterOutlet(initialRoute: Routes.PRODUCT_CATEGORY),
    GetRouterOutlet(initialRoute: Routes.LABEL_PRINT),
    GetRouterOutlet(initialRoute: Routes.REPORT),
    GetRouterOutlet(initialRoute: Routes.EXPENSE),
    GetRouterOutlet(initialRoute: Routes.SETTING),
    GetRouterOutlet(initialRoute: Routes.RECEIPT),
  ];
  RxBool isLoading = false.obs;

  SideMenuController sideMenuController = SideMenuController();

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    await getUser();
    await getBusiness();
    await getBusinessPref();
    await downloadBusinessLogo();
    isLoading.value = false;
    DashboardBinding().dependencies();
  }

  void onDrawerItemTapped(index) async {
    if (selectedPage.value == 6 && index.toInt() != 6) {
      final ReceiptController receiptController = Get.find<ReceiptController>();
      if (receiptController.receiptProducts.isNotEmpty) {
        bool shouldProceed = false;
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          animType: AnimType.bottomSlide,
          title: "Konfirmasi",
          desc: "Jika pindah halaman, maka data kasir akan hilang, yakin?",
          btnCancelOnPress: () {
            shouldProceed = false;
          },
          btnOkOnPress: () {
            shouldProceed = true;
          },
        ).show();
        if (!shouldProceed) {
          return;
        }
        receiptController.receiptProducts.clear();
      }
    }
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
      case 6:
        ReceiptBinding().dependencies();
    }
    sideMenuController.changePage(index);
  }

  Future<void> getUser() async {
    // isLoading.value = true;
    loggedInUser = await userRepository
        .getUserByAuthUserId(supabaseInstance.auth.currentSession!.user.id);
    // isLoading.value = false;
  }

  Future<void> getBusiness() async {
    // isLoading.value = true;
    loggedInBusiness =
        await businessRepository.getBusiness(loggedInUser.businessId);
    // isLoading.value = false;
  }

  Future<void> getBusinessPref() async {
    // isLoading.value = true;
    loggedInBusinessPref =
        await businessPrefRepository.getBusinessPref(loggedInUser.businessId);
    // isLoading.value = false;
  }

  Future<void> downloadBusinessLogo() async {
    if (loggedInBusiness.logoUrl == null) {
      return;
    }

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    String fileName = 'logo.png';
    File file = File('$appDocPath/$fileName');

    if (await file.exists()) {
      return;
    }
    final http.Response downloadResponse =
        await http.get(Uri.parse(loggedInBusiness.logoUrl!));
    if (downloadResponse.statusCode == 200) {
      await file.writeAsBytes(downloadResponse.bodyBytes);
    }
  }
}
