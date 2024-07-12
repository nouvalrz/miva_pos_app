import "package:miva_pos_app/app/data/models/category.dart";
import "package:miva_pos_app/app/services/powersync_service.dart";

import "../models/schema.dart";

class CategoryRepository {
  Future<Category> getCategory({required String id}) async {
    final results =
        await db.get('SELECT * FROM $categoriesTable WHERE id = ?', [id]);
    return Category.fromRow(results);
  }

  Future<List<Category>> getAllCategory(
      {required String businessId,
      bool withTotalProduct = false,
      int limit = 10,
      int offset = 0,
      bool withoutLimit = false}) async {
    String query;
    List<dynamic> parameters = [];
    if (withTotalProduct) {
      query = '''
        SELECT $categoriesTable.*, COUNT($productsTable.category_id) as total_product  FROM $categoriesTable  LEFT JOIN $productsTable  ON $categoriesTable.id = $productsTable.category_id
        WHERE $categoriesTable.business_id = ?
        GROUP BY $categoriesTable.id;
        ${!withoutLimit ? 'LIMIT ? OFFSET ?' : ""}
      ''';

      parameters.add(businessId);
      if (!withoutLimit) {
        parameters.add(limit);
        parameters.add(offset);
      }
    } else {
      query = '''
        SELECT * FROM $categoriesTable
        WHERE business_id = ?
        ${!withoutLimit ? 'LIMIT ? OFFSET ?' : ""}
      ''';
      parameters.add(businessId);
      if (!withoutLimit) {
        parameters.add(limit);
        parameters.add(offset);
      }
    }
    final results = await db.getAll(query, parameters);
    return results.map((result) => Category.fromRow(result)).toList();
  }

  Future<Category> createCategory(Category data) async {
    final results = await db.execute('''
      INSERT INTO 
      categories (business_id, name, created_at)
      VALUES(?, ?, datetime())
      RETURNING *
    ''', [data.businessId, data.name]);
    return Category.fromRow(results.first);
  }

  Future<int> getCategoriesCount(String businessId) async {
    final results = await db.get(
        "SELECT COUNT(*) as count from $categoriesTable WHERE business_id = ?",
        [businessId]);
    return results['count'];
  }
}
