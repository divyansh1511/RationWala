import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/consts/consts.dart';
import 'package:ecommerceapp/services/firestore_services.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title:
            "My Wishlist".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getWishlist(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(redColor),
            ));
          } else if (snapshot.data!.docs.isEmpty) {
            return "No Products Yet!!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Image.network("${data[index]['p_imgs'][0]}"),
                        title: "${data[index]['p_name']}"
                            .text
                            .fontFamily(semibold)
                            .size(16)
                            .make(),
                        // subtitle: "${data[index]['p_price']}"
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
                            "${data[index]['p_price']}"
                                .numCurrency
                                .text
                                .color(redColor)
                                .fontFamily(semibold)
                                .size(14)
                                .make(),
                          ],
                        ),
                        trailing: const Icon(Icons.delete, color: redColor)
                            .onTap(() async {
                          await firestore
                              .collection(productsCollection)
                              .doc(data[index].id)
                              .set({
                            'p_wishlist':
                                FieldValue.arrayRemove([currentUser!.uid])
                          }, SetOptions(merge: true));
                        }),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
