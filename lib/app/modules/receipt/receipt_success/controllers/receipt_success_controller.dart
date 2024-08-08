import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:miva_pos_app/app/data/models/receipt.dart';
import 'package:miva_pos_app/app/data/models/receipt_additional_fee.dart';
import 'package:miva_pos_app/app/data/models/receipt_discount.dart';
import 'package:miva_pos_app/app/data/models/receipt_product.dart';
import 'package:miva_pos_app/app/modules/home/controllers/home_controller.dart';
import 'package:miva_pos_app/app/services/bluetooth_printer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiptSuccessController extends GetxController {
  //TODO: Implement ReceiptSuccessController

  late Receipt receipt;
  late List<ReceiptProduct> receiptProducts;
  late List<ReceiptDiscount> receiptDiscounts;
  late List<ReceiptAdditionalFee> receiptAdditionalFees;
  late String receiptPaymentMethodName;

  RxBool isPageLoading = false.obs;
  RxBool isPrintLoading = false.obs;

  AudioPlayer audioPlayer = AudioPlayer();

  RxString connectedBluetoothDeviceName = "...".obs;
  RxString connectedBluetoothDeviceMac = "".obs;
  // "receipt": storedReceipt,
  // "receiptProducts": receiptProductList,
  // "receiptAdditionalFees": receiptAdditionalFeeList,
  // "receiptDiscounts": receiptDiscountList,
  // "receiptPaymentMethodName": selectedPaymentMethodName.value

  @override
  void onInit() async {
    super.onInit();
    isPageLoading.value = true;
    receipt = Get.arguments["receipt"];
    receiptProducts = Get.arguments["receiptProducts"];
    receiptDiscounts = Get.arguments["receiptDiscounts"];
    receiptAdditionalFees = Get.arguments["receiptAdditionalFees"];
    receiptPaymentMethodName = Get.arguments["receiptPaymentMethodName"];
    await getConnectedBluetoothDevice();
    isPageLoading.value = false;
    playSound("success_add_receipt");
  }

  Future<void> playSound(String soundName) async {
    try {
      // await audioPlayer.setAsset('assets/sounds/$soundName.mp3');
      // await audioPlayer.play();
      await audioPlayer.play(AssetSource('sounds/$soundName.mp3'));
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> getConnectedBluetoothDevice() async {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
    final List<String>? connectedPrinter =
        await asyncPrefs.getStringList('connectedPrinter');
    if (connectedPrinter != null) {
      connectedBluetoothDeviceName.value = connectedPrinter[0];
      connectedBluetoothDeviceMac.value = connectedPrinter[1];
    } else {
      connectedBluetoothDeviceName.value = "Belum Ada Printer";
    }
  }

  Future<void> printReceipt() async {
    // isPrintLoading.value = true;
    try {
      final HomeController homeController = Get.find<HomeController>();
      await BluetoothPrinterService.printReceipt(
          receiptBytes: await BluetoothPrinterService.receiptToBytes(
              receipt: receipt,
              receiptPaymentMethodName: receiptPaymentMethodName,
              receiptProducts: receiptProducts,
              receiptDiscounts: receiptDiscounts,
              receiptAdditionalFees: receiptAdditionalFees,
              business: homeController.loggedInBusiness,
              user: homeController.loggedInUser,
              businessPref: homeController.loggedInBusinessPref));
    } catch (e) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Gagal',
        desc: e.toString(),
        btnOkOnPress: () {},
      ).show();
    }
    // isPrintLoading.value = false;
  }
}
