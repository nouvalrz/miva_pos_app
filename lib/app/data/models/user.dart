import 'package:powersync/sqlite3.dart' as Sqlite;

class User {
  final String id;
  final String businessId;
  final String role;
  final DateTime createdAt;
  final String authUserId;
  final String name;

  User(
      {required this.id,
      required this.businessId,
      required this.role,
      required this.createdAt,
      required this.authUserId,
      required this.name});

  factory User.fromRow(Sqlite.Row row) {
    return User(
        id: row["id"],
        businessId: row["business_id"].toString(),
        role: row["role"],
        createdAt: DateTime.parse(row["created_at"]),
        authUserId: row["auth_user_id"],
        name: row["name"]);
  }

  bool isAdmin() {
    return role == "admin";
  }
}
