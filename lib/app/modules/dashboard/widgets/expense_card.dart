import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:miva_pos_app/app/data/models/expense.dart';
import 'package:miva_pos_app/app/data/models/receipt.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    super.key,
    required this.expense,
  });

  final Expense expense;

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
                  "Pengeluaran #${expense.id}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  DateFormat('HH:mm - dd MMM')
                      .format(expense.createdAt.toLocal()),
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            const Gap(4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  expense.name,
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  "+Rp. ${expense.amount}",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 187, 39, 39), fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
