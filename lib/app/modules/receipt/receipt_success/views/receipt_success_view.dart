import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miva_pos_app/app/modules/pick_printer/views/pick_printer_bottom_sheet.dart';
import 'package:miva_pos_app/app/widgets/miva_card.dart';

import '../controllers/receipt_success_controller.dart';

class ReceiptSuccessView extends GetView<ReceiptSuccessController> {
  const ReceiptSuccessView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => controller.isPageLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Positioned(
                  top: -250,
                  left: -250,
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                        gradient: RadialGradient(
                      colors: [
                        const Color(0x009e8ff0).withAlpha(100),
                        const Color(0x009e8ff0)
                      ],
                      stops: const [0.2, 0.8],
                      center: Alignment.center,
                    )),
                  ),
                ),
                Positioned(
                  top: -250,
                  right: -250,
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                        gradient: RadialGradient(
                      colors: [
                        const Color(0x00faf69b).withAlpha(100),
                        const Color(0x00faf69b)
                      ],
                      stops: const [0.2, 0.8],
                      center: Alignment.center,
                    )),
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const AnimatedEmoji(
                              AnimatedEmojis.heartFace,
                              size: 200,
                              repeat: true,
                            ),
                            const Gap(8),
                            const Text(
                              "Struk Berhasil Disimpan!",
                              style: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Gap(3),
                            Text(
                              "Nomor Struk : ${controller.receipt.receiptNumber}",
                              style: const TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Informasi Struk",
                              style: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Gap(18),
                            SizedBox(
                              width: 340,
                              child: MivaCard.filled(
                                margin: EdgeInsets.zero,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 16),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Total Harga",
                                      style: TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Gap(2),
                                    Text(
                                      NumberFormat.currency(
                                              locale: 'id',
                                              symbol: 'Rp',
                                              decimalDigits: 0)
                                          .format(controller.receipt.totalBill),
                                      style: const TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Gap(26),
                                    const Text(
                                      "Jumlah Bayar",
                                      style: TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Gap(2),
                                    Text(
                                      NumberFormat.currency(
                                              locale: 'id',
                                              symbol: 'Rp',
                                              decimalDigits: 0)
                                          .format(controller.receipt.cashGiven),
                                      style: const TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Gap(26),
                                    const Text(
                                      "Kembalian",
                                      style: TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Gap(2),
                                    Text(
                                      NumberFormat.currency(
                                              locale: 'id',
                                              symbol: 'Rp',
                                              decimalDigits: 0)
                                          .format(
                                              controller.receipt.cashChange),
                                      style: const TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => SizedBox(
                                      width: 300,
                                      child: OutlinedButton.icon(
                                        icon:
                                            const Icon(FontAwesomeIcons.print),
                                        onPressed: () async {
                                          // Aksi ketika tombol ditekan
                                          if (controller
                                                  .connectedBluetoothDeviceMac
                                                  .value !=
                                              "") {
                                            controller.printReceipt();
                                          } else {
                                            await pickPrinterBottomSheet(
                                                context);
                                            controller
                                                .getConnectedBluetoothDevice();
                                          }
                                        },
                                        label: Text(
                                          "Cetak Struk > ${controller.connectedBluetoothDeviceName.value}",
                                          style: const TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                      ),
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      await pickPrinterBottomSheet(context);
                                      controller.getConnectedBluetoothDevice();
                                    },
                                    icon: const Icon(
                                        FontAwesomeIcons.ellipsisVertical))
                              ],
                            )
                          ],
                        )
                      ],
                    )),
                    const Gap(24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color(0xff40228C)),
                          ),
                          onPressed: () {
                            // Aksi ketika tombol ditekan
                            Get.back();
                          },
                          child: const Text(
                            "Kembali ke Home",
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const Gap(24),
                  ],
                )
              ],
            ),
    ));
  }
}
