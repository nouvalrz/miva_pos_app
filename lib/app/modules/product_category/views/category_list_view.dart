import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CategoryListView extends GetView {
  const CategoryListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CategoryListView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CategoryListView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
