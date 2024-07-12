// ignore_for_file: constant_identifier_names

import "package:miva_pos_app/app/data/models/product.dart";
import "package:miva_pos_app/app/services/powersync_service.dart";

import "../models/schema.dart";

class ProductRepository {
  static const ORDER_BY_NAME_ASC = "ORDER BY name ASC";
  static const ORDER_BY_NAME_DESC = "ORDER BY name DESC";
  static const ORDER_BY_TOTAL_SOLD_DESC = "ORDER BY total_sold DESC";
  static const ORDER_BY_TOTAL_SOLD_ASC = "ORDER BY total_sold ASC";

  Future<Product> getProduct({required String id}) async {
    final results =
        await db.get('SELECT * FROM $productsTable WHERE id = ?', [id]);
    return Product.fromRow(results);
  }

// GET ALL STATIC
  Future<List<Product>> getAllProduct(
      {required String businessId,
      bool withTotalSold = false,
      int limit = 10,
      int offset = 0,
      String? searchKeyword,
      String categoryId = "0",
      String orderQuery = ORDER_BY_NAME_ASC}) async {
    String query;
    List<dynamic> parameters = [];

    if (withTotalSold) {
      query = '''
      SELECT p.*, 
        COALESCE(SUM(rp.quantity), 0) as total_sold
      FROM $productsTable p
      LEFT JOIN $receiptProductsTable rp ON p.id = rp.product_id
      WHERE 
      ${searchKeyword != null && searchKeyword.isNotEmpty ? "(p.name LIKE ? OR p.barcode_number LIKE ?) AND " : ''}
      ${categoryId != "0" ? "p.category_id = ? AND" : ""}
      p.business_id = ?
      GROUP BY p.id
      $orderQuery
      LIMIT ? OFFSET ? 
    ''';

      if (searchKeyword != null && searchKeyword.isNotEmpty) {
        parameters.add('%$searchKeyword%');
        parameters.add('%$searchKeyword%');
      }

      if (categoryId != "0") {
        parameters.add(categoryId);
      }

      parameters.add(businessId);
      parameters.add(limit);
      parameters.add(offset);
    } else {
      query = '''
      SELECT * FROM $productsTable WHERE 
      ${searchKeyword != null ? "(name LIKE ? OR barcode_number LIKE ?) AND " : ''}
      ${categoryId != "0" ? "p.category_id = ? AND" : ""}
      business_id = ?
      $orderQuery
      LIMIT ? OFFSET ? 
    ''';

      if (searchKeyword != null) {
        parameters.add('%$searchKeyword%');
        parameters.add('%$searchKeyword%');
      }

      if (categoryId != "0") {
        parameters.add(categoryId);
      }

      parameters.add(businessId);
      parameters.add(limit);
      parameters.add(offset);
    }

    final results = await db.getAll(query, parameters);
    return results.map((result) => Product.fromRow(result)).toList();
  }

  // GET ALL STREAM
  Stream<List<Product>> watchProducts(String businessId) {
    return db.watch('SELECT * FROM $productsTable WHERE business_id = ?',
        parameters: [businessId]).map((results) {
      return results.map(Product.fromRow).toList(growable: false);
    });
  }

  Future<Product> createProduct(Product data) async {
    final results = await db.execute('''
      INSERT INTO
        $productsTable(business_id, category_id, barcode_number, name, sale_price, cost_price, stock, unit, image_url, created_at)
        VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, datetime())
      RETURNING *
    ''', [
      data.businessId,
      data.categoryId,
      data.barcodeNumber,
      data.name,
      data.salePrice,
      data.costPrice,
      data.stock,
      data.unit,
      data.imageUrl
    ]);
    return Product.fromRow(results.first);
  }

  Future<Product> updateProduct(Product data) async {
    final results = await db.execute('''
      UPDATE $productsTable SET
        business_id = ?,
        category_id = ?,
        barcode_number = ?,
        name = ?,
        sale_price = ?,
        cost_price = ?,
        stock = ?,
        unit = ?,
        image_url = ?,
      WHERE id = ?
      RETURNING *
    ''', [
      data.businessId,
      data.categoryId,
      data.barcodeNumber,
      data.name,
      data.salePrice,
      data.costPrice,
      data.stock,
      data.unit,
      data.imageUrl,
      data.id,
    ]);
    return Product.fromRow(results.first);
  }

  Future<int> getProductsCount(String businessId) async {
    final results = await db.get(
        "SELECT COUNT(*) as count from $productsTable WHERE business_id = ?",
        [businessId]);
    return results['count'];
  }
}
