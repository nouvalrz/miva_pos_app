import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';

class MivaNavigationRailWidget extends StatelessWidget {
  const MivaNavigationRailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    List<NavigationRailDestination> adminDestinations = [
      const NavigationRailDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        padding: EdgeInsets.symmetric(vertical: 10),
        label: Text(
          'Dashboard',
          style: TextStyle(fontSize: 16),
        ),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.category_outlined),
        selectedIcon: Icon(Icons.category),
        padding: EdgeInsets.symmetric(vertical: 10),
        label: Text(
          'Produk & Kategori',
          style: TextStyle(fontSize: 16),
        ),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.print_outlined),
        selectedIcon: Icon(Icons.print),
        padding: EdgeInsets.symmetric(vertical: 10),
        label: Text(
          'Cetak Label',
          style: TextStyle(fontSize: 16),
        ),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.report_outlined),
        selectedIcon: Icon(Icons.report),
        padding: EdgeInsets.symmetric(vertical: 10),
        label: Text(
          'Laporan',
          style: TextStyle(fontSize: 16),
        ),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.money_off_outlined),
        selectedIcon: Icon(Icons.money_off),
        padding: EdgeInsets.symmetric(vertical: 10),
        label: Text(
          'Pengeluaran',
          style: TextStyle(fontSize: 16),
        ),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        padding: EdgeInsets.symmetric(vertical: 10),
        label: Text(
          'Pengaturan',
          style: TextStyle(fontSize: 16),
        ),
      ),
    ];

    List<NavigationRailDestination> staffDestinations = [
      const NavigationRailDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        padding: EdgeInsets.symmetric(vertical: 10),
        label: Text(
          'Dashboard',
          style: TextStyle(fontSize: 16),
        ),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.category_outlined),
        selectedIcon: Icon(Icons.category),
        padding: EdgeInsets.symmetric(vertical: 10),
        label: Text(
          'Produk & Kategori',
          style: TextStyle(fontSize: 16),
        ),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.print_outlined),
        padding: EdgeInsets.symmetric(vertical: 10),
        selectedIcon: Icon(Icons.print),
        label: Text(
          'Cetak Label',
          style: TextStyle(fontSize: 16),
        ),
      ),
    ];

    return Obx(() => NavigationRail(
          backgroundColor: const Color(0xFFF2EEFE),
          extended: true,
          destinations: homeController.loggedInUser.role == "admin"
              ? adminDestinations
              : staffDestinations,
          selectedIndex: homeController.selectedPage.value,
          onDestinationSelected: (value) {
            homeController.onDrawerItemTapped(value);
          },
        ));
  }
}
