import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miva_pos_app/app/data/models/expense.dart';
import 'package:miva_pos_app/app/data/models/receipt.dart';
import 'package:miva_pos_app/app/modules/dashboard/widgets/expense_card.dart';
import 'package:miva_pos_app/app/modules/dashboard/widgets/receipt_card.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => homeController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                      color: Color(0xFF40228C),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/images/miva-pos-logo-side.svg',
                        width: 30,
                        height: 30,
                      ),
                      const Gap(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() => homeController.isLoading.value
                              ? const CircularProgressIndicator()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      homeController.loggedInBusiness.name,
                                      style: const TextStyle(
                                        fontFamily: "Inter",
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 420,
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        homeController.loggedInBusiness.address,
                                        style: const TextStyle(
                                          fontFamily: "Inter",
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          Obx(
                            () => homeController.isLoading.value
                                ? const CircularProgressIndicator()
                                : SegmentedButton<bool>(
                                    segments: const [
                                      ButtonSegment<bool>(
                                          value: false, label: Text("Lengkap")),
                                      ButtonSegment<bool>(
                                          value: true, label: Text("Sembunyi")),
                                    ],
                                    selected: {
                                      controller.isDashboardShowAll.value
                                    },
                                    onSelectionChanged: (Set<bool> value) {
                                      controller
                                          .setIsDashboardShowAll(value.first);
                                    },
                                    style: ButtonStyle(
                                      side: WidgetStateProperty.resolveWith<
                                          BorderSide?>(
                                        (Set<WidgetState> states) {
                                          return const BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                          );
                                        },
                                      ),
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color?>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.selected)) {
                                            return Colors.white;
                                          }
                                          return null; // Use the default value
                                        },
                                      ),
                                      foregroundColor: WidgetStateProperty
                                          .resolveWith<Color?>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.selected)) {
                                            return Colors.black;
                                          }
                                          return Colors.white;
                                        },
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Obx(() => controller.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Transaksi Hari Ini",
                                          style: TextStyle(
                                            fontFamily: "Inter",
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            "Lihat Semua",
                                            style: TextStyle(
                                                fontFamily: "Inter",
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: Obx(() {
                                    if (controller.transactions.isEmpty) {
                                      return const Center(
                                        child: Text(
                                            "Belum ada transaksi hari ini"),
                                      );
                                    } else {
                                      return ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount:
                                              controller.transactions.length,
                                          itemBuilder: (context, index) {
                                            final transaction =
                                                controller.transactions[index];
                                            if (transaction is Receipt) {
                                              return ReceiptCard(
                                                  receipt: transaction);
                                            } else if (transaction is Expense) {
                                              return ExpenseCard(
                                                expense: transaction,
                                              );
                                            } else {
                                              return const SizedBox.shrink();
                                            }
                                          });
                                    }
                                  })),
                                ],
                              )),
                      ),
                      const VerticalDivider(
                        indent: 12,
                        endIndent: 12,
                        width: 0,
                      ),
                      Expanded(
                          flex: 1,
                          child: Obx(
                            () => controller.isDashboardShowAll.value
                                ? Container(
                                    color: const Color(0xFF40228C),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/images/miva-pos-logo.svg',
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : TodayReceiptsSummaryCard(),
                          )),
                    ],
                  ),
                ),
              ],
            )),
    );
  }
}

class TodayReceiptsSummaryCard extends StatelessWidget {
  TodayReceiptsSummaryCard({
    super.key,
  });

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ringkasan Hari Ini",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(4),
          Text(
            DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.now()),
            style: const TextStyle(
              fontFamily: "Inter",
              color: Color(0xFF40228C),
            ),
          ),
          // const Gap(12),
          // Obx(() => Row(
          //       children: [
          //         Expanded(
          //           child: Container(
          //               decoration: BoxDecoration(
          //                   color: const Color(0xFFF3F1FF),
          //                   borderRadius: BorderRadius.circular(12)),
          //               child: ListTile(
          //                 leading: const Icon(
          //                   Icons.circle,
          //                   color: Color(0xFF40228C),
          //                 ),
          //                 title: Text(
          //                     '${dashboardController.todayReceiptsCount.value} Struk'),
          //               )),
          //         ),
          //         const Gap(12),
          //         Expanded(
          //           child: Container(
          //               decoration: BoxDecoration(
          //                   color: const Color(0xFFF3F1FF),
          //                   borderRadius: BorderRadius.circular(12)),
          //               child: ListTile(
          //                 leading: const Icon(
          //                   Icons.circle,
          //                   color: Color(0xFF40228C),
          //                 ),
          //                 title: Text(
          //                     '${dashboardController.todayExpensesCount.value} Pengeluaran'),
          //               )),
          //         ),
          //       ],
          //     )),
          const Gap(16),
          Container(
            decoration: BoxDecoration(
                color: const Color(0xFFF3F1FF),
                borderRadius: BorderRadius.circular(12)),
            child: Obx(() => ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.circle,
                        color: Color(0xFF40228C),
                      ),
                      title: const Text('Jumlah Struk'),
                      subtitle: Text(
                          '${dashboardController.todayReceiptsCount.value} Struk'),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.circle,
                        color: Color(0xFF40228C),
                      ),
                      title: const Text('Total Penjualan'),
                      subtitle: Text(NumberFormat.currency(
                              locale: 'id', symbol: 'Rp', decimalDigits: 0)
                          .format(dashboardController.todayIncomeTotal.value)),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.circle,
                        color: Color(0xFF40228C),
                      ),
                      title: const Text('Total Keuntungan'),
                      subtitle: Text(NumberFormat.currency(
                              locale: 'id', symbol: 'Rp', decimalDigits: 0)
                          .format(
                              dashboardController.todayGrossProfitTotal.value)),
                    ),
                  ],
                )),
          ),
          const Gap(15),
          Container(
            decoration: BoxDecoration(
                color: const Color(0xFFF3F1FF),
                borderRadius: BorderRadius.circular(12)),
            child: Obx(() => ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.circle,
                        color: Color(0xFF40228C),
                      ),
                      title: const Text('Jumlah Pengeluaran'),
                      subtitle: Text(
                          '${dashboardController.todayExpensesCount.value} Pengeluaran'),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.circle,
                        color: Color(0xFF40228C),
                      ),
                      title: const Text('Total Pengeluaran'),
                      subtitle: Text(NumberFormat.currency(
                              locale: 'id', symbol: 'Rp', decimalDigits: 0)
                          .format(dashboardController.todayExpenseTotal.value)),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
