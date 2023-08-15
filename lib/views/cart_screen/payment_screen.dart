import 'package:ecommerceapp/consts/consts.dart';
import 'package:ecommerceapp/controllers/cart_controller.dart';
import 'package:ecommerceapp/views/cart_screen/cart_screen.dart';
import 'package:ecommerceapp/views/home_screen/home.dart';
import 'package:ecommerceapp/widgets_common/our_button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  var controller = Get.find<CartController>();
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_vzGWKa3mTEXRMs',
      'amount': controller.totalP.value * 100,
      'name': 'RationCart',
      'description': 'Fine t-shirt',
      'retry': {'enable': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    controller.placeMyOrder(totalAmount: controller.totalP.value);
    controller.clearCart();
    Get.offAll(const Home());
    Fluttertoast.showToast(
        msg: "SUCCESS" + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.offAll(const Home());
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () async {
            openCheckout();
            // var flag = false;
            // try {
            //   openCheckout();
            //   flag = true;
            // await controller.placeMyOrder(
            //     totalAmount: controller.totalP.value);
            // await controller.clearCart();
            // VxToast.show(context, msg: "Order placed succesfully");
            // Get.offAll(const Home());
            // } catch (e) {
            //   Get.offAll(const Home());
            // }
            // if (flag) {
            //   await controller.placeMyOrder(
            //       totalAmount: controller.totalP.value);
            //   await controller.clearCart();
            //   flag = false;
            //   Get.offAll(const Home());
            //   VxToast.show(context, msg: "Order placed succesfully");
            // }
          },
          color: redColor,
          textcolor: whiteColor,
          title: "Place My Order",
        ),
      ),
      appBar: AppBar(
        title: "Choose Payment Method"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "One step away from Placing Your Order..."
                .text
                .color(redColor)
                .size(16)
                .makeCentered(),
            "Click the below button "
                .text
                .color(redColor)
                .size(16)
                .makeCentered(),
            const Icon(
              Icons.arrow_downward_outlined,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}
