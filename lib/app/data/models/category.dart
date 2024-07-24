import 'package:powersync/sqlite3.dart' as Sqlite;

class Category {
  final String id;
  final String businessId;
  final String name;
  final DateTime createdAt;
  final int? totalProduct;

  Category(
      {required this.id,
      required this.businessId,
      required this.name,
      required this.createdAt,
      required this.totalProduct});

  factory Category.fromRow(Sqlite.Row row) {
    return Category(
        id: row["id"].toString(),
        businessId: row["business_id"].toString(),
        name: row["name"],
        createdAt: DateTime.parse(row["created_at"]),
        totalProduct: row["total_product"]);
  }

  Map<String, dynamic> toMapForForm() {
    return {
      "id": id,
      "business_id": businessId,
      "name": name,
      "created_at": createdAt
    };
  }
}
