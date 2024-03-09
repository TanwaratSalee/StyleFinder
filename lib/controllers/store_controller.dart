// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_finalproject/consts/consts.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// class StoreController extends GetxController{
//   var profileImgPath = ''.obs;

//   var profileImageLink = '';

//   var isloading = false.obs;

//   var nameController = TextEditingController();


//   // Select a photo from the user's gallery. /ImagePicker to open a gallery. / 70% to reduce file size.
//   changeImage(context) async {
//     try{
//       final img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
//       if (img == null) return;
//       profileImgPath.value = img.path;
//       } on PlatformException catch (e){
//         VxToast.show(context, msg: e.toString());
//       }
//     }
    
//     // Upload the selected profile picture to Firebase Storage.
//     uploadProfileImage() async {
//       var filename = basename(profileImgPath.value);
//       var destination = 'images/${currentUser!.uid}/$filename';
//       Reference ref = FirebaseStorage.instance.ref().child(destination);
//       await ref.putFile(File(profileImgPath.value));
//       profileImageLink = await ref.getDownloadURL();
//     }

//     // Uused to update Firebase Firestore profile information.
//     updateProfile({name, password, imgUrl}) async {
//       var store = firestore.collection(usersCollection).doc(currentUser!.uid);
//       store.set({'name' : name, 'password': password, 'imageUrl': imgUrl}, SetOptions(merge: true));
//       isloading(false);
//     }
// }