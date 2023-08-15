import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/consts/consts.dart';
import 'package:ecommerceapp/controllers/home_controller.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var totalP = 0.obs;

  //shippin getails

  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalCodeController = TextEditingController();
  var phoneController = TextEditingController();

  late dynamic productsnapshot;
  var products = [];

  calculate(data) {
    totalP.value = 0;
    for (int i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  placeMyOrder({required totalAmount}) async {
    await getProductDetails();

    await firestore.collection(ordersCollection).doc().set({
      'order_code': Random().nextInt(100000000).toString(),
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      // 'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_state': stateController.text,
      'order_by_city': cityController.text,
      'order_by_phone': phoneController.text,
      'order_by_postalcode': postalCodeController.text,
      'shipping_method': "Home Delivery",
      'order_placed': true,
      'order_confirmed': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products)
    });
  }

  getProductDetails() {
    products.clear();
    for (int i = 0; i < productsnapshot.length; i++) {
      products.add({
        'img': productsnapshot[i]['img'],
        'qty': productsnapshot[i]['qty'],
        'title': productsnapshot[i]['title'],
        'tprice': productsnapshot[i]['tprice'],
      });
    }
  }

  clearCart() {
    for (var i = 0; i < productsnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productsnapshot[i].id).delete();
    }
  }
}
