import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ProductListView extends GetView {
  const ProductListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProductListView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProductListView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
