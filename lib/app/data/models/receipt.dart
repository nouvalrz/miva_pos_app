import 'package:powersync/sqlite3.dart' as Sqlite;

class Receipt {
  final String id;
  final String businessId;
  final String userId;
  final String paymentMethodId;
  final String receiptNumber;
  final int totalPrice;
  final int totalBill;
  final int cashGiven;
  final int cashChange;
  final int totalProfit;
  final DateTime createdAt;
  final String? firstProductName;
  final int? productsCount;

  Receipt(
      {required this.id,
      required this.businessId,
      required this.userId,
      required this.paymentMethodId,
      required this.receiptNumber,
      required this.totalPrice,
      required this.totalBill,
      required this.cashGiven,
      required this.cashChange,
      required this.totalProfit,
      required this.createdAt,
      required this.firstProductName,
      required this.productsCount});

  factory Receipt.fromRow(Sqlite.Row row) {
    return Receipt(
        id: row["id"],
        businessId: row["business_id"].toString(),
        userId: row["user_id"].toString(),
        paymentMethodId: row["payment_method_id"].toString(),
        receiptNumber: row["receipt_number"],
        totalPrice: row["total_price"],
        totalBill: row["total_bill"],
        cashGiven: row["cash_given"],
        cashChange: row["cash_change"],
        totalProfit: row["total_profit"],
        createdAt: DateTime.parse(row["created_at"] + "Z"),
        firstProductName: row["first_product_name"],
        productsCount: row["products_count"]);
  }
}
