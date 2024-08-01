import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miva_pos_app/app/data/models/receipt.dart';

class ReceiptSuccessController extends GetxController {
  //TODO: Implement ReceiptSuccessController

  late Receipt receipt;

  RxBool isPageLoading = false.obs;

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    isPageLoading.value = true;
    receipt = Get.arguments["receipt"];
    isPageLoading.value = false;
    playSound("success_add_receipt");
  }

  Future<void> playSound(String soundName) async {
    try {
      await audioPlayer.setAsset('assets/sounds/$soundName.mp3');
      await audioPlayer.play();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }


  
}
