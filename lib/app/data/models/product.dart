import 'package:intl/intl.dart';
import 'package:powersync/sqlite3.dart' as Sqlite;

class Product {
  final String id;
  final String businessId;
  final String categoryId;
  final String barcodeNumber;
  final String name;
  final String? imageUrl;
  final int salePrice;
  final int costPrice;
  final int? stock;
  final String unit;
  final DateTime createdAt;
  final String? categoryName;
  final int? totalSold;
  int receiptQuantity = 1;

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
      required this.categoryName,
      required this.totalSold});

  factory Product.fromRow(Sqlite.Row row) {
    return Product(
        id: row["id"].toString(),
        businessId: row["business_id"].toString(),
        categoryId: row["category_id"].toString(),
        barcodeNumber: row["barcode_number"].toString(),
        name: row["name"],
        salePrice: row["sale_price"],
        costPrice: row["cost_price"],
        stock: row["stock"],
        unit: row["unit"],
        categoryName: row["category_name"],
        createdAt: DateTime.parse(row["created_at"]),
        imageUrl: row["image_url"],
        totalSold: row["total_sold"]);
  }

  Map<String, dynamic> toMapForForm() {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: 0,
    );
    return {
      'id': id,
      'business_id': businessId,
      'category_id': categoryId,
      'barcode_number': barcodeNumber,
      'name': name,
      'sale_price': formatter.format(salePrice),
      'cost_price': formatter.format(costPrice),
      'stock': stock == null ? "" : stock.toString(),
      'unit': unit,
      'created_at': createdAt.toIso8601String(),
      'image_url': imageUrl,
      'total_sold': totalSold.toString(),
      'category_name': categoryName
    };
  }
}
