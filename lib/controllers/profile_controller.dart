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

  var birthdayController = TextEditingController();
  var genderController = TextEditingController();
  var selectedGender = ''.obs;

  void selectGender(String gender) {
  selectedGender.value = gender;
  genderController.text = gender; 
}

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

  Future<void> updateProfile({
    String? name,
    String? height,
    String? weight,
    String? imgUrl,
    String? birthday,
    String? gender,
  }) async {
    try {
      isloading(true);

      Map<String, dynamic> dataToUpdate = {};
      if (name != null) dataToUpdate['name'] = name;
      if (height != null) dataToUpdate['height'] = height;
      if (weight != null) dataToUpdate['weight'] = weight;
      if (imgUrl != null) dataToUpdate['imageUrl'] = imgUrl;
      if (birthday != null) dataToUpdate['birthday'] = birthday;
      if (gender != null) dataToUpdate['gender'] = gender;

      await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(dataToUpdate);

      isloading(false);
    } catch (e) {
      print(e.toString());
      isloading(false);
    }
  }

  Future<bool> changeAuthPassword(
      {required String oldPassword, required String newPassword}) async {
    User? user = FirebaseAuth.instance.currentUser;
    String email = user!.email!;

    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
      return true; // คืนค่า true หากการเปลี่ยนรหัสผ่านสำเร็จ
    } catch (error) {
      print(error.toString());
      return false; // คืนค่า false หากมีข้อผิดพลาด
    }
  }
}
