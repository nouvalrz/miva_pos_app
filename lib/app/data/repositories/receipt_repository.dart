import "package:intl/intl.dart";
import "package:miva_pos_app/app/data/models/receipt.dart";
import "package:miva_pos_app/app/data/models/receipt_additional_fee.dart";
import "package:miva_pos_app/app/data/models/receipt_discount.dart";
import "package:miva_pos_app/app/data/models/receipt_product.dart";
import "package:miva_pos_app/app/services/powersync_service.dart";

import "../models/schema.dart";

class ReceiptRepository {
  static const ORDER_BY_DATE_ASC = "ORDER BY created_at ASC";
  static const ORDER_BY_DATE_DESC = "ORDER BY created_at DESC";
  static const ORDER_BY_TOTAL_BILL_DESC = "ORDER BY total_bill DESC";
  static const ORDER_BY_TOTAL_BILL_ASC = "ORDER BY total_bill ASC";
  Future<Receipt> getReceipt({required String id}) async {
    final results =
        await db.get('SELECT * FROM $receiptsTable WHERE id = ?', [id]);
    return Receipt.fromRow(results);
  }

  Future<List<Receipt>> getAllReceiptFromDateRange({
    required businessId,
    required DateTime startDate,
    required DateTime endDate,
    String? searchKeyword,
    String orderQuery = ORDER_BY_DATE_DESC,
    int limit = 12,
    int offset = 0,
  }) async {
    List parameters = [];
    if (searchKeyword != null && searchKeyword.isNotEmpty) {
      parameters.add("%$searchKeyword%");
    }

    parameters.addAll([
      businessId,
      DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate.toUtc()),
      DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate.toUtc()),
    ]);

    parameters.add(limit);
    parameters.add(offset);

    final results = await db.getAll("""
          SELECT receipts.*, users.name as employee_name FROM $receiptsTable INNER JOIN $usersTable ON receipts.user_id = users.id
          WHERE 
          ${searchKeyword != null && searchKeyword.isNotEmpty ? ' receipts.receipt_number LIKE ? AND ' : ''}
          receipts.business_id = ? AND receipts.created_at BETWEEN ? AND ? 
          $orderQuery 
          LIMIT ? OFFSET ?
        """, parameters);

    return results.map((result) => Receipt.fromRow(result)).toList();
  }

  Future<int> getReceiptCountFromDateRange({
    required businessId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final result = await db.get(
        "SELECT COUNT(*) as receipt_count FROM $receiptsTable WHERE business_id = ? AND created_at BETWEEN ? AND ?",
        [
          businessId,
          DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate.toUtc()),
          DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate.toUtc()),
        ]);
    return result["receipt_count"] ?? 0;
  }

  Future<int> getTotalReceiptBillFromDateRange({
    required businessId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final result = await db.get(
        "SELECT SUM(total_bill) as total_receipt_bill FROM $receiptsTable WHERE business_id = ? AND  created_at BETWEEN ? AND ?",
        [
          businessId,
          DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate.toUtc()),
          DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate.toUtc()),
        ]);
    return result["total_receipt_bill"] ?? 0;
  }

  Future<int> getTotalReceiptProfitFromDateRange({
    required businessId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final result = await db.get(
        "SELECT SUM(total_profit) as total_receipt_profit FROM $receiptsTable WHERE business_id = ? AND  created_at BETWEEN ? AND ?",
        [
          businessId,
          DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate.toUtc()),
          DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate.toUtc()),
        ]);
    return result["total_receipt_profit"] ?? 0;
  }

  Future<int> getCountReceiptByReceiptNumber(
      {required String businessId, required String receiptNumber}) async {
    final results = await db.get(
        'SELECT COUNT(*) as count FROM $receiptsTable WHERE business_id = ? AND receipt_number = ?',
        [businessId, receiptNumber]);
    return results['count'];
  }

  Future<void> getAllReceiptProducts() async {
    final result = await db.getAll("SELECT * FROM $receiptProductsTable");
  }

  Future<Receipt> createReceipt(
      {required Receipt receipt,
      required List<ReceiptDiscount> receiptDiscounts,
      required List<ReceiptAdditionalFee> receiptAdditionalFees,
      required List<ReceiptProduct> receiptProducts,
      required String businessId,
      required String userId}) async {
    late Receipt finalReceipt;
    await db.writeTransaction((tx) async {
      // CREATE RECEIPT
      String createReceiptQuery = """
        INSERT INTO $receiptsTable
        (id, business_id, user_id, payment_method_id, receipt_number, total_product_price, total_bill, cash_given, cash_change, total_profit, is_archived, old_receipt_of, total_discount_price, total_additional_fee_price, 
        total_item, created_at)
        VALUES
        (uuid(),?,?,?,?,?,?,?,?,?,?,?,?,?,?,datetime())
        RETURNING *
      """;
      List<dynamic> parameters = [
        businessId,
        userId,
        receipt.paymentMethodId,
        receipt.receiptNumber,
        receipt.totalProductPrice,
        receipt.totalBill,
        receipt.cashGiven,
        receipt.cashChange,
        receipt.totalProfit,
        0,
        null,
        receipt.totalDiscountPrice,
        receipt.totalAdditionalFeePrice,
        receipt.totalItem
      ];
      final storedReceipt = await tx.execute(createReceiptQuery, parameters);
      finalReceipt = Receipt.fromRow(storedReceipt.first);
      // storedReceipt.first["id"].toString();

      // discounts
      for (var i = 0; i < receiptDiscounts.length; i++) {
        var discountQuery = """
          INSERT INTO
          $receiptDiscountsTable
          (id, business_id, receipt_id, name, amount, created_at)
          VALUES
          (uuid(), ?, ?, ?, ?, datetime())
        """;
        var discountParameters = [
          businessId,
          storedReceipt.first["id"].toString(),
          receiptDiscounts[i].name,
          receiptDiscounts[i].amount,
        ];
        await tx.execute(discountQuery, discountParameters);
      }

      // additional fees
      for (var j = 0; j < receiptAdditionalFees.length; j++) {
        var additionalFeeQuery = """
          INSERT INTO
          $receiptAdditionalFeesTable
          (id, business_id, receipt_id, name, amount, created_at)
          VALUES
          (uuid(), ?, ?, ?, ?, datetime())
        """;
        var additionalFeeParameters = [
          businessId,
          storedReceipt.first["id"].toString(),
          receiptAdditionalFees[j].name,
          receiptAdditionalFees[j].amount,
        ];
        await tx.execute(additionalFeeQuery, additionalFeeParameters);
      }

      // products
      for (var k = 0; k < receiptProducts.length; k++) {
        var productQuery = """
          INSERT INTO
          $receiptProductsTable
          (id, business_id, receipt_id, product_id, product_cost_price, product_sale_price, quantity, product_name, created_at)
          VALUES
          (uuid(), ?, ?, ?, ?, ?,?,?, datetime())
        """;
        var productParameters = [
          businessId,
          storedReceipt.first["id"].toString(),
          receiptProducts[k].productId,
          receiptProducts[k].productCostPrice,
          receiptProducts[k].productSalePrice,
          receiptProducts[k].quantity,
          receiptProducts[k].productName
        ];
        await tx.execute(productQuery, productParameters);
      }
    });
    // await getAllReceiptProducts();
    return finalReceipt;
  }
}
