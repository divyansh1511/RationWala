import 'package:ecommerceapp/consts/consts.dart';
import 'package:ecommerceapp/views/orders_screen/components/order_place_details.dart';
import 'package:ecommerceapp/views/orders_screen/components/order_status.dart';
import 'package:intl/intl.dart' as intl;

class OrderDetails extends StatelessWidget {
  final dynamic data;
  const OrderDetails({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: "Order Details".text.fontFamily(semibold).make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              orderStatus(
                  color: redColor,
                  icon: Icons.done,
                  title: "Order Placed",
                  showDone: data['order_placed']),
              orderStatus(
                  color: Colors.blue,
                  icon: Icons.thumb_up_sharp,
                  title: "Confirmed",
                  showDone: data['order_confirmed']),
              orderStatus(
                  color: Colors.yellow,
                  icon: Icons.bike_scooter,
                  title: "On Delivery",
                  showDone: data['order_on_delivery']),
              orderStatus(
                  color: Colors.purple,
                  icon: Icons.done_all_rounded,
                  title: "Delivered",
                  showDone: data['order_delivered']),
              const Divider(),
              10.heightBox,
              Column(
                children: [
                  orderPlaceDetails(
                      d1: data['order_code'],
                      d2: data['shipping_method'],
                      title1: "Order Code",
                      title2: "Shipping Method"),
                  orderPlaceDetails(
                      d1: intl.DateFormat()
                          .add_yMd()
                          .format(data['order_date'].toDate()),
                      d2: data['total_amount'],
                      title1: "Order Date",
                      title2: "Order Total"),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Shipping Address".text.fontFamily(semibold).make(),
                            "${data['order_by_email']}".text.make(),
                            "${data['order_by_address']}".text.make(),
                            "${data['order_by_city']}".text.make(),
                            "${data['order_by_state']}".text.make(),
                            "${data['order_by_phone']}".text.make(),
                            "${data['order_by_postalcode']}".text.make(),
                          ],
                        ),
                        SizedBox(
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Total Amount".text.fontFamily(semibold).make(),
                              "${data['total_amount']}"
                                  .text
                                  .color(redColor)
                                  .fontFamily(bold)
                                  .make(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ).box.outerShadowMd.white.make(),
              const Divider(),
              10.heightBox,
              "Ordered Product"
                  .text
                  .size(16)
                  .color(darkFontGrey)
                  .fontFamily(semibold)
                  .makeCentered(),
              10.heightBox,
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(data['orders'].length, (index) {
                  return orderPlaceDetails(
                      title1: data['orders'][index]['title'],
                      title2: data['orders'][index]['tprice'],
                      d1: "${data['orders'][index]['qty']}x",
                      d2: "Item Total");
                }).toList(),
              )
                  .box
                  .outerShadowMd
                  .white
                  .margin(const EdgeInsets.only(bottom: 4))
                  .make(),
              10.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
