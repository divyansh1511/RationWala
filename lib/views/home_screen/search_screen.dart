import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/consts/consts.dart';
import 'package:ecommerceapp/services/firestore_services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../category_screen/item_details.dart';

class SearchScreen extends StatelessWidget {
  final String? title;
  const SearchScreen({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: title!.text.color(darkFontGrey).make(),
      ),
      body: FutureBuilder(
          future: FirestoreServices.searchProducts(title),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return "No products found".text.makeCentered();
            } else {
              var data = snapshot.data!.docs;
              var filtered = data
                  .where(
                    (element) => element['p_name']
                        .toString()
                        .toLowerCase()
                        .contains(title!.toLowerCase()),
                  )
                  .toList();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 300,
                  ),
                  children: filtered
                      .mapIndexed(
                        (currentValue, index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              filtered[index]['p_imgs'][0],
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            // 10.heightBox,
                            const Spacer(),
                            "${filtered[index]['p_name']}"
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
                                "${filtered[index]['p_price']}"
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
                            .outerShadowMd
                            .margin(const EdgeInsets.symmetric(horizontal: 4))
                            .roundedSM
                            .padding(const EdgeInsets.all(12))
                            .make()
                            .onTap(() {
                          Get.to(
                            () => ItemDetails(
                              title: "${filtered[index]['p_name']}",
                              data: filtered[index],
                            ),
                          );
                        }),
                      )
                      .toList(),
                ),
              );
            }
          }),
    );
  }
}
