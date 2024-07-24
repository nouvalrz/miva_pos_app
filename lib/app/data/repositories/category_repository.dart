// ignore_for_file: constant_identifier_names

import "package:miva_pos_app/app/data/models/category.dart";
import "package:miva_pos_app/app/services/powersync_service.dart";

import "../models/schema.dart";

class CategoryRepository {
  static const ORDER_BY_NAME_ASC = "ORDER BY name ASC";
  static const ORDER_BY_NAME_DESC = "ORDER BY name DESC";
  static const ORDER_BY_TOTAL_PRODUCT_DESC = "ORDER BY total_product DESC";
  static const ORDER_BY_TOTAL_PRODUCT_ASC = "ORDER BY total_product ASC";

  Future<Category> getCategory({required String id}) async {
    final results =
        await db.get('SELECT * FROM $categoriesTable WHERE id = ?', [id]);
    return Category.fromRow(results);
  }

  Future<int> getCountCategoryByName(
      {required String businessId, required String categoryName}) async {
    final results = await db.get(
        'SELECT COUNT(*) as count FROM $categoriesTable WHERE business_id = ? AND name LIKE ?',
        [businessId, categoryName]);
    return results['count'];
  }

  Future<List<Category>> getAllCategory(
      {required String businessId,
      bool withTotalProduct = false,
      int limit = 10,
      int offset = 0,
      String? searchKeyword,
      String orderQuery = ORDER_BY_NAME_ASC,
      bool withoutLimit = false}) async {
    String query;
    List<dynamic> parameters = [];
    if (withTotalProduct) {
      query = '''
        SELECT $categoriesTable.*, COUNT($productsTable.category_id) as total_product  FROM $categoriesTable  LEFT JOIN $productsTable  ON $categoriesTable.id = $productsTable.category_id
        WHERE 
        ${searchKeyword != null && searchKeyword.isNotEmpty ? "$categoriesTable.name LIKE ? AND " : ''}
        $categoriesTable.business_id = ?
        GROUP BY $categoriesTable.id
        $orderQuery
        ${!withoutLimit ? 'LIMIT ? OFFSET ?' : ""}
      ''';

      if (searchKeyword != null && searchKeyword.isNotEmpty) {
        parameters.add('%$searchKeyword%');
      }

      parameters.add(businessId);
      if (!withoutLimit) {
        parameters.add(limit);
        parameters.add(offset);
      }
    } else {
      query = '''
        SELECT * FROM $categoriesTable
        WHERE 
        ${searchKeyword != null && searchKeyword.isNotEmpty ? "$categoriesTable.name LIKE ? AND " : ''}
        $categoriesTable.business_id = ?
        $orderQuery
        ${!withoutLimit ? 'LIMIT ? OFFSET ?' : ""}
      ''';
      if (searchKeyword != null && searchKeyword.isNotEmpty) {
        parameters.add('%$searchKeyword%');
      }
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
      categories (id, business_id, name, created_at)
      VALUES(uuid(), ?, ?, datetime())
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

  Future<Category> updateCategory(Category data) async {
    final results = await db.execute('''
      UPDATE $categoriesTable SET
        name = ?
      WHERE id = ?
      RETURNING *
    ''', [
      data.name,
      data.id,
    ]);
    return Category.fromRow(results.first);
  }
}
