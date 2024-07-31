import "package:miva_pos_app/app/data/models/expense.dart";
import "package:miva_pos_app/app/data/models/receipt.dart";
import "package:miva_pos_app/app/data/models/schema.dart";
import "package:miva_pos_app/app/services/powersync_service.dart";
import "package:rxdart/streams.dart";

class TransactionRepository {
  Stream<List<dynamic>> watchTodayTransactions(String businessId) {
    final receiptsStream = db.watch('''
    SELECT $receiptsTable.*, (SELECT $productsTable.name FROM $productsTable LEFT JOIN $receiptProductsTable ON products.id = $receiptProductsTable.product_id WHERE $receiptProductsTable.receipt_id = $receiptsTable.id LIMIT 1) as first_product_name, (SELECT COUNT(DISTINCT $receiptProductsTable.product_id)) as products_count FROM $receiptsTable INNER JOIN $receiptProductsTable ON $receiptsTable.id = $receiptProductsTable.receipt_id WHERE $receiptsTable.business_id = ? AND DATE($receiptsTable.created_at) = DATE('now') GROUP BY $receiptsTable.id;
    ''', parameters: [businessId]).map((results) {
      return results.map((result) => Receipt.fromRow(result)).toList();
    });

    final expenseStream = db.watch('''
    SELECT * FROM $expensesTable WHERE business_id = ? AND DATE(created_at) = DATE('now')
    ''', parameters: [businessId]).map((results) {
      return results.map((result) => Expense.fromRow(result)).toList();
    });

    return CombineLatestStream.list([receiptsStream, expenseStream])
        .map((lists) {
      List<dynamic> transactions = [];
      transactions.addAll(lists[0] as List<Receipt>);
      transactions.addAll(lists[1] as List<Expense>);
      transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return transactions;
    });
  }
}
