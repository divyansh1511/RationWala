import 'package:ecommerceapp/consts/consts.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    // getUsername();
    super.onInit();
  }

  var currentNavIndex = 0.obs;

  var username = '';

  var searchController = TextEditingController();

  // getUsername() async {
  //   var n = await firestore
  //       .collection(userCollection)
  //       .where('id', isEqualTo: currentUser!.uid)
  //       .get();
  //   username = n as String;
  // }
}
