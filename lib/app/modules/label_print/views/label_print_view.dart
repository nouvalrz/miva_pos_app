import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/label_print_controller.dart';

class LabelPrintView extends GetView<LabelPrintController> {
  const LabelPrintView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LabelPrintView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LabelPrintView is working',
          style: TextStyle(fontFamily: "Inter", fontSize: 20),
        ),
      ),
    );
  }
}
