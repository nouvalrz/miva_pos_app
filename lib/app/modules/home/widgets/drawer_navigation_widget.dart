import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';

class DrawerNaigationWidget extends StatelessWidget {
  const DrawerNaigationWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    List<Obx> adminNavigationItems = [
      Obx(() => ListTile(
            tileColor: homeController.selectedPage.value == 0
                ? Colors.deepPurple.withOpacity(0.5)
                : null,
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              homeController.onDrawerItemTapped(0);
            },
          )),
      Obx(() => ListTile(
            tileColor: homeController.selectedPage.value == 1
                ? Colors.deepPurple.withOpacity(0.5)
                : null,
            leading: const Icon(Icons.category),
            title: const Text('Produk & Kategori'),
            onTap: () {
              homeController.onDrawerItemTapped(1);
            },
          )),
      Obx(() => ListTile(
            tileColor: homeController.selectedPage.value == 2
                ? Colors.deepPurple.withOpacity(0.5)
                : null,
            leading: const Icon(Icons.print),
            title: const Text('Cetak Label'),
            onTap: () {
              homeController.onDrawerItemTapped(2);
            },
          )),
      Obx(() => ListTile(
            tileColor: homeController.selectedPage.value == 3
                ? Colors.deepPurple.withOpacity(0.5)
                : null,
            leading: const Icon(Icons.report),
            title: const Text('Laporan'),
            onTap: () {
              homeController.onDrawerItemTapped(3);
            },
          )),
      Obx(() => ListTile(
            tileColor: homeController.selectedPage.value == 4
                ? Colors.deepPurple.withOpacity(0.5)
                : null,
            leading: const Icon(Icons.money_off),
            title: const Text('Pengeluaran'),
            onTap: () {
              homeController.onDrawerItemTapped(4);
            },
          )),
      Obx(() => ListTile(
            tileColor: homeController.selectedPage.value == 5
                ? Colors.deepPurple.withOpacity(0.5)
                : null,
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan'),
            onTap: () {
              homeController.onDrawerItemTapped(5);
            },
          )),
    ];

    List<Obx> staffNavigationItems = [
      Obx(() => ListTile(
            tileColor: homeController.selectedPage.value == 0
                ? Colors.deepPurple.withOpacity(0.5)
                : null,
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              homeController.onDrawerItemTapped(0);
            },
          )),
      Obx(() => ListTile(
            tileColor: homeController.selectedPage.value == 1
                ? Colors.deepPurple.withOpacity(0.5)
                : null,
            leading: const Icon(Icons.category),
            title: const Text('Produk & Kategori'),
            onTap: () {
              homeController.onDrawerItemTapped(1);
            },
          )),
      Obx(() => ListTile(
            tileColor: homeController.selectedPage.value == 2
                ? Colors.deepPurple.withOpacity(0.5)
                : null,
            leading: const Icon(Icons.print),
            title: const Text('Cetak Label'),
            onTap: () {
              homeController.onDrawerItemTapped(2);
            },
          )),
    ];

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const Gap(10),
                ListTile(
                  leading: const Icon(Icons.circle),
                  title: Text(
                    homeController.loggedInUser.name,
                    style: const TextStyle(
                        fontFamily: "Inter", fontWeight: FontWeight.bold),
                  ),
                  subtitle: Container(
                    margin: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                        color: Color(0xFFF0DA4E),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child:
                        Center(child: Text(homeController.loggedInUser.role)),
                  ),
                  trailing: const Icon(Icons.lock),
                ),
                const Divider(),
                ...(homeController.loggedInUser.role == "admin"
                    ? adminNavigationItems
                    : staffNavigationItems)
              ],
            ),
          ),
          Obx(() => ListTile(
                tileColor: homeController.selectedPage.value == 6
                    ? Colors.deepPurple.withOpacity(0.5)
                    : null,
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Buka Kasir'),
                onTap: () {
                  homeController.onDrawerItemTapped(6);
                },
              )),
        ],
      ),
    );
  }
}
