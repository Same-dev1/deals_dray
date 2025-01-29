import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

class OtpController extends GetxController {
  var isLoading = false.obs;
  var timerText = '02:00'.obs;
  var isButtonDisabled = true.obs;
  int timerSeconds = 120;
  late RxInt remainingSeconds;
  final TextEditingController otpController = TextEditingController();
  late String deviceId;
  late String userId;

  @override
  void onInit() {
    super.onInit();
    deviceId = Get.arguments['deviceId'];
    userId = Get.arguments['userId'];
    startTimer();
  }

  Future<void> verifyOtp(String otp) async {
    isLoading(true);
    try {
      final requestBody = {
        "otp": otp,
        "deviceId": deviceId,
        "userId": userId,
      };
      Logger()
          .d('Sending OTP verification request: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp/verification'),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      Logger()
          .d('OTP verification response status code: ${response.statusCode}');
      Logger().d('OTP verification response body: ${response.body}');

      if (response.statusCode == 200) {
        isLoading(false);
        final responseData = jsonDecode(response.body);

        if (responseData['isExistingUser'] == true) {
          Logger().d('User is existing. Navigating to home screen.');
          Get.offNamed('/home');
        } else {
          Logger().d(
              'User is new. Navigating to register screen with userId: $userId');
          Get.offNamed('/register', arguments: {'userId': userId});
        }
      } else {
        Logger().d('Failed to verify OTP. Status code: ${response.statusCode}');
        throw Exception('Failed to verify OTP');
      }
    } catch (e) {
      isLoading(false);
      Logger().d('Error during OTP verification: $e');
      Get.snackbar('Error', e.toString());
    }
  }

  OtpController() {
    remainingSeconds = timerSeconds.obs;
  }

  void resetTimer() {
    startTimer();
  }

  void startTimer() {
    isButtonDisabled.value = true;
    remainingSeconds.value = timerSeconds;

    ever(remainingSeconds, (int seconds) {
      if (seconds > 0) {
        timerText.value = formatTime(seconds);
      } else {
        isButtonDisabled.value = false;
        timerText.value = '00:00';
      }
    });

    for (int i = 1; i <= timerSeconds; i++) {
      Future.delayed(Duration(seconds: i), () {
        remainingSeconds.value--;
      });
    }
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}
