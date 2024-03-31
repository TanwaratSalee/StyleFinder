// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController {
  var profileImgPath = ''.obs;

  var profileImageLink = '';

  var isloading = false.obs;

  var nameController = TextEditingController();
  var emailController = TextEditingController();

  var heightController = TextEditingController();
  var weightController = TextEditingController();

  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();

  // Select a photo from the user's gallery. /ImagePicker to open a gallery. / 70% to reduce file size.
  changeImage(context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  // Upload the selected profile picture to Firebase Storage.
  uploadProfileImage() async {
    var filename = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  // Uused to update Firebase Firestore profile information.
  updateProfile({name, password, imgUrl}) async {
    var store = firestore.collection(usersCollection).doc(currentUser!.uid);
    store.set({'name': name, 'password': password, 'imageUrl': imgUrl},
        SetOptions(merge: true));
    isloading(false);
  }

  // Change password
  // changeAuthPassword({email,password,newpassword}) async {
  //   final card = EmailAuthProvider.credential(email: email, password: password);

  //   await currentUser!.reauthenticateWithCredential(card).then((value) {
  //     currentUser!.updatePassword(newpassword);
  //   }).catchError((error){
  //     // ignore: avoid_print
  //     print(error.toString());
  //   });
  // }

  Future<bool> changeAuthPassword(
      {required String oldPassword, required String newPassword}) async {
    final credential =
        EmailAuthProvider.credential(email: email, password: oldPassword);

    try {
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.updatePassword(newPassword);
      return true; // Return true if password change is successful
    } catch (error) {
      print(error.toString());
      return false; // Return false if there's an error
    }
  }
}
