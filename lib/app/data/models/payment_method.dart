import 'package:powersync/sqlite3.dart' as Sqlite;

class PaymentMethod {
  final String id;
  final String name;
  final String businessId;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.businessId,
  });

  factory PaymentMethod.fromRow(Sqlite.Row row) {
    return PaymentMethod(
      id: row["id"],
      name: row["name"],
      businessId: row["business_id"],
    );
  }
}
