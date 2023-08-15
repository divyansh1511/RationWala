import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/consts/consts.dart';
import 'package:ecommerceapp/controllers/product_controller.dart';
import 'package:ecommerceapp/widgets_common/our_button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../services/firestore_services.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({
    Key? key,
    required this.title,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();
    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: IconButton(
              onPressed: () {
                controller.resetValues();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back)),
          title: title!.text.color(darkFontGrey).fontFamily(semibold).make(),
          actions: [
            Obx(
              () => IconButton(
                  onPressed: () {
                    if (controller.isFav.value) {
                      controller.removeFromWishlist(data.id, context);
                    } else {
                      controller.addToWishlist(data.id, context);
                    }
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: controller.isFav.value ? redColor : darkFontGrey,
                  )),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VxSwiper.builder(
                          autoPlay: true,
                          height: 350,
                          itemCount: data['p_imgs'].length,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1.0,
                          itemBuilder: (context, index) {
                            return Image.network(
                              data['p_imgs'][index],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        10.heightBox,
                        title!.text
                            .size(16)
                            .color(darkFontGrey)
                            .fontFamily(semibold)
                            .make(),
                        10.heightBox,
                        VxRating(
                          isSelectable: false,
                          value: double.parse(data['p_rating']),
                          onRatingUpdate: (value) {},
                          normalColor: textfieldGrey,
                          selectionColor: golden,
                          maxRating: 5,
                          size: 25,
                        ),
                        10.heightBox,
                        Row(
                          children: [
                            "\u{20B9}"
                                .text
                                .color(redColor)
                                .size(16)
                                .bold
                                .make(),
                            2.widthBox,
                            "${data['p_price']}"
                                .numCurrency
                                .text
                                .color(redColor)
                                .fontFamily(bold)
                                .size(18)
                                .make(),
                          ],
                        ),
                        10.heightBox,
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "Seller"
                                      .text
                                      .white
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                                  5.heightBox,
                                  "In house brand"
                                      .text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .size(16)
                                      .make(),
                                ],
                              ),
                            ),
                            const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.message_rounded,
                                color: darkFontGrey,
                              ),
                            ),
                          ],
                        )
                            .box
                            .height(70)
                            .padding(const EdgeInsets.symmetric(horizontal: 16))
                            .color(textfieldGrey)
                            .make(),
                        20.heightBox,
                        Obx(
                          () => Column(
                            children: [
                              // Row(
                              //   children: [
                              //     SizedBox(
                              //       width: 100,
                              //       child: "Color: ".text.color(textfieldGrey).make(),
                              //     ),
                              //     Row(
                              //       children: List.generate(
                              //         3,
                              //         (index) => VxBox()
                              //             .size(40, 40)
                              //             .roundedFull
                              //             .color(Vx.randomPrimaryColor)
                              //             .margin(const EdgeInsets.symmetric(
                              //                 horizontal: 4))
                              //             .make(),
                              //       ),
                              //     ),
                              //   ],
                              // ).box.white.shadowSm.make(),

                              // quantity
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: "Quantity: "
                                        .text
                                        .color(darkFontGrey)
                                        .make(),
                                  ),
                                  Obx(
                                    () => Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              controller.decreaseQuantity();
                                              controller.calculateTotalPrice(
                                                  int.parse(data['p_price']));
                                            },
                                            icon: const Icon(Icons.remove)),
                                        controller.quantity.value.text
                                            .size(16)
                                            .color(darkFontGrey)
                                            .fontFamily(bold)
                                            .make(),
                                        IconButton(
                                          onPressed: () {
                                            controller.increaseQuantity(
                                                int.parse(data['p_quantity']));
                                            controller.calculateTotalPrice(
                                                int.parse(data['p_price']));
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                        6.widthBox,
                                        "(${data['p_quantity']} Max Selection)"
                                            .text
                                            .color(textfieldGrey)
                                            .make(),
                                      ],
                                    ),
                                  ),
                                ],
                              ).box.white.shadowSm.make(),
                              10.heightBox,
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: "Total: "
                                        .text
                                        .color(textfieldGrey)
                                        .make(),
                                  ),
                                  "${controller.totalPrice.value}"
                                      .numCurrency
                                      .text
                                      .color(redColor)
                                      .size(16)
                                      .fontFamily(bold)
                                      .make(),
                                ],
                              ).box.padding(const EdgeInsets.all(8)).make(),
                            ],
                          ).box.white.shadowSm.make(),
                        ),
                        10.heightBox,
                        "Description"
                            .text
                            .color(darkFontGrey)
                            .fontFamily(semibold)
                            .make(),
                        10.heightBox,
                        "${data['p_desc']}".text.color(darkFontGrey).make(),
                        20.heightBox,
                        productsyoumaylike.text
                            .fontFamily(bold)
                            .size(16)
                            .color(darkFontGrey)
                            .make(),
                        10.heightBox,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder(
                              future: FirestoreServices.getExtraProduct(
                                  data['p_category']),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(redColor),
                                  ));
                                } else if (snapshot.data!.docs.isEmpty) {
                                  return "No Featured Products"
                                      .text
                                      .white
                                      .makeCentered();
                                } else {
                                  var featuredData = snapshot.data!.docs;

                                  return Row(
                                    children: List.generate(
                                        featuredData.length,
                                        (index) => Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.network(
                                                  featuredData[index]['p_imgs']
                                                      [0],
                                                  width: 150,
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                ),
                                                10.heightBox,
                                                "${featuredData[index]['p_name']}"
                                                    .text
                                                    .fontFamily(semibold)
                                                    .color(darkFontGrey)
                                                    .make(),
                                                10.heightBox,
                                                Row(
                                                  children: [
                                                    "\u{20B9}"
                                                        .text
                                                        .color(redColor)
                                                        .bold
                                                        .size(16)
                                                        .make(),
                                                    2.widthBox,
                                                    "${featuredData[index]['p_price']}"
                                                        .numCurrency
                                                        .text
                                                        .color(redColor)
                                                        .fontFamily(bold)
                                                        .size(16)
                                                        .make(),
                                                  ],
                                                ),
                                                // "${featuredData[index]['p_price']}"
                                                //     .numCurrency
                                                //     .text
                                                //     .color(redColor)
                                                //     .fontFamily(bold)
                                                //     .size(16)
                                                //     .make(),
                                              ],
                                            )
                                                .box
                                                .white
                                                .margin(
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4))
                                                .roundedSM
                                                .padding(
                                                    const EdgeInsets.all(8))
                                                .make()
                                                .onTap(() {
                                              Get.back();
                                              Get.to(
                                                () => ItemDetails(
                                                  title:
                                                      "${featuredData[index]['p_name']}",
                                                  data: featuredData[index],
                                                ),
                                              );
                                              // print("hello");
                                            })),
                                  );
                                }
                              }),
                        ),
                      ]),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                  color: redColor,
                  onPress: () {
                    if (controller.quantity.value > 0) {
                      controller.addToCart(
                        context: context,
                        img: data['p_imgs'][0],
                        qty: controller.quantity.value,
                        title: data['p_name'],
                        tprice: controller.totalPrice.value,
                      );
                      VxToast.show(context, msg: "Added to cart");
                    } else {
                      VxToast.show(context, msg: "Quantity can't be 0");
                    }
                  },
                  textcolor: whiteColor,
                  title: "Add to cart"),
            )
          ],
        ),
      ),
    );
  }
}
