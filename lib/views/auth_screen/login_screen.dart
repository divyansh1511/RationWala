import 'package:ecommerceapp/consts/consts.dart';
import 'package:ecommerceapp/controllers/auth_controller.dart';
import 'package:ecommerceapp/views/auth_screen/forgot_password_screen.dart';
import 'package:ecommerceapp/views/auth_screen/signup_screen.dart';
import 'package:ecommerceapp/views/home_screen/home.dart';
import 'package:ecommerceapp/widgets_common/Custom_textField.dart';
import 'package:ecommerceapp/widgets_common/applogo_widget.dart';
import 'package:ecommerceapp/widgets_common/bg_widget.dart';
import 'package:ecommerceapp/widgets_common/our_button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const List<String> socialIconList = [
    icGoogleLogo,
    icFacebookLogo,
    icTwitterLogo
  ];
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            15.heightBox,
            "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
            15.heightBox,
            Obx(
              () => Column(
                children: [
                  customTextField(
                      hint: emailHint,
                      title: email,
                      isPass: false,
                      controller: controller.emailController),
                  customTextField(
                      hint: passwordHint,
                      title: password,
                      isPass: true,
                      controller: controller.passwordController),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          Get.to(() => const ForgotPasswordScreen());
                        },
                        child: forgetPass.text.make()),
                  ),
                  5.heightBox,
                  // ourButton().box.width(context.screenWidth - 50).make(),
                  controller.isloading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        )
                      : ourButton(
                          color: redColor,
                          title: login,
                          textcolor: whiteColor,
                          onPress: () async {
                            controller.isloading(true);
                            await controller
                                .loginMethod(context: context)
                                .then((value) {
                              if (value != null) {
                                VxToast.show(context, msg: loggedIn);
                                Get.offAll(() => const Home());
                              } else {
                                controller.isloading(false);
                              }
                            });
                          }).box.width(context.screenWidth - 50).make(),
                  5.heightBox,
                  createnewAccount.text.color(fontGrey).make(),
                  5.heightBox,
                  ourButton(
                      color: lightGrey,
                      title: signup,
                      textcolor: redColor,
                      onPress: () {
                        Get.to(() => SignupScreen());
                      }).box.width(context.screenWidth - 50).make(),
                  // 10.heightBox,
                  // loginWith.text.color(fontGrey).make(),
                  // 5.heightBox,
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: List.generate(
                  //     3,
                  //     (index) => Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: CircleAvatar(
                  //           backgroundColor: lightGrey,
                  //           radius: 25,
                  //           child: Image.asset(
                  //             socialIconList[index],
                  //             width: 30,
                  //           ),
                  //         )),
                  //   ),
                  // ),
                ],
              )
                  .box
                  .white
                  .rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadowSm
                  .make(),
            ),
          ],
        ),
      ),
    ));
  }
}
