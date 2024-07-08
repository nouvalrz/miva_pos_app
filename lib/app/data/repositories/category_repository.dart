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
      int offset = 0}) async {
    String query;
    if (withTotalProduct) {
      query = '''
        SELECT $categoriesTable.*, COUNT($productsTable.category_id) as total_product  FROM $categoriesTable  LEFT JOIN $productsTable  ON $categoriesTable.id = $productsTable.category_id
        WHERE $categoriesTable.business_id = $businessId
        GROUP BY $categoriesTable.id;
        LIMIT ? OFFSET ?
      ''';
    } else {
      query = '''
        SELECT * FROM $categoriesTable
        WHERE business_id = $businessId
        LIMIT ? OFFSET ?
      ''';
    }
    final results = await db.getAll(query, [businessId, limit, offset]);
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
}
