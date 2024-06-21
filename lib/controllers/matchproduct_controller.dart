import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchProductController extends GetxController {
  var isFav = false.obs;

  void updateIsFav(bool value) {
    isFav.value = value;
  }
    void addFavoriteUserPost(Map<String, dynamic> product, Function(bool) updateIsFav, context) {
    FirebaseFirestore.instance
        .collection('usermixandmatch')
        .where('name', isEqualTo: product['name'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        List<dynamic> wishlist = doc['favorite_userid'];
        if (!wishlist.contains(FirebaseAuth.instance.currentUser!.uid)) {
          doc.reference.update({
            'favorite_userid': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
          }).then((value) {
            updateIsFav(true);
            VxToast.show(context, msg: "Added to favorite");
          }).catchError((error) {
            print('Error adding to Favorite: $error');
          });
        }
      }
    });
  }

  void removeFavoriteUserPost(Map<String, dynamic> product, Function(bool) updateIsFav, context) {
    FirebaseFirestore.instance
        .collection('usermixandmatch')
        .where('name', isEqualTo: product['name'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        List<dynamic> wishlist = doc['favorite_userid'];
        if (wishlist.contains(FirebaseAuth.instance.currentUser!.uid)) {
          doc.reference.update({
            'favorite_userid': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
          }).then((value) {
            updateIsFav(false);
            VxToast.show(context, msg: "Removed from favorite");
          }).catchError((error) {
            print('Error removing from Favorite: $error');
          });
        }
      }
    });
  
  }


  // void addToWishlistMixMatch(String productName1, String productName2, String vendorId, Function(bool) updateIsFav, BuildContext context) {
  //   String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
  //   FirebaseFirestore.instance.collection('favoritemixmatch').add({
  //     'user_id': currentUserUID,
  //     'vendor_id': vendorId,
  //     'product1': {'name': productName1},
  //     'product2': {'name': productName2},
  //   }).then((_) {
  //     updateIsFav(true);
  //     VxToast.show(context, msg: "Added to wishlist");
  //   }).catchError((error) {
  //     print('Error adding to wishlist: $error');
  //     VxToast.show(context, msg: "Error adding to wishlist");
  //   });
  // }

  // void removeToWishlistMixMatch(String productName1, String productName2, String vendorId, Function(bool) updateIsFav, BuildContext context) {
  //   String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
  //   FirebaseFirestore.instance
  //       .collection('favoritemixmatch')
  //       .where('user_id', isEqualTo: currentUserUID)
  //       .where('vendor_id', isEqualTo: vendorId)
  //       .where('product1.p_name', isEqualTo: productName1)
  //       .where('product2.p_name', isEqualTo: productName2)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       doc.reference.delete().then((_) {
  //         updateIsFav(false);
  //         VxToast.show(context, msg: "Removed from favorite");
  //       }).catchError((error) {
  //         print('Error removing from wishlist: $error');
  //         VxToast.show(context, msg: "Error removing from wishlist");
  //       });
  //     });
  //   }).catchError((error) {
  //     print('Error finding wishlist item to remove: $error');
  //     VxToast.show(context, msg: "Error removing from wishlist");
  //   });
  // }

  
}
