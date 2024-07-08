import "package:miva_pos_app/app/data/models/business.dart";
import "package:miva_pos_app/app/services/powersync_service.dart";

class BusinessRepository {
  final dbInstance = db;

  Future<Business> getBusiness(String id) async {
    final result =
        await dbInstance.get('SELECT * FROM business WHERE id = ?', [id]);
    return Business.fromRow(result);
  }
}
