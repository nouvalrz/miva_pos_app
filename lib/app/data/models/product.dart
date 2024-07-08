import 'package:powersync/sqlite3.dart' as Sqlite;

class Product {
  final String id;
  final String businessId;
  final String categoryId;
  final String barcodeNumber;
  final String name;
  final String imageUrl;
  final int salePrice;
  final int costPrice;
  final int? stock;
  final String unit;
  final DateTime createdAt;
  final int? totalSold;

  Product(
      {required this.id,
      required this.businessId,
      required this.categoryId,
      required this.barcodeNumber,
      required this.name,
      required this.salePrice,
      required this.costPrice,
      required this.stock,
      required this.unit,
      required this.createdAt,
      required this.imageUrl,
      required this.totalSold});

  factory Product.fromRow(Sqlite.Row row) {
    return Product(
        id: row["id"],
        businessId: row["business_id"],
        categoryId: row["category_id"],
        barcodeNumber: row["barcode_number"],
        name: row["name"],
        salePrice: row["sale_price"],
        costPrice: row["cost_price"],
        stock: row["stock"],
        unit: row["unit"],
        createdAt: DateTime.parse(row["created_at"]),
        imageUrl: row["image_url"],
        totalSold: row["total_sold"]);
  }
}
