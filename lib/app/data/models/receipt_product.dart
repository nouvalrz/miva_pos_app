import 'package:powersync/sqlite3.dart' as Sqlite;

class ReceiptProduct {
  final String id;
  final String receiptId;
  final String productId;
  final int productCostPrice;
  final int productSalePrice;
  final int quantity;
  final DateTime createdAt;
  final String businessId;
  final String productName;

  ReceiptProduct({
    required this.id,
    required this.receiptId,
    required this.productId,
    required this.productCostPrice,
    required this.productSalePrice,
    required this.quantity,
    required this.createdAt,
    required this.businessId,
    required this.productName,
  });

  factory ReceiptProduct.fromRow(Sqlite.Row row) {
    return ReceiptProduct(
      id: row["id"],
      receiptId: row["receipt_id"],
      productId: row["product_id"],
      productCostPrice: row["product_cost_price"],
      productSalePrice: row["product_sale_price"],
      quantity: row["quantity"],
      createdAt: DateTime.parse(row["created_at"]),
      businessId: row["business_id"],
      productName: row["product_name"],
    );
  }
}
