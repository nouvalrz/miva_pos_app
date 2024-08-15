import 'package:powersync/sqlite3.dart' as Sqlite;

class Receipt {
  final String id;
  final String businessId;
  final String userId;
  final String paymentMethodId;
  final String receiptNumber;
  final int totalProductPrice;
  final int totalDiscountPrice;
  final int totalAdditionalFeePrice;
  final int totalBill;
  final int cashGiven;
  final int cashChange;
  final int totalProfit;
  final int totalItem;
  final DateTime createdAt;
  String? firstProductName = "";
  String? employeeName = "";
  final int? productsCount;

  Receipt(
      {required this.id,
      required this.businessId,
      required this.userId,
      required this.paymentMethodId,
      required this.receiptNumber,
      required this.totalProductPrice,
      required this.totalDiscountPrice,
      required this.totalAdditionalFeePrice,
      required this.totalBill,
      required this.cashGiven,
      required this.cashChange,
      required this.totalProfit,
      required this.createdAt,
      required this.firstProductName,
      required this.employeeName,
      required this.totalItem,
      required this.productsCount});

  factory Receipt.fromRow(Sqlite.Row row) {
    return Receipt(
        id: row["id"],
        businessId: row["business_id"].toString(),
        userId: row["user_id"].toString(),
        paymentMethodId: row["payment_method_id"].toString(),
        receiptNumber: row["receipt_number"],
        totalProductPrice: row["total_product_price"],
        totalDiscountPrice: row["total_discount_price"],
        totalAdditionalFeePrice: row["total_additional_fee_price"],
        totalBill: row["total_bill"],
        cashGiven: row["cash_given"],
        cashChange: row["cash_change"],
        totalItem: row["total_item"],
        totalProfit: row["total_profit"],
        createdAt: DateTime.parse(row["created_at"].toString().endsWith("Z")
            ? row["created_at"].toString()
            : "${row["created_at"]}Z"),
        firstProductName: row["first_product_name"],
        employeeName: row["employee_name"],
        productsCount: row["products_count"]);
  }
}
