import 'package:powersync/sqlite3.dart' as Sqlite;

class Business {
  final String id;
  final String name;
  final String address;
  final String? logoUrl;
  final DateTime createdAt;

  Business({
    required this.id,
    required this.name,
    required this.address,
    required this.logoUrl,
    required this.createdAt,
  });

  factory Business.fromRow(Sqlite.Row row) {
    return Business(
      id: row["id"],
      name: row["name"],
      address: row["address"],
      logoUrl: row["logo_url"],
      createdAt: DateTime.parse(row["created_at"]),
    );
  }
}
