import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/controllers/product_controller.dart';
import 'package:ecommerceapp/services/firestore_services.dart';
import 'package:ecommerceapp/views/category_screen/item_details.dart';
import 'package:ecommerceapp/widgets_common/bg_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../consts/consts.dart';
import '../../controllers/home_controller.dart';

class TopSellers extends StatefulWidget {
  final String? title;
  const TopSellers({Key? key, required this.title}) : super(key: key);

  @override
  State<TopSellers> createState() => _TopSellersState();
}

class _TopSellersState extends State<TopSellers> {
  @override
  Widget build(BuildContext context) {
    // var controller = Get.find<HomeController>();
    // var prcontroller = Get.put(ProductController());

    return bgWidget(
        child: Scaffold(
      appBar: AppBar(
        title: widget.title!.text.fontFamily(bold).white.make(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.heightBox,
          // SingleChildScrollView(
          //   physics: const BouncingScrollPhysics(),
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: List.generate(
          //       controller.subcat.length,
          //       (index) => "${controller.subcat[index]}"
          //           .text
          //           .size(12)
          //           .fontFamily(semibold)
          //           .color(darkFontGrey)
          //           .makeCentered()
          //           .box
          //           .white
          //           .rounded
          //           .size(120, 60)
          //           .margin(EdgeInsets.symmetric(horizontal: 4))
          //           .make()
          //           .onTap(() {
          //         switchCategory("${controller.subcat[index]}");
          //         setState(() {});
          //       }),
          //     ),
          //   ),
          // ),
          20.heightBox,
          FutureBuilder(
            future: FirestoreServices.getFeaturedProducts(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ));
              } else if (snapshot.data!.docs.isEmpty) {
                return "No Products Available".text.white.makeCentered();
              } else {
                var toadysdata = snapshot.data!.docs;
                return Expanded(
                    child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: toadysdata.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 250,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                toadysdata[index]['p_imgs'][0],
                                width: 200,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                              // 10.heightBox,
                              "${toadysdata[index]['p_name']}"
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
                                  "${toadysdata[index]['p_price']}"
                                      .numCurrency
                                      .text
                                      .color(redColor)
                                      .fontFamily(bold)
                                      .size(16)
                                      .make(),
                                ],
                              ),
                              // "${toadysdata[index]['p_price']}"
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
                              .margin(const EdgeInsets.symmetric(horizontal: 4))
                              .roundedSM
                              .outerShadow
                              .padding(const EdgeInsets.all(12))
                              .make()
                              .onTap(() {
                            // controller.checkIfFav(toadysdata[index]);
                            Get.to(() => ItemDetails(
                                  title: "${toadysdata[index]['p_name']}",
                                  data: toadysdata[index],
                                ));
                          });
                        }));
              }
            },
          ),
        ],
      ),
    ));
  }
}
