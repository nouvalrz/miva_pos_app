import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:miva_pos_app/app/data/models/receipt.dart';

class ReceiptCard extends StatelessWidget {
  const ReceiptCard({
    super.key,
    required this.receipt,
  });

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Struk ${receipt.receiptNumber}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  DateFormat('HH:mm - dd MMM')
                      .format(receipt.createdAt.toLocal()),
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            const Gap(4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  receipt.firstProductName! +
                      (receipt.productsCount! > 1
                          ? " dan ${receipt.productsCount! - 1} lainnya"
                          : ""),
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  "+Rp. ${receipt.totalBill}",
                  style: const TextStyle(color: Colors.green, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
