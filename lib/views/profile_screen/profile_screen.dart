import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/consts/consts.dart';
import 'package:ecommerceapp/controllers/auth_controller.dart';
import 'package:ecommerceapp/controllers/profile_controller.dart';
import 'package:ecommerceapp/services/firestore_services.dart';
import 'package:ecommerceapp/views/auth_screen/login_screen.dart';
import 'package:ecommerceapp/views/profile_screen/components/detail_cart.dart';
import 'package:ecommerceapp/views/profile_screen/edit_profile_screen.dart';
import 'package:ecommerceapp/views/wishlist_screen/wishlist_screen.dart';
import 'package:ecommerceapp/widgets_common/bg_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../orders_screen/orders_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            } else {
              var data = snapshot.data!.docs[0];

              return SafeArea(
                child: Column(
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.all(8.0),
                    //   child: const Align(
                    //     alignment: Alignment.topRight,
                    //     child: Icon(
                    //       Icons.edit,
                    //       color: whiteColor,
                    //     ),
                    //   ).onTap(() {
                    //     controller.nameController.text = data['name'];
                    //     // controller.passController.text = data['password'];
                    //     Get.to(() => EditProfileScreen(
                    //           data: data,
                    //         ));
                    //   }),
                    // ),
                    30.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          data['imageUrl'] == ''
                              ? Image.asset(imgProfile2,
                                      width: 80, fit: BoxFit.cover)
                                  .box
                                  .roundedFull
                                  .clip(Clip.antiAlias)
                                  .make()
                              : Image.network(data['imageUrl'],
                                      width: 80, fit: BoxFit.cover)
                                  .box
                                  .roundedFull
                                  .clip(Clip.antiAlias)
                                  .make(),
                          10.widthBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "${data['name']}"
                                    .text
                                    .fontFamily(semibold)
                                    .white
                                    .make(),
                                // 5.heightBox,
                                "${data['email']}".text.white.make(),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: whiteColor,
                              ),
                            ),
                            onPressed: () async {
                              await Get.put(AuthController())
                                  .signoutMethod(context);
                              Get.offAll(() => const LoginScreen());
                            },
                            child:
                                logout.text.fontFamily(semibold).white.make(),
                          )
                        ],
                      ),
                    ),
                    20.heightBox,
                    FutureBuilder(
                      future: FirestoreServices.getCounts(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(redColor),
                            ),
                          );
                        } else {
                          var countdata = snapshot.data;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              detailsCard(
                                  count: countdata[0].toString(),
                                  title: "in your cart",
                                  width: context.screenWidth / 3.4),
                              detailsCard(
                                  count: countdata[1].toString(),
                                  title: "in your wishlist",
                                  width: context.screenWidth / 3.4),
                              detailsCard(
                                  count: countdata[2].toString(),
                                  title: "your orders",
                                  width: context.screenWidth / 3.4),
                            ],
                          );
                        }
                      },
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     detailsCard(
                    //         count: "${data['cart_count']}",
                    //         title: "in your cart",
                    //         width: context.screenWidth / 3.4),
                    //     detailsCard(
                    //         count: "${data['wishlist_count']}",
                    //         title: "in your wishlist",
                    //         width: context.screenWidth / 3.4),
                    //     detailsCard(
                    //         count: "${data['order_count']}",
                    //         title: "your orders",
                    //         width: context.screenWidth / 3.4),
                    //   ],
                    // ),
                    40.heightBox,
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: lightGrey,
                        );
                      },
                      itemCount: profileButtonList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Get.to(() => const OrdersScreen());
                                break;
                              case 1:
                                Get.to(() => const WishlistScreen());
                                break;
                              case 2:
                                controller.nameController.text = data['name'];
                                // controller.passController.text = data['password'];
                                Get.to(() => EditProfileScreen(
                                      data: data,
                                    ));
                                break;
                            }
                          },
                          // leading: Image.asset(profileButtonIcon[index]),
                          title: profileButtonList[index].text.make(),
                        );
                      },
                    )
                        .box
                        .white
                        .rounded
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .shadowSm
                        .make(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
