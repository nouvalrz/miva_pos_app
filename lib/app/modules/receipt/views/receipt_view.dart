import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/receipt_controller.dart';

class ReceiptView extends GetView<ReceiptController> {
  const ReceiptView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReceiptView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ReceiptView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
