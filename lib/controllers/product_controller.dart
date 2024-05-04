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

  void updateWishlistStatus(String productName, bool isFav) {
    this.isFav.value = isFav; 
    FirebaseFirestore.instance.collection(productsCollection)
      .where('name', isEqualTo: productName)
      .get()
      .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          document.reference.update({'isFavorited': isFav});
        });
      }).catchError((error) {
        print("Error updating favorite status: $error");
      });
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
      {title, img, sellername, color, qty, tprice, context, vendorID, productsize}) async {
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'img': img,
      'sellername': sellername,
      'color': color,
      'qty': qty,
      'vendor_id': vendorID,
      'tprice': tprice,
      'added_by': currentUser!.uid,
      'productsize': productsize,
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
              }).then((value) {
          VxToast.show(context, msg: "Added from wishlist");
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

void addToWishlistUserMatch(String productNameTop, String productNameLower, BuildContext context) {
  List<String> productNames = [productNameTop, productNameLower];
  FirebaseFirestore.instance
      .collection('products')
      .where('p_name', whereIn: productNames)
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
      Map<String, dynamic> userData = {'p_wishlist': [currentUserUID]};
      
      querySnapshot.docs.forEach((doc) {
        var data = doc.data() as Map<String, dynamic>?;
        var wishlist = (data?['p_wishlist'] as List<dynamic>?) ?? [];
        
        if (!wishlist.contains(currentUserUID)) {
          if (doc['p_name'] == productNameTop) {
            userData['p_name_top'] = productNameTop;
            userData['p_price_top'] = doc['p_price'];
            userData['p_imgs_top'] = doc['p_imgs'];
            userData['vendor_id_top'] = doc['vendor_id'];
          } else if (doc['p_name'] == productNameLower) {
            userData['p_name_lower'] = productNameLower;
            userData['p_price_lower'] = doc['p_price'];
            userData['p_imgs_lower'] = doc['p_imgs'];
            userData['vendor_id_lower'] = doc['vendor_id'];
          }
        }
      });

      if (userData.keys.length > 1) { // Check if any product info was added
        FirebaseFirestore.instance.collection('usermixmatchs').add(userData).then((documentReference) {
          VxToast.show(context, msg: "Added to wishlist and user mix-match.");
          print('Data added in usermixmatchs collection with document ID: ${documentReference.id}');
        }).catchError((error) {
          print('Error adding data in usermixmatchs collection: $error');
          VxToast.show(context, msg: "Error adding to wishlist.");
        });
      } else {
        VxToast.show(context, msg: "Products already in wishlist.");
      }
    } else {
      print('No products found matching the names.');
      VxToast.show(context, msg: "No products found.");
    }
  }).catchError((error) {
    print('Error retrieving products: $error');
    VxToast.show(context, msg: "Error retrieving products.");
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
