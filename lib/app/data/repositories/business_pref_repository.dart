import "package:miva_pos_app/app/data/models/business_pref.dart";
import "package:miva_pos_app/app/services/powersync_service.dart";

class BusinessPrefRepository {
  final dbInstance = db;

  Future<BusinessPref> getBusinessPref(String id) async {
    final result = await dbInstance
        .get('SELECT * FROM business_prefs WHERE business_id = ?', [id]);
    return BusinessPref.fromRow(result);
  }
}
