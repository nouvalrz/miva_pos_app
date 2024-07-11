import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final supabaseClient = Supabase.instance.client;

  Rx<bool> isLoading = false.obs;

  Future<void> login() async {
    isLoading.value = true;
    if (formKey.currentState?.validate() ?? false) {
      try {
        await supabaseClient.auth.signInWithPassword(
            password: passwordController.text, email: emailController.text);
        Get.snackbar("Login Success",
            "Welcome ${supabaseClient.auth.currentUser!.email!}");
        Get.offAllNamed('/splash');
      } catch (e) {
        Get.snackbar("Login Error", e.toString());
      }
    }
    isLoading.value = false;
  }
}
