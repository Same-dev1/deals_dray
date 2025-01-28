import 'package:app/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView<SplashController> {

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Obx(() => controller.isLoading.value
          ? Column(
        children: [
          Expanded(
            child: Image.asset(
              'assets/splash.png',
              fit: BoxFit.cover,
            ),
          ),
              ],
      )
          : Center(
        child: Text('Welcome to DealsDray'),
      )),
    );
  }
}