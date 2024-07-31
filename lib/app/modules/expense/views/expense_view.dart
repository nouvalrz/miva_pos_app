import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/expense_controller.dart';

class ExpenseView extends GetView<ExpenseController> {
  const ExpenseView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExpenseView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ExpenseView is working',
          style: TextStyle(fontFamily: "Inter", fontSize: 20),
        ),
      ),
    );
  }
}
