import 'package:powersync/sqlite3.dart' as Sqlite;

class Expense {
  final String id;
  final String businessId;
  final String name;
  final int amount;
  final String? description;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.businessId,
    required this.name,
    required this.amount,
    required this.description,
    required this.createdAt,
  });

  factory Expense.fromRow(Sqlite.Row row) {
    return Expense(
      id: row["id"].toString(),
      businessId: row["business_id"].toString(),
      name: row["name"],
      amount: row["amount"],
      description: row["description"],
      createdAt: DateTime.parse(row["created_at"] + "Z"),
    );
  }
}
