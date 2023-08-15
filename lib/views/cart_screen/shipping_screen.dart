import 'package:ecommerceapp/consts/consts.dart';
import 'package:ecommerceapp/controllers/cart_controller.dart';
import 'package:ecommerceapp/views/cart_screen/payment_screen.dart';
import 'package:ecommerceapp/widgets_common/Custom_textField.dart';
import 'package:ecommerceapp/widgets_common/our_button.dart';
import 'package:get/get.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: ourButton(
          onPress: () {
            if (controller.addressController.text.length > 10 &&
                controller.phoneController.text.length == 10 &&
                controller.postalCodeController.text.length == 6) {
              if (!(controller.postalCodeController.text == "147001" ||
                  controller.postalCodeController.text == "147002" ||
                  controller.postalCodeController.text == "147003")) {
                VxToast.show(context,
                    msg:
                        "Sry!! Your postal code area is currently not under delivery. U could check it soon...");
              } else if (controller.cityController.text
                      .toString()
                      .toLowerCase() !=
                  "patiala") {
                VxToast.show(context,
                    msg:
                        "Sry!! Your city is currently not under delivery. U could check it soon...");
              } else {
                Get.to(() => const PaymentMethods());
              }
            } else {
              VxToast.show(context, msg: "Please enter the correct details");
            }
          },
          color: redColor,
          textcolor: whiteColor,
          title: "Continue",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(
                hint: "Address",
                isPass: false,
                title: "Address",
                controller: controller.addressController),
            customTextField(
                hint: "City",
                isPass: false,
                title: "City",
                controller: controller.cityController),
            customTextField(
                hint: "State",
                isPass: false,
                title: "State",
                controller: controller.stateController),
            customTextField(
                hint: "Postal Code",
                isPass: false,
                title: "Postal Code",
                controller: controller.postalCodeController),
            customTextField(
                hint: "Phone",
                isPass: false,
                title: "Phone",
                controller: controller.phoneController),
          ],
        ),
      ),
    );
  }
}
