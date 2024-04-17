import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/models/collection_model.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  var quantity = 0.obs;
  var colorIndex = 0.obs;
  var totalPrice = 0.obs;
  var vendorImageUrl = ''.obs;

  var subcat = [];

  var isFav = false.obs;

  @override
  void onInit() {
    super.onInit();
    resetValues();
  }

  getSubCollection(title) async {
    subcat.clear();
    var data =
        await rootBundle.loadString("lib/services/collection_model.json");
    var decoded = collectionModelFromJson(data);
    var s =
        decoded.collections.where((element) => element.name == title).toList();

    for (var e in s[0].subcollection) {
      subcat.add(e);
    }
  }

  void updateVendorImageUrl(String url) {
    vendorImageUrl.value = url;
  }

  changeColorIndex(index) {
    colorIndex.value = index;
  }

  increaseQuantity(totalQuantity) {
    if (quantity.value < totalQuantity) {
      quantity.value++;
    }
  }

  decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  calculateTotalPrice(int price) {
  totalPrice.value = quantity.value * price;
 }

  addToCart(
      {title, img, sellername, color, qty, tprice, context, vendorID}) async {
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'img': img,
      'sellername': sellername,
      'color': color,
      'qty': qty,
      'vendor_id': vendorID,
      'tprice': tprice,
      'added_by': currentUser!.uid
    }).catchError((error) {
      VxToast.show(context, msg: error.toString());
    });
  }

  resetValues() {
    totalPrice.value = 0;
    quantity.value = 1;
    colorIndex.value = 0;
    
  }

  addToWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to wishlist");
  }

  void addToWishlistDetail(
      Map<String, dynamic> product, Function(bool) updateIsFav, context) {
    FirebaseFirestore.instance
        .collection(productsCollection)
        .where('p_name', isEqualTo: product['p_name'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        List<dynamic> wishlist = doc['p_wishlist'];
        if (!wishlist.contains(currentUser!.uid)) {
          doc.reference.update({
            'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
          }).then((value) {
            updateIsFav(true);
            VxToast.show(context, msg: "Added from wishlist");
          }).catchError((error) {
            print('Error adding ${product['p_name']} to Favorite: $error');
          });
        }
      }
    });
  }

  void removeToWishlistDetail(
      Map<String, dynamic> product, Function(bool) updateIsFav, context) {
    FirebaseFirestore.instance
        .collection(productsCollection)
        .where('p_name', isEqualTo: product['p_name'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        List<dynamic> wishlist = doc['p_wishlist'];
        if (wishlist.contains(currentUser!.uid)) {
          doc.reference.update({
            'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
          }).then((value) {
            updateIsFav(false);
            VxToast.show(context, msg: "Removed from wishlist");
          }).catchError((error) {
            print('Error removing ${product['p_name']} from Favorite: $error');
          });
        }
      }
    });
  }

void addToWishlistMixMatch(
    String productName, Function(bool) updateIsFav, BuildContext context) {
  FirebaseFirestore.instance
      .collection('products')
      .where('p_name', isEqualTo: productName)
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      List<dynamic> wishlist = doc['p_wishlist'] ?? [];
      String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (!wishlist.contains(currentUserUID)) {
        doc.reference.update({
          'p_wishlist': FieldValue.arrayUnion([currentUserUID])
        }).then((value) {
          updateIsFav(true);
          VxToast.show(context, msg: "Added from wishlist");
        }).catchError((error) {
          print('Error adding $productName to Favorite: $error');
        });
      }
    }
  });
}

void removeToWishlistMixMatch(
    String productName, Function(bool) updateIsFav, BuildContext context) {
  FirebaseFirestore.instance
      .collection('products')
      .where('p_name', isEqualTo: productName)
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      List<dynamic> wishlist = doc['p_wishlist'] ?? [];
      String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (wishlist.contains(currentUserUID)) {
        doc.reference.update({
          'p_wishlist': FieldValue.arrayRemove([currentUserUID])
        }).then((value) {
          updateIsFav(false); 
          VxToast.show(context, msg: "Removed from wishlist");
        }).catchError((error) {
          print('Error removing $productName from Favorite: $error');
        });
      }
    }
  });
}

void addToWishlistMatch(String productNameTop, String productNameLower, BuildContext context) {
  List<String> productNames = [productNameTop, productNameLower];
  FirebaseFirestore.instance
      .collection('products')
      .where('p_name', whereIn: productNames)
      .get()
      .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          for (var doc in querySnapshot.docs) {
            // Using null safety checks to handle possible null values
            List<dynamic> wishlist = (doc.data() as Map<String, dynamic>?)?['p_wishlist'] as List<dynamic>? ?? [];
            String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
            if (!wishlist.contains(currentUserUID)) {
              doc.reference.update({
                'p_wishlist': FieldValue.arrayUnion([currentUserUID])
              }).catchError((error) {
                print('Error adding to Favorite: $error');
              });
            }
          }
        } else {
          print('No products found matching the names.');
        }
      }).catchError((error) {
        print('Error retrieving products: $error');
      });
}




  removeFromWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: "Removed from wishlist");
  }

  checkIfFav(data) async {
    if (data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }
}
