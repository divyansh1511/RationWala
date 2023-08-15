import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/consts/consts.dart';
import 'package:ecommerceapp/controllers/cart_controller.dart';
import 'package:ecommerceapp/services/firestore_services.dart';
import 'package:ecommerceapp/views/cart_screen/shipping_screen.dart';
import 'package:ecommerceapp/widgets_common/our_button.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());

    return Scaffold(
      // bottomNavigationBar: SizedBox(
      //   height: 50,
      //   child: ourButton(
      //     color: redColor,
      //     onPress: () {
      //       Get.to(() => const ShippingDetails());
      //     },
      //     textcolor: whiteColor,
      //     title: "Proceed to shipping",
      //   ),
      // ),
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        title: "Shopping Cart"
            .text
            .color(darkFontGrey)
            .fontFamily(semibold)
            .make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getCart(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "Cart is Empty".text.color(darkFontGrey).make(),
            );
          } else {
            var data = snapshot.data!.docs;
            controller.calculate(data);
            controller.productsnapshot = data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Image.network("${data[index]['img']}"),
                          title:
                              "${data[index]['title']} (x${data[index]['qty']})"
                                  .text
                                  .fontFamily(semibold)
                                  .size(16)
                                  .make(),
                          // subtitle: "${data[index]['tprice']}"
                          //     .numCurrency
                          //     .text
                          //     .size(14)
                          //     .color(redColor)
                          //     .fontFamily(semibold)
                          //     .make(),
                          subtitle: Row(
                            children: [
                              "\u{20B9}"
                                  .text
                                  .color(redColor)
                                  .bold
                                  .size(14)
                                  .make(),
                              2.widthBox,
                              "${data[index]['tprice']}"
                                  .numCurrency
                                  .text
                                  .color(redColor)
                                  .fontFamily(bold)
                                  .size(14)
                                  .make(),
                            ],
                          ),
                          trailing: const Icon(Icons.delete, color: redColor)
                              .onTap(() {
                            FirestoreServices.deleteDocument(data[index].id);
                          }),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Total Price"
                          .text
                          .fontFamily(semibold)
                          .color(darkFontGrey)
                          .make(),
                      Obx(
                        () => Row(
                          children: [
                            "\u{20B9}"
                                .text
                                .color(redColor)
                                .bold
                                .size(16)
                                .make(),
                            2.widthBox,
                            "${controller.totalP.value}"
                                .numCurrency
                                .text
                                .color(redColor)
                                .fontFamily(bold)
                                .size(16)
                                .make(),
                          ],
                        ),
                      ),
                    ],
                  )
                      .box
                      .padding(const EdgeInsets.all(12))
                      .color(lightGrey)
                      .roundedSM
                      .make(),
                  10.heightBox,
                  SizedBox(
                    width: context.screenWidth - 60,
                    child: ourButton(
                      color: redColor,
                      onPress: () {
                        Get.to(() => const ShippingDetails());
                      },
                      textcolor: whiteColor,
                      title: "Proceed to shipping",
                    ),
                  ),
                  20.heightBox,
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
