import 'package:get/get.dart';

class HistoryController extends GetxController {
  //TODO: Implement HistoryController

  final List<String> sortOptions = [
    "Terbaru",
    "Terlama",
    "Terbesar",
    "Terkecil"
  ];

  var selectedOption = "".obs;

  void setSelectedOption(String value) {
    selectedOption.value = value;
  }
}
