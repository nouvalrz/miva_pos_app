import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';

class MivaV2Navigation extends StatelessWidget {
  const MivaV2Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    List<SideMenuItem> adminMenus = [
      SideMenuItem(
          title: "Dashboard",
          icon: const Icon(Icons.dashboard),
          onTap: (index, _) {
            homeController.onDrawerItemTapped(index);
            homeController.sideMenuController.changePage(index);
          }),
      SideMenuItem(
          title: "Produk & Kategori",
          icon: const Icon(Icons.category),
          onTap: (index, _) {
            homeController.onDrawerItemTapped(index);
            homeController.sideMenuController.changePage(index);
          }),
      SideMenuItem(
          title: "Cetak Label",
          icon: const Icon(Icons.print),
          onTap: (index, _) {
            homeController.onDrawerItemTapped(index);
            homeController.sideMenuController.changePage(index);
          }),
      SideMenuItem(
          title: "Laporan",
          icon: const Icon(Icons.book),
          onTap: (index, _) {
            homeController.onDrawerItemTapped(index);
            homeController.sideMenuController.changePage(index);
          }),
      SideMenuItem(
          title: "Pengeluaran",
          icon: const Icon(Icons.outbox_rounded),
          onTap: (index, _) {
            homeController.onDrawerItemTapped(index);
            homeController.sideMenuController.changePage(index);
          }),
      SideMenuItem(
          title: "Pengaturan",
          icon: const Icon(Icons.settings),
          onTap: (index, _) {
            homeController.onDrawerItemTapped(index);
            homeController.sideMenuController.changePage(index);
          }),
      SideMenuItem(
          title: "Buka Kasir",
          icon: const Icon(Icons.receipt),
          onTap: (index, _) {
            homeController.onDrawerItemTapped(index);
            homeController.sideMenuController.changePage(index);
          }),
    ];

    List<SideMenuItem> staffMenus = [
      SideMenuItem(
          title: "Dashboard",
          icon: const Icon(Icons.dashboard),
          onTap: (index, _) {
            homeController.onDrawerItemTapped(index);
            homeController.sideMenuController.changePage(index);
          }),
      SideMenuItem(
          title: "Produk & Kategori",
          icon: const Icon(Icons.category),
          onTap: (index, _) {
            homeController.onDrawerItemTapped(index);
            homeController.sideMenuController.changePage(index);
          }),
      SideMenuItem(
          title: "Cetak Label",
          icon: const Icon(Icons.print),
          onTap: (index, _) {
            homeController.onDrawerItemTapped(index);
            homeController.sideMenuController.changePage(index);
          }),
      SideMenuItem(
          title: "Buka Kasir",
          icon: const Icon(Icons.receipt),
          onTap: (index, _) {
            homeController.onDrawerItemTapped(index);
            homeController.sideMenuController.changePage(index);
          }),
    ];

    return SideMenu(
      title: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.account_circle_rounded,
                  size: 45,
                ),
                const Gap(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      homeController.loggedInUser.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const Gap(4),
                    Badge(
                      largeSize: 18,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      backgroundColor: const Color(0xffF0DA4E),
                      textColor: const Color(0xff333333),
                      label: Text(
                        homeController.loggedInUser.role.capitalizeFirst!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
                const Expanded(child: SizedBox.shrink()),
                IconButton(onPressed: () {}, icon: const Icon(Icons.lock))
              ],
            ),
            const Gap(10),
            const Divider(
              height: 1,
            )
          ],
        ),
      ),
      items:
          homeController.loggedInUser.role == "admin" ? adminMenus : staffMenus,
      controller: homeController.sideMenuController,
      style: SideMenuStyle(
          backgroundColor: const Color(0xFFF2EEFE),
          itemOuterPadding:
              const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          displayMode: SideMenuDisplayMode.open,
          toggleColor: const Color(0xFFBEB7F6),
          selectedTitleTextStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          unselectedTitleTextStyle: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 16,
              fontWeight: FontWeight.w500),
          unselectedIconColor: const Color(0xFF333333),
          selectedColor: const Color(0XFFBEB7F6)),
    );
  }
}
