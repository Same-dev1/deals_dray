import 'package:app/bindings/home_binding.dart';
import 'package:app/bindings/login_binding.dart';
import 'package:app/bindings/register_bindig.dart';
import 'package:app/bindings/splash_binding.dart';
import 'package:app/views/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/otp_binding.dart';
import 'views/splash_screen.dart';
import 'views/login_screen.dart';
import 'views/otp_screen.dart';
import 'views/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DealsDray',
      initialRoute: '/register',
      initialBinding: SplashBinding(),
      theme: ThemeData(
        useMaterial3: false,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 10,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(color: Colors.red),
          unselectedLabelStyle: TextStyle(color: Colors.grey),
          showUnselectedLabels: true,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      getPages: [
        GetPage(
          name: '/splash',
          page: () => SplashScreen(),
          binding: SplashBinding(),
        ),
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: '/otp',
          page: () => OtpScreen(),
          binding: OtpBinding(),
        ),
        GetPage(
            name: '/register',
            page: () => RegisterScreen(),
            binding: RegisterBinding()),
        GetPage(
          name: '/home',
          page: () => HomeScreen(),
          binding: HomeBinding(),
        ),
      ],
    );
  }
}
