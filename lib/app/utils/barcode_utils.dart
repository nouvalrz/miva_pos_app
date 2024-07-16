import 'dart:math';

String generateBarcodeNumber() {
  Random random = Random();

  int firstDigit = random.nextInt(9) + 1;
  String remainingDigits = '';
  for (int i = 0; i < 9; i++) {
    remainingDigits += random.nextInt(10).toString();
  }
  return firstDigit.toString() + remainingDigits;
}
