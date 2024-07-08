import "package:miva_pos_app/app/data/models/receipt.dart";
import "package:miva_pos_app/app/services/powersync_service.dart";

import "../models/schema.dart";

class ReceiptRepository {
  Future<Receipt> getReceipt({required String id}) async {
    final results =
        await db.get('SELECT * FROM $receiptsTable WHERE id = ?', [id]);
    return Receipt.fromRow(results);
  }
}
