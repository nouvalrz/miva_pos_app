// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:miva_pos_app/app/data/models/business.dart';
import 'package:miva_pos_app/app/data/models/business_pref.dart';
import 'package:miva_pos_app/app/data/models/receipt.dart';
import 'package:miva_pos_app/app/data/models/receipt_additional_fee.dart';
import 'package:miva_pos_app/app/data/models/receipt_discount.dart';
import 'package:miva_pos_app/app/data/models/receipt_product.dart';
import 'package:miva_pos_app/app/data/models/schema.dart';
import 'package:miva_pos_app/app/data/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;

class BluetoothPrinterService {
  static Future<void> printReceipt(
      {required List<int> receiptBytes, required String macAddress}) async {
    if (!(await PrintBluetoothThermal.connectionStatus)) {
      bool connect =
          await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
      if (!connect) {
        throw Exception("Tidak ada printer atau gagal tersambung. Coba Lagi!");
      }
    }
    await PrintBluetoothThermal.writeBytes(receiptBytes);
  }

  static Future<List<int>> receiptToBytes(
      {required Receipt receipt,
      required String receiptPaymentMethodName,
      required List<ReceiptProduct> receiptProducts,
      required List<ReceiptDiscount> receiptDiscounts,
      required List<ReceiptAdditionalFee> receiptAdditionalFees,
      required Business business,
      required User user,
      required BusinessPref businessPref}) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    // clear text style
    bytes += generator.reset();

    // put logo
    if ((businessPref.receiptShowFooterMessage == 1) &&
        business.logoUrl != null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      String fileName = 'logo.png';
      File file = File('$appDocPath/$fileName');

      if (await file.exists()) {
        img.Image? image = img.decodeImage(await file.readAsBytes());
        if (image != null) {
          int maxWidth = 300;
          int maxHeight = 150;
          double aspectRatio = image.width / image.height;

          // Determine the new dimensions
          int newWidth = image.width;
          int newHeight = image.height;

          if (newWidth > maxWidth) {
            newWidth = maxWidth;
            newHeight = (newWidth / aspectRatio).round();
          }

          if (newHeight > maxHeight) {
            newHeight = maxHeight;
            newWidth = (newHeight * aspectRatio).round();
          }

          // Resize the image
          img.Image resizedImage =
              img.copyResize(image, width: newWidth, height: newHeight);

          Uint8List resizedBytes =
              Uint8List.fromList(img.encodePng(resizedImage));

          image = img.decodeImage(resizedBytes);
          bytes += generator.imageRaster(image!);
        }
      }
    }

    // put business name
    bytes += generator.text(business.name,
        styles: const PosStyles(
            bold: true, height: PosTextSize.size2, align: PosAlign.center));

    // put address
    if (businessPref.receiptShowAddress == 1) {
      bytes += generator.text("${business.address}\n",
          styles: const PosStyles(align: PosAlign.center));
    }

    bytes += generator.row([
      PosColumn(
        text: 'ID Struk',
        width: 4,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: ": ${receipt.receiptNumber}",
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
    ]);

    // put receipt header info
    bytes += generator.row([
      PosColumn(
        text: 'Tanggal',
        width: 4,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text:
            ": ${DateFormat('dd/MM/yyyy - HH:mm').format(receipt.createdAt.toLocal())}",
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
    ]);

    if (businessPref.receiptShowUserName == 1) {
      bytes += generator.row([
        PosColumn(
          text: 'Kasir',
          width: 4,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: ": ${user.name}",
          width: 8,
          styles: const PosStyles(align: PosAlign.left),
        ),
      ]);
    }

    bytes += generator.hr();

    // put receipt products
    for (var item in receiptProducts) {
      bytes += generator.text(item.productName.toUpperCase(),
          styles: const PosStyles(align: PosAlign.left));

      bytes += generator.row([
        PosColumn(
          text: "x${item.quantity}",
          width: 2,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text:
              "@${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(item.productSalePrice)}",
          width: 5,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text:
              NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
                  .format(item.productSalePrice * item.quantity),
          width: 5,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    //put additional fee
    for (var item in receiptAdditionalFees) {
      bytes += generator.text("[TAMBAHAN] ${item.name.toUpperCase()}",
          styles: const PosStyles(align: PosAlign.left));

      bytes += generator.row([
        PosColumn(
          text:
              "@${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(item.amount)}",
          width: 6,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text:
              NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
                  .format(item.amount),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += generator.hr();

    final productItemCount =
        receiptProducts.fold(0, (sum, item) => sum + item.quantity);

    // put total item
    bytes += generator.text("$productItemCount Item\n",
        styles: const PosStyles(align: PosAlign.left, bold: false));

    // put summary info
    bytes += generator.row([
      PosColumn(
        text: 'Metode :',
        width: 7,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: receiptPaymentMethodName,
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    if (receiptDiscounts.isNotEmpty) {
      bytes += generator.row([
        PosColumn(
          text: 'Subtotal :',
          width: 7,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: NumberFormat.currency(
                  locale: 'id', symbol: '', decimalDigits: 0)
              .format(
                  receipt.totalProductPrice + receipt.totalAdditionalFeePrice),
          width: 5,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    if (receiptDiscounts.isNotEmpty) {
      bytes += generator.row([
        PosColumn(
          text: 'Diskon :',
          width: 7,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text:
              "- ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(receipt.totalDiscountPrice)}",
          width: 5,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += generator.row([
      PosColumn(
        text: 'Total Harga :',
        width: 7,
        styles:
            const PosStyles(align: PosAlign.right, height: PosTextSize.size3),
      ),
      PosColumn(
        text: NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(receipt.totalBill),
        width: 5,
        styles:
            const PosStyles(align: PosAlign.right, height: PosTextSize.size3),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Jumlah Bayar :',
        width: 7,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(receipt.cashGiven),
        width: 5,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Kembalian :',
        width: 7,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(receipt.cashChange),
        width: 5,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    bytes += generator.hr();

    // put footer message
    if (businessPref.receiptShowFooterMessage == 1) {
      // LineSplitter ls = const LineSplitter();
      // var lines = ls.convert(businessPref.footerMessage);
      var lines = businessPref.footerMessage.split("\\n");
      for (String line in lines) {
        bytes += generator.text(line,
            styles: const PosStyles(align: PosAlign.center, bold: false));
      }
    }
    bytes += generator.feed(3);

    return bytes;
    // return [];
  }
}
