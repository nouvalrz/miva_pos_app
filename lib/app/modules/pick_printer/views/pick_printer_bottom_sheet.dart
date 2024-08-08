import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:miva_pos_app/app/modules/pick_printer/controllers/pick_printer_controller.dart';
import 'package:miva_pos_app/app/widgets/miva_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<void> pickPrinterBottomSheet(BuildContext context) async {
  final PickPrinterController controller = Get.put(PickPrinterController());
  await showMaterialModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(255, 196, 196, 196),
                  ),
                  child: const SizedBox.shrink(),
                ),
              ],
            ),
            const Text(
              "Atur Printer",
              style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const Gap(12),
            MivaCard.outline(
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.zero,
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Printer Terhubung : ",
                            style: TextStyle(fontFamily: "Inter", fontSize: 16),
                          ),
                          const Gap(6),
                          Text(
                            controller.connectedBluetoothDeviceName.value,
                            style: const TextStyle(
                                fontFamily: "Inter",
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      if (controller.connectedBluetoothDeviceMac.value != "")
                        OutlinedButton.icon(
                          onPressed: () {
                            controller.printTest();
                          },
                          label: const Text("Test Print"),
                          icon: const Icon(FontAwesomeIcons.print),
                        )
                    ],
                  )),
            ),
            const Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "List Device Bluetooth",
                          style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        if (controller.isConnectingLoading.value)
                          const CircularProgressIndicator()
                      ],
                    )),
                FilledButton.icon(
                  onPressed: () {
                    controller.getBluetoothDeviceList();
                  },
                  label: const Text("Cari"),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xff40228C)),
                  ),
                  icon: const Icon(FontAwesomeIcons.search),
                )
              ],
            ),
            const Gap(12),
            Expanded(
              child: MivaCard.outline(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(16),
                  child: Obx(() => controller.isListLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : controller.bluetoothDeviceList.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      "Belum ada device bluetooth yang ditemukan"),
                                  Text("Coba klik tombol 'Cari'"),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    controller.connectDevice(
                                        controller.bluetoothDeviceList[index]);
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    controller.bluetoothDeviceList[index].name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(controller
                                      .bluetoothDeviceList[index].macAdress),
                                );
                              },
                              itemCount: controller.bluetoothDeviceList.length,
                            ))),
            )
          ],
        ),
      );
    },
    expand: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
  );
}
