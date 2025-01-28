import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final referralCodeController = TextEditingController();
  var isLoading = false.obs;


  late final String userId;

  @override
  void onInit() {
    super.onInit();
    userId = Get.arguments?['userId'] ?? '';
  }

  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;
    final referralCode = referralCodeController.text;
    isLoading(true);

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email and Password are required');
      return;
    }

    final payload = {
      "email": email,
      "password": password,
      "referralCode": referralCode.isNotEmpty ? int.tryParse(referralCode) : null,
      "userId": userId,
    };

      final response = await http.post(
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/email/referral'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

    final responseBody = jsonDecode(response.body);
      if (responseBody['Status'] == 0) {
        Get.snackbar('Success', 'Logged in successfully');
        Logger().d('Response: $responseBody');
        isLoading(false);
      }
    Logger().d('Response Body: $responseBody');
    isLoading(false);
    return;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    referralCodeController.dispose();
    super.onClose();
  }
}
