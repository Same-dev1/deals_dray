import 'package:app/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends GetView<OtpController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                height: 200,
                child: Image.asset('assets/otp.png', fit: BoxFit.cover)),
            Text('OTP Verification',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Text('We have sent a unique OTP to your registered mobile number',
                style: TextStyle(fontSize: 20, color: Colors.grey.shade700)),
            SizedBox(height: 20),
            Pinput(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                length: 4,
                controller: controller.otpController,
                defaultPinTheme: PinTheme(
                    width: 50,
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 2, color: Colors.grey.shade600)))),
            SizedBox(height: 20),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(controller.timerText.value),
                  TextButton(
                    onPressed: controller.isButtonDisabled.value
                        ? null
                        : () {
                            controller.verifyOtp(controller.otpController.text);
                            controller.resetTimer();
                          },
                    child: const Text('SEND AGAIN'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
