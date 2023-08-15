import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/controllers/product_controller.dart';
import 'package:ecommerceapp/services/firestore_services.dart';
import 'package:ecommerceapp/views/category_screen/item_details.dart';
import 'package:ecommerceapp/widgets_common/bg_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../consts/consts.dart';

class CategoryDetails extends StatefulWidget {
  final String? title;
  const CategoryDetails({Key? key, required this.title}) : super(key: key);

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  void initState() {
    super.initState();
    switchCategory(widget.title);
  }

  switchCategory(title) {
    if (controller.subcat.contains(title)) {
      productmethod = FirestoreServices.getSubCategoryProducts(title);
    } else {
      productmethod = FirestoreServices.getProducts(title);
    }
  }

  var controller = Get.find<ProductController>();

  dynamic productmethod;

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      appBar: AppBar(
        title: widget.title!.text.fontFamily(bold).white.make(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.heightBox,
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                controller.subcat.length,
                (index) => "${controller.subcat[index]}"
                    .text
                    .size(12)
                    .fontFamily(semibold)
                    .color(darkFontGrey)
                    .makeCentered()
                    .box
                    .white
                    .rounded
                    .size(120, 60)
                    .margin(EdgeInsets.symmetric(horizontal: 4))
                    .make()
                    .onTap(() {
                  switchCategory("${controller.subcat[index]}");
                  setState(() {});
                }),
              ),
            ),
          ),
          20.heightBox,
          StreamBuilder(
            stream: productmethod,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    ),
                  ),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return Expanded(
                  child: "No Products Found"
                      .text
                      .color(darkFontGrey)
                      .makeCentered(),
                );
              } else {
                var data = snapshot.data!.docs;

                return Expanded(
                    child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 260,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                data[index]['p_imgs'][0],
                                width: 200,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                              10.heightBox,
                              "${data[index]['p_name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                              10.heightBox,
                              Row(
                                children: [
                                  "\u{20B9}".text.color(redColor).bold.make(),
                                  2.widthBox,
                                  "${data[index]['p_price']}"
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
                              .margin(const EdgeInsets.symmetric(horizontal: 4))
                              .roundedSM
                              .outerShadow
                              .padding(const EdgeInsets.all(12))
                              .make()
                              .onTap(() {
                            controller.checkIfFav(data[index]);
                            Get.to(() => ItemDetails(
                                  title: "${data[index]['p_name']}",
                                  data: data[index],
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
