String? currrencyMinValidator({required String value, required String min}) {
  int intMin = int.tryParse(min.replaceAll(".", "")) ?? 0;
  int intValue = int.tryParse(value.replaceAll('.', '')) ?? 0;

  // Perform custom validation
  if (intValue < intMin) {
    return "Harus lebih besar dari Harga Pokok";
  }
  return null;
}

String? currrencyMaxValidator({required String value, required String max}) {
  int intMax = int.tryParse(max.replaceAll(".", "")) ?? 0;
  int intValue = int.tryParse(value.replaceAll('.', '')) ?? 0;

  // Perform custom validation
  if (intValue > intMax) {
    return "Harus lebih kecil dari Harga Jual";
  }
  return null;
}
