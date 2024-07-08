import "package:miva_pos_app/app/data/models/product.dart";
import "package:miva_pos_app/app/services/powersync_service.dart";

import "../models/schema.dart";

class ProductRepository {
  Future<Product> getProduct({required String id}) async {
    final results =
        await db.get('SELECT * FROM $productsTable WHERE id = ?', [id]);
    return Product.fromRow(results);
  }

  // GET ALL STATIC
  Future<List<Product>> getAllProduct(
      {required businessId,
      bool withTotalSold = false,
      int limit = 10,
      int offset = 0}) async {
    String query;
    if (withTotalSold) {
      query = '''
        SELECT p.*, 
          COALESCE(SUM(rp.quantity), 0) as total_sold
        FROM $productsTable p
        LEFT JOIN $receiptProductsTable rp ON p.id = rp.product_id
        WHERE p.business_id = ?
        GROUP BY p.id
        LIMIT ? OFFSET ? 
      ''';
    } else {
      query = '''
        SELECT * FROM $productsTable WHERE business_id = ?
        LIMIT ? OFFSET ? 
      ''';
    }

    final results = await db.getAll(query, [businessId, limit, offset]);
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
}
