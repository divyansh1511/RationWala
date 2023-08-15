import 'package:ecommerceapp/consts/colors.dart';
import 'package:ecommerceapp/consts/consts.dart';
import 'package:ecommerceapp/views/auth_screen/login_screen.dart';
import 'package:ecommerceapp/views/home_screen/home.dart';
import 'package:ecommerceapp/widgets_common/applogo_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //method to change screen

  changeScreen() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        // Get.to(() => const LoginScreen());
        auth.authStateChanges().listen((User? user) {
          if (user == null && mounted) {
            Get.to(() => const LoginScreen());
          } else {
            Get.to(() => const Home());
          }
        });
      },
    );
  }

  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      body: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                icSplashBg,
                width: 300,
              ),
            ),
            20.heightBox,
            applogoWidget(),
            10.heightBox,
            appname.text.fontFamily(bold).size(22).white.make(),
            5.heightBox,
            appversion.text.white.make(),
            Spacer(),
            credits.text.white.fontFamily(semibold).make(),
            30.heightBox,
          ],
        ),
      ),
    );
  }
}
