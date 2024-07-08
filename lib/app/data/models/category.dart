import 'package:powersync/sqlite3.dart' as Sqlite;

class Category {
  final String id;
  final String businessId;
  final String name;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.businessId,
    required this.name,
    required this.createdAt,
  });

  factory Category.fromRow(Sqlite.Row row) {
    return Category(
      id: row["id"],
      businessId: row["business_id"],
      name: row["name"],
      createdAt: DateTime.parse(row["created_at"]),
    );
  }
}
