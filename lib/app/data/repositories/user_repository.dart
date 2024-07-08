import "package:miva_pos_app/app/data/models/user.dart";
import "package:miva_pos_app/app/services/powersync_service.dart";

class UserRepository {
  final dbInstance = db;

  Future<User> getUserByAuthUserId(String authUserId) async {
    final result = await dbInstance
        .get('SELECT * FROM users WHERE auth_user_id = ?', [authUserId]);
    return User.fromRow(result);
  }
}
