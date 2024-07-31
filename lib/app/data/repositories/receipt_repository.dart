import "package:miva_pos_app/app/data/models/receipt.dart";
import "package:miva_pos_app/app/data/models/receipt_additional_fee.dart";
import "package:miva_pos_app/app/data/models/receipt_discount.dart";
import "package:miva_pos_app/app/data/models/receipt_product.dart";
import "package:miva_pos_app/app/services/powersync_service.dart";

import "../models/schema.dart";

class ReceiptRepository {
  Future<Receipt> getReceipt({required String id}) async {
    final results =
        await db.get('SELECT * FROM $receiptsTable WHERE id = ?', [id]);
    return Receipt.fromRow(results);
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
    print("MANTAPP");
    print("MANTAPP");
    print("MANTAPP");
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
        (id, business_id, user_id, payment_method_id, receipt_number, total_product_price, total_bill, cash_given, cash_change, total_profit, is_archived, old_receipt_of, total_discount_price, total_additional_fee_price, created_at)
        VALUES
        (uuid(),?,?,?,?,?,?,?,?,?,?,?,?,?,datetime())
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
        receipt.totalAdditionalFeePrice
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
          (id, business_id, receipt_id, product_id, product_cost_price, product_sale_price, quantity, created_at)
          VALUES
          (uuid(), ?, ?, ?, ?, ?,?, datetime())
        """;
        var productParameters = [
          businessId,
          storedReceipt.first["id"].toString(),
          receiptProducts[k].productId,
          receiptProducts[k].productCostPrice,
          receiptProducts[k].productSalePrice,
          receiptProducts[k].quantity
        ];
        await tx.execute(productQuery, productParameters);
      }
    });
    // await getAllReceiptProducts();
    return finalReceipt;
  }
}
