import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/consts/consts.dart';
import 'package:ecommerceapp/controllers/home_controller.dart';
import 'package:ecommerceapp/controllers/product_controller.dart';
import 'package:ecommerceapp/services/firestore_services.dart';
import 'package:ecommerceapp/views/category_screen/cateogory_screen.dart';
import 'package:ecommerceapp/views/category_screen/item_details.dart';
import 'package:ecommerceapp/views/home_screen/components/featured_button.dart';
import 'package:ecommerceapp/views/home_screen/search_screen.dart';
import 'package:ecommerceapp/views/todaysdeal_screen/todays_deal_screen.dart';
import 'package:ecommerceapp/views/topsellers_screen/top_sellers_screen.dart';
import 'package:ecommerceapp/widgets_common/home_buttons.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    var prcontroller = Get.put(ProductController());
    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              color: lightGrey,
              child: TextFormField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: const Icon(Icons.search).onTap(() {
                    if (controller.searchController.text.isNotEmptyAndNotNull) {
                      Get.to(() => SearchScreen(
                            title: controller.searchController.text,
                          ));
                    }
                  }),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchanything,
                  hintStyle: const TextStyle(color: textfieldGrey),
                ),
              ),
            ),
            10.heightBox,
            // swipper over here
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    VxSwiper.builder(
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: slidersList.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            slidersList[index],
                            fit: BoxFit.fill,
                          )
                              .box
                              .rounded
                              .clip(Clip.antiAlias)
                              .margin(
                                const EdgeInsets.symmetric(horizontal: 0.0),
                              )
                              .make();
                        }),
                    10.heightBox,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: List.generate(
                    //       2,
                    //       (index) => homeButton(
                    //             height: context.screenHeight * 0.15,
                    //             width: context.screenWidth / 2.5,
                    //             icon: index == 0 ? icTodaysDeal : icFlashDeal,
                    //             title: index == 0 ? todaydeal : flashsale,
                    //           )),
                    // ),
                    // 10.heightBox,

                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          3,
                          (index) => homeButton(
                                height: context.screenHeight * 0.15,
                                width: context.screenWidth / 3.5,
                                icon: index == 0
                                    ? icTodaysDeal
                                    : index == 1
                                        ? icTopCategories
                                        : icTopSeller,
                                title: index == 0
                                    ? todaydeal
                                    : index == 1
                                        ? topcategories
                                        : topsellers,
                              ).onTap(() {
                                if (index == 2) {
                                  Get.to(() =>
                                      const TopSellers(title: "Best Sellers"));
                                } else if (index == 1) {
                                  Get.to(() => const CategoryScreen());
                                } else {
                                  Get.to(() => const TodaysDeal(
                                      title: "Best Deals of the day"));
                                }
                              })),
                    ),
                    20.heightBox,
                    VxSwiper.builder(
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: secondSlidersList.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            secondSlidersList[index],
                            fit: BoxFit.fill,
                          )
                              .box
                              .rounded
                              .clip(Clip.antiAlias)
                              .margin(
                                const EdgeInsets.symmetric(horizontal: 2.0),
                              )
                              .make();
                        }),

                    20.heightBox,
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: const BoxDecoration(color: redColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuredProduct.text.white
                              .fontFamily(bold)
                              .size(18)
                              .make(),
                          10.heightBox,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder(
                                future: FirestoreServices.getFeaturedProducts(),
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
                                                    featuredData[index]
                                                        ['p_imgs'][0],
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
                                                ],
                                              )
                                                  .box
                                                  .white
                                                  .margin(const EdgeInsets
                                                      .symmetric(horizontal: 4))
                                                  .roundedSM
                                                  .padding(
                                                      const EdgeInsets.all(8))
                                                  .make()
                                                  .onTap(() {
                                                Get.to(
                                                  () => ItemDetails(
                                                    title:
                                                        "${featuredData[index]['p_name']}",
                                                    data: featuredData[index],
                                                  ),
                                                );
                                              })),
                                    );
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                    20.heightBox,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: allpro.text
                          .color(darkFontGrey)
                          .size(16)
                          .fontFamily(semibold)
                          .make(),
                    ),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: featuredbrands.text
                    //       .color(darkFontGrey)
                    //       .size(16)
                    //       .fontFamily(semibold)
                    //       .make(),
                    // ),
                    10.heightBox,
                    // SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child: Row(
                    //       children: List.generate(
                    //           3,
                    //           (index) => Column(
                    //                 children: [
                    //                   featuredButton(
                    //                     icon: featuredImages1[index],
                    //                     title: featuredtitles1[index],
                    //                   ),
                    //                   10.heightBox,
                    //                   featuredButton(
                    //                       icon: featuredImages2[index],
                    //                       title: featuredtitles2[index]),
                    //                 ],
                    //               )),
                    //     )),
                    // VxSwiper.builder(
                    //     aspectRatio: 16 / 9,
                    //     autoPlay: true,
                    //     height: 150,
                    //     enlargeCenterPage: true,
                    //     itemCount: secondSlidersList.length,
                    //     itemBuilder: (context, index) {
                    //       return Image.asset(
                    //         secondSlidersList[index],
                    //         fit: BoxFit.fill,
                    //       )
                    //           .box
                    //           .rounded
                    //           .clip(Clip.antiAlias)
                    //           .margin(
                    //             const EdgeInsets.symmetric(horizontal: 2.0),
                    //           )
                    //           .make();
                    //     }),
                    20.heightBox,
                    StreamBuilder(
                      stream: FirestoreServices.allProducts(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          );
                        } else {
                          var allproductsdata = snapshot.data!.docs;

                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: allproductsdata.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              mainAxisExtent: 330,
                            ),
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    allproductsdata[index]['p_imgs'][0],
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  // 10.heightBox,
                                  const Spacer(),
                                  "${allproductsdata[index]['p_name']}"
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
                                          .make(),
                                      2.widthBox,
                                      "${allproductsdata[index]['p_price']}"
                                          .numCurrency
                                          .text
                                          .color(redColor)
                                          .fontFamily(bold)
                                          .size(16)
                                          .make(),
                                    ],
                                  ),
                                ],
                              )
                                  .box
                                  .white
                                  .margin(
                                      const EdgeInsets.symmetric(horizontal: 4))
                                  .roundedSM
                                  .padding(const EdgeInsets.all(12))
                                  .make()
                                  .onTap(() {
                                Get.to(
                                  () => ItemDetails(
                                    title:
                                        "${allproductsdata[index]['p_name']}",
                                    data: allproductsdata[index],
                                  ),
                                );
                              });
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
