import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:video_call/app/routes/app_pages.dart';
import 'package:video_call/constants/sizeConstant.dart';
import 'package:video_call/model/userModel.dart';

import '../constants/api_constants.dart';
import '../constants/progress_dialog_utils.dart';
import '../main.dart';

class FirebaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  createUserWithEmailAndPassword(
      {required BuildContext context, required UserModel userModel}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userModel.email!, password: userModel.password!);
      userModel.id = userCredential.user!.uid;
      await userCollection
          .doc(userCredential.user!.uid)
          .set(userModel.toJson())
          .then((value) {
        getIt<CustomDialogs>().hideCircularDialog(context);
        box.write(PrefStrings.userData, userModel.toJson());
        box.write(PrefStrings.isUserLogin, true);
        Get.offAllNamed(Routes.HOME);
        print("User Added");
      }).catchError((error) {
        print("Failed to add user: $error");
      });
    } on FirebaseAuthException catch (e) {
      getIt<CustomDialogs>().hideCircularDialog(context);
      if (e.code == 'weak-password') {
        getIt<CustomDialogs>().getDialog(
            title: "Error", desc: "The password provided is too weak.");
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        getIt<CustomDialogs>().getDialog(
            title: "Error", desc: "The account already exists for that email.");
        print('The account already exists for that email.');
      }
    } catch (e) {
      getIt<CustomDialogs>().hideCircularDialog(context);
      print(e);
    }
  }

  logInUserWithEmailAndPassword(
      {required BuildContext context, required UserModel userModel}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: userModel.email!, password: userModel.password!);
      await userCollection.doc(userCredential.user!.uid).get().then((value) {
        getIt<CustomDialogs>().hideCircularDialog(context);
        if (!isNullEmptyOrFalse(value)) {
          UserModel currentUser =
              UserModel.fromJson(value.data() as Map<String, dynamic>);
          box.write(PrefStrings.userData, value.data());
          box.write(PrefStrings.isUserLogin, true);
          Get.offAllNamed(Routes.HOME);
        }
        print("User Added");
      }).catchError((error) {
        print("Failed to add user: $error");
      });
    } on FirebaseAuthException catch (e) {
      getIt<CustomDialogs>().hideCircularDialog(context);
      if (e.code == 'weak-password') {
        getIt<CustomDialogs>().getDialog(
            title: "Error", desc: "The password provided is too weak.");
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        getIt<CustomDialogs>().getDialog(
            title: "Error", desc: "The account already exists for that email.");
        print('The account already exists for that email.');
      }
    } catch (e) {
      getIt<CustomDialogs>().hideCircularDialog(context);
      print(e);
    }
  }

  Stream<QuerySnapshot> getUserList() {
    print('getMessage');
    return userCollection
        .where('id', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    box.erase();
    Get.offAllNamed(Routes.SING_IN);
  }
}
