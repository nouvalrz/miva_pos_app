import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/miva-pos-logo-splash.svg',
                width: 300,
                height: 300,
                color: const Color(0xFF40228C),
              ),
              const Gap(10),
              const CircularProgressIndicator(color: Color(0xFF40228C)),
            ],
          )),
        ],
      ),
    );
  }
}
