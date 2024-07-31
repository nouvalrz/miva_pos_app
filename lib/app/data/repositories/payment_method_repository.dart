// ignore_for_file: constant_identifier_names

import "package:miva_pos_app/app/data/models/category.dart";
import "package:miva_pos_app/app/data/models/payment_method.dart";
import "package:miva_pos_app/app/services/powersync_service.dart";

import "../models/schema.dart";

class PaymentMethodRepository {
  Future<PaymentMethod> getPaymentMethod({required String id}) async {
    final results =
        await db.get('SELECT * FROM $paymentMethodsTable WHERE id = ?', [id]);
    return PaymentMethod.fromRow(results);
  }

  Future<List<PaymentMethod>> getAllPaymentMethods(
      {required String businessId}) async {
    final results = await db.getAll(
        "SELECT * FROM $paymentMethodsTable WHERE business_id = ?",
        [businessId]);
    return results.map((result) => PaymentMethod.fromRow(result)).toList();
  }
}
