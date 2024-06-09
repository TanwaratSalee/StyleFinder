import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/models/collection_model.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

class ProductController extends GetxController {
  var quantity = 0.obs;
  var colorIndex = 0.obs;
  var totalPrice = 0.obs;
  var vendorImageUrl = ''.obs;
  var subcat = [];
  var isFav = false.obs;
  var documentId = ''.obs;

  var averageRating = 0.0.obs;
  var reviewCount = 0.obs;
  var totalRating = 0.obs; 

  void updateAverageRating(double rating) {
    averageRating.value = rating;
  }

  void updateTotalRating(int rating) {
    totalRating.value = rating;
  }

  void setDocumentId(String id) {
    documentId.value = id;
  }

  void setReviewCount(int count) {
    reviewCount.value = count;
  }

  void resetReviewCount() {
    reviewCount.value = 0;
  }

  void updateReviewCount(int count) {
  reviewCount.value = count;
}


//reviewscreen
  void loadProductReviews(String productId) async {
    documentId.value = productId;
    var reviewsSnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('product_id', isEqualTo: productId)
        .get();
    
    if (reviewsSnapshot.docs.isNotEmpty) {
      var totalRating = reviewsSnapshot.docs.fold<double>(
          0.0, (sum, doc) => sum + doc['rating']);
      averageRating.value = totalRating / reviewsSnapshot.docs.length;
    } else {
      averageRating.value = 0.0;
    }
  }

 //======Filter
  var filteredProducts = <Map<String, dynamic>>[].obs;
  var selectedGender = ''.obs;
  var maxPrice = 0.0.obs;
  var selectedColors = <int>[].obs;
  var selectedTypes = <String>[].obs;
  var selectedCollections = <String>[].obs;
  var selectedVendorId = ''.obs;
  var vendors = <Map<String, dynamic>>[].obs;

void updateFilters({
  String? gender,
  double? price,
  List<int>? colors,
  List<String>? types,
  List<String>? collections,
  String? vendorId,
}) {
  selectedGender.value = gender ?? '';
  maxPrice.value = price ?? 0.0;
  selectedColors.assignAll(colors ?? []);
  selectedTypes.assignAll(types ?? []);
  selectedCollections.assignAll(collections ?? []);
  if (vendorId != null) {
    selectedVendorId.value = vendorId;
  }
}


  var topFilteredProducts = <Map<String, dynamic>>[].obs;
  var lowerFilteredProducts = <Map<String, dynamic>>[].obs;

  void fetchInitialTopProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('p_part', isEqualTo: 'top')
          .get();
      List<Map<String, dynamic>> products = snapshot.docs.map((doc) => doc.data()).toList();
      topFilteredProducts.assignAll(products);
    } catch (e) {
      print("Error fetching initial top products: $e");
    }
  }

  void fetchFilteredTopProducts() async {
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('products').where('p_part', isEqualTo: 'top');

      if (selectedGender.value.isNotEmpty) {
        query = query.where('p_sex', isEqualTo: selectedGender.value);
      }

      if (selectedVendorId.value.isNotEmpty) {
        query = query.where('vendor_id', isEqualTo: selectedVendorId.value);
      }

      if (maxPrice.value > 0) {
        query = query.where('p_price', isLessThanOrEqualTo: maxPrice.value.toString());
      }
  
      if (selectedColors.isNotEmpty) {
        query = query.where('p_colors', arrayContainsAny: selectedColors);
      }

      if (selectedTypes.isNotEmpty) {
        query = query.where('p_subcollection', whereIn: selectedTypes);
      }

      if (selectedCollections.isNotEmpty) {
        query = query.where('p_collection', arrayContainsAny: selectedCollections);
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      List<Map<String, dynamic>> products = snapshot.docs.map((doc) => doc.data()).toList();
      topFilteredProducts.assignAll(products);
    } catch (e) {
      print("Error fetching filtered top products: $e");
    }
  }

  void fetchInitialLowerProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('p_part', isEqualTo: 'lower')
          .get();
      List<Map<String, dynamic>> products = snapshot.docs.map((doc) => doc.data()).toList();
      lowerFilteredProducts.assignAll(products);
    } catch (e) {
      print("Error fetching initial lower products: $e");
    }
  }


  void fetchFilteredLowerProducts() async {
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('products').where('p_part', isEqualTo: 'lower');

      if (selectedGender.value.isNotEmpty) {
        query = query.where('p_sex', isEqualTo: selectedGender.value);
      }

      if (selectedVendorId.value.isNotEmpty) {
        query = query.where('vendor_id', isEqualTo: selectedVendorId.value);
      }

      if (maxPrice.value > 0) {
        query = query.where('p_price', isLessThanOrEqualTo: maxPrice.value.toString());
      }

      if (selectedColors.isNotEmpty) {
        query = query.where('p_colors', arrayContainsAny: selectedColors);
      }

      if (selectedTypes.isNotEmpty) {
        query = query.where('p_subcollection', whereIn: selectedTypes);
      }

      if (selectedCollections.isNotEmpty) {
        query = query.where('p_collection', arrayContainsAny: selectedCollections);
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      List<Map<String, dynamic>> products = snapshot.docs.map((doc) => doc.data()).toList();
      lowerFilteredProducts.assignAll(products);
    } catch (e) {
      print("Error fetching filtered lower products: $e");
    }
  }

void fetchVendors() async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('vendors')
        .get();
    List<Map<String, dynamic>> vendorList = snapshot.docs.map((doc) => {
      'vendor_id': doc.id,
      'vendor_name': doc['vendor_name']
    }).toList();
    vendors.assignAll(vendorList);
    print("Vendors fetched: $vendorList");
  } catch (e) {
    print("Error fetching vendors: $e");
  }
}

 //======Filter

  @override
  void onInit() {
    super.onInit();
    resetValues();
    fetchInitialTopProducts();
    fetchInitialLowerProducts();
    fetchVendors();
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

  
  void addToCart({
  title,
  img,
  sellername,
  qty,
  tprice,
  context,
  vendorID,
  productsize,
  documentId, 
}) async {
  try {
    DocumentReference docRef = await FirebaseFirestore.instance.collection(cartCollection).add({
      'title': title,
      'img': img,
      'sellername': sellername,
      'qty': qty,
      'vendor_id': vendorID,
      'tprice': tprice, // ยืนยันว่าใช้ double
      'added_by': currentUser!.uid,
      'productsize': productsize,
      'document_id': documentId, // เพิ่ม Document ID ใน Firestore
    });
        
    VxToast.show(context, msg: "Add to your cart");
  } catch (error) {
    VxToast.show(context, msg: error.toString());
  }
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
                print('Error adding to Favorite: $error');
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
    String productName1,
    String productName2,
    String vendorId,
    Function(bool) updateIsFav,
    BuildContext context) {
  FirebaseFirestore.instance
      .collection(productsCollection)
      .where('p_name', whereIn: [productName1, productName2])
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      // Find the documents for each product
      DocumentSnapshot? doc1;
      DocumentSnapshot? doc2;

      try {
        doc1 = querySnapshot.docs.firstWhere(
            (doc) => doc['p_name'] == productName1);
      } catch (e) {
        doc1 = null;
      }

      try {
        doc2 = querySnapshot.docs.firstWhere(
            (doc) => doc['p_name'] == productName2);
      } catch (e) {
        doc2 = null;
      }

      if (doc1 != null && doc2 != null) {
        String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';

        // Prepare the data to be saved in the new collection
        Map<String, dynamic> favoriteData = {
          'vendor_id': vendorId,
          'user_id': currentUserUID,
          'product1': {
            'p_name': doc1['p_name'],
            'p_price': doc1['p_price'],
            'p_imgs': doc1['p_imgs'][0],
          },
          'product2': {
            'p_name': doc2['p_name'],
            'p_price': doc2['p_price'],
            'p_imgs': doc2['p_imgs'][0],
          },
        };

        FirebaseFirestore.instance
            .collection('favoritemixmatch')
            .add(favoriteData)
            .then((value) {
          updateIsFav(true);
          VxToast.show(context, msg: "Added to favoritemixmatch");
        }).catchError((error) {
          print('Error adding to favoritemixmatch: $error');
          VxToast.show(context, msg: "Error adding to favoritemixmatch");
        });
      } else {
        VxToast.show(context, msg: "One or both products not found");
      }
    } else {
      VxToast.show(context, msg: "No products found");
    }
  }).catchError((error) {
    print('Error retrieving products: $error');
    VxToast.show(context, msg: "Error retrieving products");
  });
}


void removeToWishlistMixMatch(
    String productName1,
    String productName2,
    String vendorId,
    Function(bool) updateIsFav,
    BuildContext context) {
  String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';

  FirebaseFirestore.instance
      .collection('favoritemixmatch')
      .where('user_id', isEqualTo: currentUserUID)
      .where('vendor_id', isEqualTo: vendorId)
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;

      doc.reference.delete().then((value) {
        updateIsFav(false);
        VxToast.show(context, msg: "Removed from favoritemixmatch");
      }).catchError((error) {
        print('Error removing from favoritemixmatch: $error');
        VxToast.show(context, msg: "Error removing from favoritemixmatch");
      });
    } else {
      VxToast.show(context, msg: "No matching favoritemixmatch found");
    }
  }).catchError((error) {
    print('Error retrieving favoritemixmatch: $error');
    VxToast.show(context, msg: "Error retrieving favoritemixmatch");
  });
}

void addToWishlistMatch(String productNameTop, String productNameLower, BuildContext context) {
  List<String> productNames = [productNameTop, productNameLower];
  FirebaseFirestore.instance
      .collection(productsCollection)
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
         VxToast.show(context, msg: "Added from wishlist", bgColor: greyColor.withOpacity(0.8));

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

void addToPostByUserMatch(
  String productNameTop,
  String productNameLower,
  BuildContext context,
  String selectedGender,
  List<String> selectedCollections,
  String explanation
) {
  List<String> productNames = [productNameTop, productNameLower];
  String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Retrieve user details
  FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserUID)
      .get()
      .then((DocumentSnapshot userDoc) {
    if (userDoc.exists) {
      String userName = userDoc['name'];
      String userImg = userDoc['imageUrl'];

      // Retrieve product details
      FirebaseFirestore.instance
          .collection(productsCollection)
          .where('p_name', whereIn: productNames)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          Map<String, dynamic> userData = {
            'p_collection': selectedCollections,
            'p_sex': selectedGender,
            'p_desc': explanation,
            'posted_by': currentUserUID,
            'posted_name': userName,
            'posted_img': userImg,
          };

          querySnapshot.docs.forEach((doc) {
            var data = doc.data() as Map<String, dynamic>?;
            var wishlist = (data?['p_wishlist'] as List<dynamic>?) ?? [];

            if (!wishlist.contains(currentUserUID)) {
              userData['views'] = 0;
              userData['favorite'] = 0;
              if (doc['p_name'] == productNameTop) {
                userData['p_name_top'] = productNameTop;
                userData['p_price_top'] = doc['p_price'];
                userData['p_imgs_top'] = doc['p_imgs'][0];
                userData['vendor_id_top'] = doc['vendor_id'];
              } else if (doc['p_name'] == productNameLower) {
                userData['p_name_lower'] = productNameLower;
                userData['p_price_lower'] = doc['p_price'];
                userData['p_imgs_lower'] = doc['p_imgs'][0];
                userData['vendor_id_lower'] = doc['vendor_id'];
              }
            }
          });

          if (userData.keys.length > 1) { // Check if any product info was added
            FirebaseFirestore.instance.collection('usermixandmatch').add(userData).then((documentReference) {
              VxToast.show(context, msg: "Added post successful.");
              print('Data added in usermixmatchs collection with document ID: ${documentReference.id}');
              Navigator.pop(context);
            }).catchError((error) {
              print('Error adding data in usermixmatchs collection: $error');
              VxToast.show(context, msg: "Error post.");
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
    } else {
      print('User not found.');
      VxToast.show(context, msg: "User not found.");
    }
  }).catchError((error) {
    print('Error retrieving user: $error');
    VxToast.show(context, msg: "Error retrieving user.");
  });
}


void addToWishlistUserMatch(String productNameTop, String productNameLower, BuildContext context) {
  List<String> productNames = [productNameTop, productNameLower];
  FirebaseFirestore.instance
      .collection(productsCollection)
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
            userData['p_imgs_top'] = doc['p_imgs'][0];
            userData['vendor_id_top'] = doc['vendor_id'];
          } else if (doc['p_name'] == productNameLower) {
            userData['p_name_lower'] = productNameLower;
            userData['p_price_lower'] = doc['p_price'];
            userData['p_imgs_lower'] = doc['p_imgs'][0];
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