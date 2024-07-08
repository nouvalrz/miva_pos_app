import 'package:powersync/sqlite3.dart' as Sqlite;

class ReceiptDiscount {
  final String id;
  final String receiptId;
  final String name;
  final int amount;
  final DateTime createdAt;
  final String businessId;

  ReceiptDiscount({
    required this.id,
    required this.receiptId,
    required this.name,
    required this.amount,
    required this.createdAt,
    required this.businessId,
  });

  factory ReceiptDiscount.fromRow(Sqlite.Row row) {
    return ReceiptDiscount(
      id: row["id"],
      receiptId: row["receipt_id"],
      name: row["name"],
      amount: row["amount"],
      createdAt: DateTime.parse(row["created_at"]),
      businessId: row["business_id"],
    );
  }
}
