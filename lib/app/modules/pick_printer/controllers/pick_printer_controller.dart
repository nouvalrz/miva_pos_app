import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal_windows.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickPrinterController extends GetxController {
  List<BluetoothInfo> bluetoothDeviceList = <BluetoothInfo>[];

  RxBool isListLoading = false.obs;
  RxBool isConnectingLoading = false.obs;

  RxString connectedBluetoothDeviceName = "...".obs;
  RxString connectedBluetoothDeviceMac = "".obs;

  @override
  void onInit() {
    super.onInit();
    getConnectedBluetoothDevice();
  }

  Future<void> getConnectedBluetoothDevice() async {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
    final List<String>? connectedPrinter =
        await asyncPrefs.getStringList('connectedPrinter');
    if (connectedPrinter != null) {
      connectedBluetoothDeviceName.value = connectedPrinter[0];
      connectedBluetoothDeviceMac.value = connectedPrinter[1];
    } else {
      connectedBluetoothDeviceName.value = "Belum Ada";
    }
  }

  Future<void> getBluetoothDeviceList() async {
    isListLoading.value = true;
    try {
      bluetoothDeviceList.clear();
      bluetoothDeviceList.addAll(await PrintBluetoothThermal.pairedBluetooths);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    isListLoading.value = false;
  }

  Future<void> connectDevice(BluetoothInfo device) async {
    isConnectingLoading.value = true;
    final bool result = await PrintBluetoothThermal.connect(
        macPrinterAddress: device.macAdress);
    if (result) {
      setConnectedDevice(device);
      await getConnectedBluetoothDevice();
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Berhasil',
        desc: "Printer ${device.name} sudah berhasil tersambung!",
        btnOkOnPress: () {},
      ).show();
    } else {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Gagal',
        desc:
            "Printer ${device.name} tidak berhasil tersambung! Pastikan device benar-benar printer!",
        btnOkOnPress: () {},
      ).show();
    }
    isConnectingLoading.value = false;
  }

  Future<void> setConnectedDevice(BluetoothInfo device) async {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
    await asyncPrefs.setStringList(
        "connectedPrinter", <String>[device.name, device.macAdress]);
  }

  Future<void> printTest() async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      String text = "Test Cetak!";
      bool result = await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: 2, text: text));
    }
  }
}
