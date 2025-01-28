import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

class SplashController extends GetxController {
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _startDelay();
    handleLocationPermission();
  }

  void _startDelay() async {
    await Future.delayed(Duration(milliseconds: 100));
    fetchDeviceInfo();
  }

  Future<void> fetchDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      String? deviceId;
      String? deviceName;
      String? deviceOSVersion;

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
        deviceName = androidInfo.model;
        deviceOSVersion = androidInfo.version.release;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
        deviceName = iosInfo.utsname.machine;
        deviceOSVersion = iosInfo.systemVersion;
      }

      if (deviceId == null) {
        throw Exception('Failed to get device ID');
      }
      Logger().d('Device ID: $deviceId');
      Logger().d('Device Name: $deviceName');
      Logger().d('Device OS Version: $deviceOSVersion');
      Logger().d('Install Timestamp: ${DateTime.now().toIso8601String()}');
      Logger().d('Uninstall Timestamp: ${DateTime.now().toIso8601String()}');
      Logger().d('Download Timestamp: ${DateTime.now().toIso8601String()}');

      final ipAddress = await getIPAddress();
      final latitude = await getCurrentLatitude();
      final longitude = await getCurrentLongitude();
      final response = await http.post(
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/device/add'),
        body: jsonEncode({
          "deviceType": Platform.isAndroid ? "android" : "ios",
          "deviceId": deviceId,
          "deviceName": deviceName,
          "deviceOSVersion": deviceOSVersion,
          "deviceIPAddress": ipAddress,
          "lat": latitude,
          "long": longitude,
          "buyer_gcmid": "",
          "buyer_pemid": "",
          "app": {
            "version": "1.0.0",
            "installTimeStamp": DateTime.now().toIso8601String(),
            "uninstallTimeStamp": DateTime.now().toIso8601String(),
            "downloadTimeStamp": DateTime.now().toIso8601String()
          }
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        isLoading(false);
        Get.offNamed('/login',
            arguments: {'deviceId': json['data']['deviceId']});
      } else {
        throw Exception('Failed to load device info');
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', e.toString());
      Logger().d(e.toString());
    }
  }

  Future<String?> getIPAddress() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4) {
            Logger().d('IP Address: ${addr.address}');
          }
        }
      }
    } catch (e) {
      Logger().d('Failed to get IP address: $e');
    }
    return null;
  }

  Future<bool> handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return false;
    }

    return true;
  }

  Future<double?> getCurrentLongitude() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      Logger().d('Longitude: ${position.longitude}');
      return position.longitude;
    } catch (e) {
      Logger().d('Error getting longitude: $e');
      return null;
    }
  }

  Future<double?> getCurrentLatitude() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      Logger().d('Latitude: ${position.latitude}');
      return position.latitude;
    } catch (e) {
      Logger().d('Error getting latitude: $e');
      return null;
    }
  }
}
