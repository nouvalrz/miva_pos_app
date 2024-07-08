import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Positioned(
        top: -250,
        left: -250,
        child: Container(
          width: 500,
          height: 500,
          decoration: BoxDecoration(
              gradient: RadialGradient(
            colors: [
              const Color(0x009e8ff0).withAlpha(100),
              const Color(0x009e8ff0)
            ],
            stops: const [0.2, 0.8],
            center: Alignment.center,
          )),
        ),
      ),
      Positioned(
        bottom: -250,
        right: -250,
        child: Container(
          width: 500,
          height: 500,
          decoration: BoxDecoration(
              gradient: RadialGradient(
            colors: [
              const Color(0x00faf69b).withAlpha(100),
              const Color(0x00faf69b)
            ],
            stops: const [0.2, 0.8],
            center: Alignment.center,
          )),
        ),
      ),
      Center(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                'assets/images/miva-pos-logo.svg',
                width: 200,
                height: 200,
              ),
              SizedBox(
                width: 300,
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Masuk Akun",
                        style: TextStyle(fontSize: 22),
                      ),
                      const Gap(25),
                      TextFormField(
                        controller: controller.emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please input your email';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "Email", border: OutlineInputBorder()),
                      ),
                      const Gap(15),
                      TextFormField(
                        controller: controller.passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please input your password';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "Password", border: OutlineInputBorder()),
                      ),
                      const Gap(40),
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                              onPressed: () => {
                                    controller.login(),
                                  },
                              child: controller.isLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text("Login")),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]));
  }
}
