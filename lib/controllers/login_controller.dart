import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  TextEditingController mobileController = TextEditingController();
  late String deviceId;
  var selectedOption = 'Phone'.obs;

  @override
  void onInit() {
    super.onInit();
    deviceId = Get.arguments['deviceId'];
    Logger().d('Received Device ID: $deviceId');
  }

  Future<void> sendOtp() async {
    final mobileNumber = mobileController.text;
    isLoading(true);

    const String apiUrl = 'http://devapiv4.dealsdray.com/api/v2/user/otp';
    final Map<String, String> requestBody = {"mobileNumber": mobileNumber, "deviceId": deviceId};
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    Logger().d('Request Body: ${jsonEncode(requestBody)}');
    Logger().d('Response Status: ${response.statusCode}, Body: ${response.body}');

    final responseBody = jsonDecode(response.body);
    if (responseBody['status'] == 1) {
      final message = responseBody['data']['message'];
      final userId = responseBody['data']['userId'];
      final receivedDeviceId = responseBody['data']['deviceId'];
      // Logger().d(responseBody['data']['message']);
      // Logger().d(responseBody['data']['UserId']);
      // Logger().d(responseBody['data']['deviceId']);
      Logger().d('OTP sent successfully: $message');
      isLoading(false);
      Get.toNamed(
        '/otp',
        arguments: {
          "userId": userId,
          "deviceId": receivedDeviceId,
        },
      );
    }
    Logger().d('Response Body: $responseBody');
    isLoading(false);
    return;
  }
}
