import "package:miva_pos_app/app/data/models/user.dart";
import "package:miva_pos_app/app/services/powersync_service.dart";

class UserRepository {
  final dbInstance = db;

  Future<User> find(String id) async {
    final result =
        await dbInstance.get('SELECT * FROM users WHERE id = ?', [id]);
    return User.fromRow(result);
  }
}
