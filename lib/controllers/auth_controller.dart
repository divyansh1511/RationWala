import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../consts/firebase_consts.dart';

class AuthController extends GetxController {
  var isloading = false.obs;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // login method

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredentials;

    try {
      userCredentials = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredentials;
  }

  // sign up method

  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredentials;

    try {
      userCredentials = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredentials;
  }

  // storing data method

  storeUserData({name, password, email}) async {
    DocumentReference store =
        await firestore.collection(userCollection).doc(currentUser!.uid);
    store.set({
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': currentUser!.uid,
      'cart_count': "00",
      'wishlist_count': "00",
      "order_count": "00",
    });

    //sign out method
  }

  signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
