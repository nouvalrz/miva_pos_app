import 'package:get/get.dart';

import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/expense/bindings/expense_binding.dart';
import '../modules/expense/views/expense_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/label_print/bindings/label_print_binding.dart';
import '../modules/label_print/views/label_print_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/product_category/bindings/product_category_binding.dart';
import '../modules/product_category/views/product_category_view.dart';
import '../modules/receipt/bindings/receipt_binding.dart';
import '../modules/receipt/views/receipt_view.dart';
import '../modules/report/bindings/report_binding.dart';
import '../modules/report/views/report_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const WITH_SESSION = Routes.HOME;
  static const WITHOUT_SESSION = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_CATEGORY,
      page: () => const ProductCategoryView(),
      binding: ProductCategoryBinding(),
    ),
    GetPage(
      name: _Paths.LABEL_PRINT,
      page: () => const LabelPrintView(),
      binding: LabelPrintBinding(),
    ),
    GetPage(
      name: _Paths.RECEIPT,
      page: () => const ReceiptView(),
      binding: ReceiptBinding(),
    ),
    GetPage(
      name: _Paths.REPORT,
      page: () => const ReportView(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: _Paths.EXPENSE,
      page: () => const ExpenseView(),
      binding: ExpenseBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
  ];
}
