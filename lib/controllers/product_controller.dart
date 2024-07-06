import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/models/collection_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  var vendorName = ''.obs;

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
      var totalRating = reviewsSnapshot.docs
          .fold<double>(0.0, (sum, doc) => sum + doc['rating']);
      averageRating.value = totalRating / reviewsSnapshot.docs.length;
    } else {
      averageRating.value = 0.0;
    }
  }

  //======Filter
  var filteredProducts = <Map<String, dynamic>>[].obs;
  var selectedGender = ''.obs;
  var maxPrice = ''.obs;
  var selectedColors = <int>[].obs;
  var selectedTypes = <String>[].obs;
  var selectedCollections = <String>[].obs;
  var selectedSituations = <String>[].obs;
  var selectedVendorId = ''.obs;
  var vendors = <Map<String, dynamic>>[].obs;

  void updateFilters({
    String? gender,
    double? price,
    List<int>? colors,
    List<String>? types,
    List<String>? collections,
    List<String>? situations,
    String? vendorId,
  }) {
    selectedGender.value = gender ?? '';
    maxPrice.value = price?.toStringAsFixed(0) ?? '0';
    selectedColors.assignAll(colors ?? []);
    selectedTypes.assignAll(types ?? []);
    selectedCollections.assignAll(collections ?? []);
    selectedSituations.assignAll(situations ?? []);
    if (vendorId != null) {
      selectedVendorId.value = vendorId;
    }
  }

  var topFilteredProducts = <Map<String, dynamic>>[].obs;
  var lowerFilteredProducts = <Map<String, dynamic>>[].obs;
  var isFetchingTopProducts = false.obs;
  var isFetchingLowerProducts = false.obs;

  void fetchInitialTopProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('products')
          .where('part', isEqualTo: 'top')
          .get();
      List<Map<String, dynamic>> products =
          snapshot.docs.map((doc) => doc.data()).toList();
      topFilteredProducts.assignAll(products);
    } catch (e) {
      print("Error fetching initial top products: $e");
    }
  }

  void fetchFilteredTopProducts() async {
    isFetchingTopProducts.value = true;
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('products')
          .where('part', isEqualTo: 'top')
          .get();
      List<Map<String, dynamic>> products =
          snapshot.docs.map((doc) => doc.data()).toList();

      // Apply filters locally
      if (selectedGender.value.isNotEmpty) {
        products = products
            .where((product) => product['gender'] == selectedGender.value)
            .toList();
      }

      if (selectedVendorId.value.isNotEmpty) {
        products = products
            .where((product) => product['vendor_id'] == selectedVendorId.value)
            .toList();
      }

      if (selectedColors.isNotEmpty) {
        products = products
            .where((product) => selectedColors
                .any((color) => product['colors'].contains(color)))
            .toList();
      }

      if (selectedTypes.isNotEmpty) {
        products = products
            .where(
                (product) => selectedTypes.contains(product['subcollection']))
            .toList();
      }

      if (selectedCollections.isNotEmpty) {
        products = products
            .where((product) => selectedCollections.any(
                (collection) => product['collection'].contains(collection)))
            .toList();
      }

      if (selectedSituations.isNotEmpty) {
        products = products
            .where((product) => selectedSituations
                .any((situation) => product['situations'].contains(situation)))
            .toList();
      }

      if (maxPrice.value.isNotEmpty) {
        double maxPriceValue = double.tryParse(maxPrice.value) ?? 0;
        products = products.where((product) {
          double productPrice = double.tryParse(product['price'] ?? '0') ?? 0;
          return productPrice <= maxPriceValue;
        }).toList();
      }

      topFilteredProducts.assignAll(products);
    } catch (e) {
      print("Error fetching filtered top products: $e");
    } finally {
      isFetchingTopProducts.value = false;
    }
  }

  void fetchInitialLowerProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('products')
          .where('part', isEqualTo: 'lower')
          .get();
      List<Map<String, dynamic>> products =
          snapshot.docs.map((doc) => doc.data()).toList();
      lowerFilteredProducts.assignAll(products);
    } catch (e) {
      print("Error fetching initial lower products: $e");
    }
  }

  void fetchFilteredLowerProducts() async {
    isFetchingLowerProducts.value = true;
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('products')
          .where('part', isEqualTo: 'lower')
          .get();
      List<Map<String, dynamic>> products =
          snapshot.docs.map((doc) => doc.data()).toList();

      // Apply filters locally
      if (selectedGender.value.isNotEmpty) {
        products = products
            .where((product) => product['gender'] == selectedGender.value)
            .toList();
      }

      if (selectedVendorId.value.isNotEmpty) {
        products = products
            .where((product) => product['vendor_id'] == selectedVendorId.value)
            .toList();
      }

      if (selectedColors.isNotEmpty) {
        products = products
            .where((product) => selectedColors
                .any((color) => product['colors'].contains(color)))
            .toList();
      }

      if (selectedTypes.isNotEmpty) {
        products = products
            .where(
                (product) => selectedTypes.contains(product['subcollection']))
            .toList();
      }

      if (selectedCollections.isNotEmpty) {
        products = products
            .where((product) => selectedCollections.any(
                (collection) => product['collection'].contains(collection)))
            .toList();
      }

      if (maxPrice.value.isNotEmpty) {
        double maxPriceValue = double.tryParse(maxPrice.value) ?? 0;
        products = products.where((product) {
          double productPrice = double.tryParse(product['price'] ?? '0') ?? 0;
          return productPrice <= maxPriceValue;
        }).toList();
      }

      lowerFilteredProducts.assignAll(products);
    } catch (e) {
      print("Error fetching filtered lower products: $e");
    } finally {
      isFetchingLowerProducts.value = false;
    }
  }

  void fetchVendorData(String vendorId) async {
    try {
      DocumentSnapshot vendorSnapshot = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .get();

      if (vendorSnapshot.exists) {
        var vendorData = vendorSnapshot.data() as Map<String, dynamic>;
        vendorName.value = vendorData['name'] ?? 'Unknown Seller';
        vendorImageUrl.value = vendorData['imageUrl'] ?? '';
      } else {
        vendorName.value = 'Unknown Seller';
        vendorImageUrl.value = '';
      }
    } catch (e) {
      print('Error fetching vendor data: $e');
    }
  }

  void fetchVendors() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('vendors').get();
      List<Map<String, dynamic>> vendorList = snapshot.docs
          .map((doc) => {'vendor_id': doc.id, 'name': doc['name']})
          .toList();
      vendors.assignAll(vendorList);
      print("Vendors fetched: $vendorList");
    } catch (e) {
      print("Error fetching vendors: $e");
    }
  }

// //ดึงชื่แและรูปตรง serr store จาก vendor_id
  Future<void> fetchVendorInfo(String vendorId) async {
    try {
      DocumentSnapshot vendorSnapshot = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .get();
      if (vendorSnapshot.exists) {
        var vendorData = vendorSnapshot.data() as Map<String, dynamic>;
        vendorImageUrl.value = vendorData['imageUrl'] ?? '';
        vendorName.value = vendorData['name'] ?? '';
      }
    } catch (e) {
      print("Failed to fetch vendor info: $e");
    }
  }

// ดึงข้อมูล vendor จาก vendor_reference
//  Future<void> fetchVendorInfo(DocumentReference vendorRef) async {
//     try {
//       DocumentSnapshot vendorSnapshot = await vendorRef.get();
//       if (vendorSnapshot.exists) {
//         var vendorData = vendorSnapshot.data() as Map<String, dynamic>;
//         vendorImageUrl.value = vendorData['imageUrl'] ?? '';
//         vendorName.value = vendorData['vendor_name'] ?? '';
//       }
//     } catch (e) {
//       print("Failed to fetch vendor info: $e");
//     }
//   }

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
    FirebaseFirestore.instance
        .collection(productsCollection)
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
    qty,
    tprice,
    context,
    vendorID,
    productsize,
    documentId,
  }) async {
    try {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection(cartCollection).add({
        'user_id': currentUser!.uid,
        'product_id': documentId,
        'qty': qty,
        'vendor_id': vendorID,
        'total_price': tprice,
        'select_size': productsize,
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
      'favorite_uid': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to wishlist");
  }

  void addFavoriteDetail(
      Map<String, dynamic> product, Function(bool) updateIsFav, context) {
    FirebaseFirestore.instance
        .collection(productsCollection)
        .where('name', isEqualTo: product['name'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        List<dynamic> wishlist = doc['favorite_uid'];
        if (!wishlist.contains(currentUser!.uid)) {
          doc.reference.update({
            'favorite_uid': FieldValue.arrayUnion([currentUser!.uid])
          }).then((value) {
            updateIsFav(true);
            VxToast.show(context, msg: "Added from favorite");
          }).catchError((error) {
            print('Error adding to Favorite: $error');
          }).catchError((error) {
            print('Error adding ${product['name']} to Favorite: $error');
          });
        }
      }
    });
  }

  void removeFavoriteDetail(
      Map<String, dynamic> product, Function(bool) updateIsFav, context) {
    FirebaseFirestore.instance
        .collection(productsCollection)
        .where('name', isEqualTo: product['name'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        List<dynamic> wishlist = doc['favorite_uid'];
        if (wishlist.contains(currentUser!.uid)) {
          doc.reference.update({
            'favorite_uid': FieldValue.arrayRemove([currentUser!.uid])
          }).then((value) {
            updateIsFav(false);
            VxToast.show(context, msg: "Removed from favorite");
          }).catchError((error) {
            print('Error removing ${product['name']} from Favorite: $error');
          });
        }
      }
    });
  }

  void addToWishlistMatch(
      String productNameTop, String productNameLower, BuildContext context) {
    List<String> productNames = [productNameTop, productNameLower];
    FirebaseFirestore.instance
        .collection(productsCollection)
        .where('p_name', whereIn: productNames)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          // Using null safety checks to handle possible null values
          List<dynamic> wishlist =
              (doc.data() as Map<String, dynamic>?)?['favorite_uid']
                      as List<dynamic>? ??
                  [];
          String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
          if (!wishlist.contains(currentUserUID)) {
            doc.reference.update({
              'favorite_uid': FieldValue.arrayUnion([currentUserUID])
            }).then((value) {
              VxToast.show(context,
                  msg: "Added from favorite",
                  bgColor: greyColor.withOpacity(0.8));
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

  void addPostByUserMatch(
      String productNameTop,
      String productNameLower,
      BuildContext context,
      String selectedGender,
      List<String> selectedCollections,
      List<String> selectedSituations,
      String explanation,
      String productIdTop,
      String productIdLower) {
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
            .where('name', whereIn: productNames)
            .get()
            .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            Map<String, dynamic> userData = {
              'user_id': currentUserUID,
              'collection': selectedCollections,
              'situations': selectedSituations,
              'gender': selectedGender,
              'description': explanation,
              'favorite_userid': FieldValue.arrayUnion([]),
              'created_at': Timestamp.now(),
              'product_id_top': productIdTop,
              'product_id_lower': productIdLower,
            };

            querySnapshot.docs.forEach((doc) {
              var data = doc.data() as Map<String, dynamic>?;
              var wishlist = (data?['favorite_userid'] as List<dynamic>?) ?? [];

              if (!wishlist.contains(currentUserUID)) {
                userData['views'] = 0;
                userData['favorite_count'] = 0;
                if (doc['name'] == productNameTop) {
                  userData['vendor_id_top'] = doc['vendor_id'];
                } else if (doc['name'] == productNameLower) {
                  userData['vendor_id_lower'] = doc['vendor_id'];
                }
              }
            });

            if (userData.keys.length > 1) {
              // Check if any product info was added
              FirebaseFirestore.instance
                  .collection('usermixandmatch')
                  .add(userData)
                  .then((documentReference) {
                // Save the document ID
                String documentID = documentReference.id;
                FirebaseFirestore.instance
                    .collection('usermixandmatch')
                    .doc(documentID)
                    .update({'id': documentID}).then((_) {
                  VxToast.show(context, msg: "Added post successful.");
                  print(
                      'Data added in usermixandmatch collection with document ID: $documentID');
                  Navigator.pop(context);
                }).catchError((error) {
                  print('Error updating document ID: $error');
                  VxToast.show(context, msg: "Error updating document ID.");
                });
              }).catchError((error) {
                print(
                    'Error adding data in usermixandmatch collection: $error');
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

  void addToWishlistUserMatch(
      String productNameTop, String productNameLower, BuildContext context) {
    List<String> productNames = [productNameTop, productNameLower];
    FirebaseFirestore.instance
        .collection(productsCollection)
        .where('name', whereIn: productNames)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
        Map<String, dynamic> userData = {
          'favorite_uid': [currentUserUID]
        };

        String? topProductId;
        String? lowerProductId;

        querySnapshot.docs.forEach((doc) {
          var data = doc.data() as Map<String, dynamic>?;
          var wishlist = (data?['favorite_uid'] as List<dynamic>?) ?? [];

          if (!wishlist.contains(currentUserUID)) {
            if (doc['name'] == productNameTop) {
              topProductId = doc.id;
            } else if (doc['name'] == productNameLower) {
              lowerProductId = doc.id;
            }
          }
        });

        if (topProductId != null && lowerProductId != null) {
          FirebaseFirestore.instance
              .collection('usermatchfavorite')
              .where('product_id_top', isEqualTo: topProductId)
              .where('product_id_lower', isEqualTo: lowerProductId)
              .get()
              .then((QuerySnapshot existingFavorites) {
            if (existingFavorites.docs.isNotEmpty) {
              var existingDoc = existingFavorites.docs.first;
              var existingData = existingDoc.data() as Map<String, dynamic>?;
              var existingFavoritesList =
                  (existingData?['favorite_uid'] as List<dynamic>?) ?? [];
              if (!existingFavoritesList.contains(currentUserUID)) {
                existingFavoritesList.add(currentUserUID);
                existingDoc.reference.update({
                  'favorite_uid': existingFavoritesList,
                }).then((_) {
                  VxToast.show(context,
                      msg: "Added to existing wishlist and user mix-match.");
                  print(
                      'Updated existing document in usermatchfavorite collection with document ID: ${existingDoc.id}');
                }).catchError((error) {
                  print(
                      'Error updating document in usermatchfavorite collection: $error');
                  VxToast.show(context, msg: "Error updating wishlist.");
                });
              } else {
                VxToast.show(context, msg: "Products already in wishlist.");
              }
            } else {
              userData['product_id_top'] = topProductId;
              userData['product_id_lower'] = lowerProductId;

              FirebaseFirestore.instance
                  .collection('usermatchfavorite')
                  .add(userData)
                  .then((documentReference) {
                VxToast.show(context,
                    msg: "Added to wishlist and user mix-match.");
                print(
                    'Data added in usermixandmatch collection with document ID: ${documentReference.id}');
              }).catchError((error) {
                print(
                    'Error adding data in usermixandmatch collection: $error');
                VxToast.show(context, msg: "Error adding to wishlist.");
              });
            }
          }).catchError((error) {
            print('Error retrieving usermatchfavorite documents: $error');
            VxToast.show(context, msg: "Error retrieving usermatchfavorite.");
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
      'favorite_uid': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: "Removed from favorite");
  }

  checkIfFav(data) async {
    if (data['favorite_uid'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }
}

var dayOfWeek = ''.obs;

/* function Match */
Future<void> fetchUserBirthday() async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('birthday')) {
          String birthdayString = userData['birthday'];

          // แยกวันที่ออกจากวันในสัปดาห์
          List<String> parts = birthdayString.split(', ');
          if (parts.length == 2) {
            String dateString = parts[1];

            // แปลงวันที่เป็น DateTime
            DateTime birthday = DateFormat('dd/MM/yyyy').parse(dateString);

            String formattedDate = DateFormat('dd MMMM yyyy').format(birthday);
            String day = DateFormat('EEEE').format(birthday);

            dayOfWeek.value = day; // เก็บค่า dayOfWeek ใน state

            print('User was born on: $formattedDate');
            print('Day of the week: $dayOfWeek');
          } else {
            print('Invalid birthday format for user $userId');
          }
        } else {
          print('Birthday field is missing for user $userId');
        }
      } else {
        print('User not found');
      }
    } else {
      print('No current user signed in');
    }
  } catch (e) {
    print('Error fetching user birthday: $e');
  }
}

Future<int?> fetchUserSkinTone() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    if (userDoc.exists) {
      return userDoc.data()?['skinTone'];
    }
  }
  return null;
}

int findClosestColor(int colorValue) {
  int closestColorValue = allColors[0]['value'];
  double minDistance = double.infinity;

  for (var color in allColors) {
    double distance = calculateColorDistance(colorValue, color['value']);
    if (distance < minDistance) {
      minDistance = distance;
      closestColorValue = color['value'];
    }
  }

  return closestColorValue;
}

double calculateColorDistance(int color1, int color2) {
  int r1 = (color1 >> 16) & 0xFF;
  int g1 = (color1 >> 8) & 0xFF;
  int b1 = color1 & 0xFF;

  int r2 = (color2 >> 16) & 0xFF;
  int g2 = (color2 >> 8) & 0xFF;
  int b2 = color2 & 0xFF;

  return sqrt(
          (r1 - r2) * (r1 - r2) + (g1 - g2) * (g1 - g2) + (b1 - b2) * (b1 - b2))
      .toDouble();
}

String getColorName(int colorValue) {
  final color = allColors.firstWhere(
    (element) => element['value'] == colorValue,
    orElse: () => {'name': 'Unknown'},
  );
  return color['name'];
}

String getSkinToneDescription(int skinTone) {
  switch (skinTone) {
    case 4294961114:
      return 'Fair Skin';
    case 4294494620:
      return 'Medium Skin';
    case 4290348898:
      return 'Tan Skin';
    case 4285812284:
      return 'Dark Skin';
    default:
      return 'Unknown Skin Tone';
  }
}

Map<int, String> getRecommendedColors(String dayOfWeek) {
  switch (dayOfWeek) {
    case 'Sunday':
      return {
        0xFFFF0000:
            'Red: Represents power and confidence. As Sunday is associated with the sun, red is a symbol',
        0xFFFFFFFF:
            'White: Represents purity and tranquility, enhancing creativity',
        0xFFFFC0CB:
            'Pink: Represents love and kindness, fostering good relationships',
        0xFF17770F: 'Green: Represents balance and calmness',
        0xFF000000: 'Black: Represents stability and strength',
        0xFF621C8D: 'Purple: Represents luxury and intelligence',
        0xFFFFA500: 'Orange: Represents happiness and warmth',
        0xFF808080: 'Gray: Represents calmness and composure'
      };
    case 'Monday':
      return {
        0xFFFFFF00: 'Yellow: Represents warmth and brightness',
        0xFFFFFFFF: 'White: Represents purity and tranquility',
        0xFF17770F: 'Green: Represents balance and calmness',
        0xFF621C8D: 'Purple: Represents luxury and intelligence',
        0xFFFFA500: 'Orange: Represents happiness and warmth',
        0xFF30B0E8: 'Light Blue: Represents calmness and coolness',
        0xFF202FB3: 'Blue: Represents stability and trust'
      };
    case 'Tuesday':
      return {
        0xFFFFC0CB: 'Pink: Represents love and kindness',
        0xFF17770F: 'Green: Represents balance and calmness',
        0xFF621C8D: 'Purple: Represents luxury and intelligence',
        0xFFFFA500: 'Orange: Represents happiness and warmth',
        0xFF808080: 'Gray: Represents calmness and composure',
        0xFF30B0E8: 'Light Blue: Represents calmness and coolness',
        0xFF202FB3: 'Blue: Represents stability and trust',
        0xFFFF0000: 'Red: Represents power and confidence'
      };
    case 'Wednesday':
      return {
        0xFF17770F: 'Green: Represents balance and calmness',
        0xFF621C8D: 'Purple: Represents luxury and intelligence',
        0xFFFFD700: 'Gold: Represents prosperity and wealth',
        0xFF808080: 'Gray: Represents calmness and composure',
        0xFF202FB3: 'Blue: Represents stability and trust',
        0xFF30B0E8: 'Light Blue: Represents calmness and coolness',
        0xFFFF0000: 'Red: Represents power and confidence',
        0xFFFFFF00: 'Yellow: Represents warmth and brightness',
        0xFFFFFFFF: 'White: Represents purity and tranquility',
        0xFFFFC0CB: 'Pink: Represents love and kindness'
      };
    case 'Thursday':
      return {
        0xFFFFA500: 'Orange: Represents happiness and warmth',
        0xFF808080: 'Gray: Represents calmness and composure',
        0xFF202FB3: 'Blue: Represents stability and trust',
        0xFFFF0000: 'Red: Represents power and confidence',
        0xFFFFFF00: 'Yellow: Represents warmth and brightness',
        0xFFFFFFFF: 'White: Represents purity and tranquility',
        0xFFFFC0CB: 'Pink: Represents love and kindness',
        0xFF17770F: 'Green: Represents balance and calmness'
      };
    case 'Friday':
      return {
        0xFF202FB3: 'Blue: Represents stability and trust',
        0xFFFF0000: 'Red: Represents power and confidence',
        0xFFFFFF00: 'Yellow: Represents warmth and brightness',
        0xFFFFFFFF: 'White: Represents purity and tranquility',
        0xFFFFC0CB: 'Pink: Represents love and kindness',
        0xFF17770F: 'Green: Represents balance and calmness',
        0xFF621C8D: 'Purple: Represents luxury and intelligence',
        0xFFFFA500: 'Orange: Represents happiness and warmth',
        0xFF808080: 'Gray: Represents calmness and composure'
      };
    case 'Saturday':
      return {
        0xFF000000: 'Black: Represents stability and strength',
        0xFF621C8D: 'Purple: Represents luxury and intelligence',
        0xFF808080: 'Gray: Represents calmness and composure',
        0xFF202FB3: 'Blue: Represents stability and trust',
        0xFFFF0000: 'Red: Represents power and confidence',
        0xFFFFFF00: 'Yellow: Represents warmth and brightness',
        0xFFFFFFFF: 'White: Represents purity and tranquility',
        0xFFFFC0CB: 'Pink: Represents love and kindness'
      };
    default:
      return {};
  }
}

final Map<int, Map<String, List<int>>> skinToneMatchMap = {
  4294961114: {
    'lightColors': [0xFFFF4081, 0xFFADD8E6, 0xFFFFFFFF, 0xFF32CD32],
    'brightColors': [
      0xFFFF0000,
      0xFFFF69B4,
      0xFF0000FF,
      0xFF008000,
      0xFFFFFF00
    ],
    'darkColors': [0xFF000000, 0xFF4B0082, 0xFF808080],
  },
  4294494620: {
    // Medium Skin
    'lightColors': [0xFFFFFFFF, 0xFFFFA500, 0xFFADD8E6, 0xFF9370DB],
    'brightColors': [0xFFFFA500, 0xFF32CD32, 0xFFFF0000, 0xFFFFFF00],
    'darkColors': [0xFF0000FF, 0xFF4B0082, 0xFF808080],
  },
  4290348898: {
    // Tan Skin
    'lightColors': [0xFFFFFFFF, 0xFFFF4081, 0xFFADD8E6],
    'brightColors': [0xFFFFFF00, 0xFFFFA500, 0xFF008000, 0xFF9370DB],
    'darkColors': [0xFF0000FF, 0xFF8B4513, 0xFF808080, 0xFF006400],
  },
  4285812284: {
    // Dark Skin
    'lightColors': [0xFFFFFFFF, 0xFFD3D3D3, 0xFFFFA500],
    'brightColors': [0xFFFF0000, 0xFFFFFF00, 0xFFFFA500, 0xFF9370DB],
    'darkColors': [0xFF00008B, 0xFF4B0082, 0xFF006400, 0xFF000000],
  },
};

final List<Map<String, dynamic>> allColors = [
  {'name': 'Black', 'color': blackColor, 'value': 0xFF000000},
  {'name': 'Grey', 'color': greyColor, 'value': 0xFF808080},
  {'name': 'White', 'color': whiteColor, 'value': 0xFFFFFFFF},
  {
    'name': 'Purple',
    'color': const Color.fromRGBO(98, 28, 141, 1),
    'value': 0xFF621C8D
  },
  {
    'name': 'Deep Purple',
    'color': const Color.fromRGBO(202, 147, 235, 1),
    'value': 0xFFCA93EB
  },
  {
    'name': 'Blue',
    'color': Color.fromRGBO(32, 47, 179, 1),
    'value': 0xFF202FB3
  },
  {
    'name': 'Light blue',
    'color': const Color.fromRGBO(48, 176, 232, 1),
    'value': 0xFF30B0E8
  },
  {
    'name': 'Blue Grey',
    'color': const Color.fromRGBO(83, 205, 191, 1),
    'value': 0xFF53CDBF
  },
  {
    'name': 'Green',
    'color': const Color.fromRGBO(23, 119, 15, 1),
    'value': 0xFF17770F
  },
  {
    'name': 'Lime Green',
    'color': Color.fromRGBO(98, 207, 47, 1),
    'value': 0xFF62CF2F
  },
  {'name': 'Yellow', 'color': Colors.yellow, 'value': 0xFFFFFF00},
  {'name': 'Orange', 'color': Colors.orange, 'value': 0xFFFFA500},
  {'name': 'Pink', 'color': Colors.pinkAccent, 'value': 0xFFFF4081},
  {'name': 'Red', 'color': Colors.red, 'value': 0xFFFF0000},
  {
    'name': 'Brown',
    'color': Color.fromARGB(255, 121, 58, 31),
    'value': 0xFF793A1F
  },
];

final Map<int, List<int>> colorMatchMap = {
  0xFF000000: [
    0xFF000000, // Black
    0xFFFFFFFF, // White
    0xFF808080, // Grey
    0xFFFF0000, // Red
    0xFFFFFF00, // Yellow
    0xFFFF4081, // Pink
    0xFF621C8D, // Purple
    0xFF202FB3, // Blue
    0xFF30B0E8, // Light Blue
    0xFF53CDBF, // Blue Grey
    0xFF17770F, // Green
    0xFF62CF2F, // Lime Green
    0xFFFFA500, // Orange
  ],
// Black matches with several colors
  0xFFFFFFFF: [
    0xFF000000, // Black
    0xFF808080, // Grey
    0xFF202FB3, // Blue
    0xFF30B0E8, // Light Blue
    0xFFFFFF00, // Yellow
    0xFFFF4081, // Pink
    0xFFFF0000, // Red
    0xFF621C8D, // Purple
    0xFF62CF2F, // Lime Green
    0xFFFFA500, // Orange
  ], // White matches with several colors
  0xFF202FB3: [
    0xFF000000, // Black
    0xFFFFFFFF, // White
    0xFF808080, // Grey
    0xFF30B0E8, // Light Blue
    0xFFFFFF00, // Yellow
    0xFFFF4081, // Pink
    0xFF62CF2F, // Lime Green
    0xFFFFA500, // Orange
  ], // Blue matches with several colors
  0xFF808080: [
    0xFF000000, // Black
    0xFFFFFFFF, // White
    0xFF202FB3, // Blue
    0xFF30B0E8, // Light Blue
    0xFFFFFF00, // Yellow
    0xFFFF4081, // Pink
    0xFFFF0000, // Red
    0xFF621C8D, // Purple
    0xFF62CF2F, // Lime Green
    0xFFFFA500, // Orange
    0xFF17770F, // Green
  ], // Grey matches with several colors
  0xFFFF4081: [
    0xFF000000, // Black
    0xFFFFFFFF, // White
    0xFF808080, // Grey
    0xFF202FB3, // Blue
    0xFF30B0E8, // Light Blue
    0xFFFFFF00, // Yellow
    0xFF621C8D, // Purple
    0xFF17770F, // Green
    0xFF62CF2F, // Lime Green
    0xFFFFA500, // Orange
  ],

  0xFF793A1F: [
    0xFF000000, // Black
    0xFFFFFFFF, // White
    0xFF808080, // Grey
    0xFF202FB3, // Blue
    0xFF30B0E8, // Light Blue
    0xFFFFFF00, // Yellow
    0xFFFF4081, // Pink
    0xFFFFA500, // Orange
  ], // Brown matches with several colors
  0xFFFF0000: [
    0xFF000000, // Black
    0xFFFFFFFF, // White
    0xFF808080, // Grey
    0xFF202FB3, // Blue
    0xFF30B0E8, // Light Blue
    0xFFFFFF00, // Yellow
    0xFFFF4081, // Pink
    0xFF621C8D, // Purple
    0xFF17770F, // Green
    0xFFFFA500, // Orange
  ], // Red matches with several colors
  0xFF621C8D: [
    0xFF000000, // Black
    0xFFFFFFFF, // White
    0xFF808080, // Grey
    0xFF30B0E8, // Light Blue
    0xFFFFFF00, // Yellow
    0xFFFF4081, // Pink
    0xFF62CF2F, // Lime Green
  ], // Purple matches with several colors
  0xFFFFFF00: [
    0xFF000000, // Black
    0xFFFFFFFF, // White
    0xFF808080, // Grey
    0xFF202FB3, // Blue
    0xFF30B0E8, // Light Blue
    0xFFFF4081, // Pink
    0xFF621C8D, // Purple
    0xFF17770F, // Green
    0xFF62CF2F, // Lime Green
    0xFFFFA500, // Orange
  ], // Yellow matches with several colors
  0xFFCA93EB: [
    0xFF000000, // Black
    0xFFFFFFFF, // White
    0xFF808080, // Grey
    0xFF30B0E8, // Light Blue
    0xFFFFFF00, // Yellow
    0xFFFF4081, // Pink
    0xFF62CF2F, // Lime Green
  ], // Deep Purple matches with several colors
  0xFF30B0E8: [
    0xFF000000, // Black
    0xFFFFFFFF, // White
    0xFF808080, // Grey
    0xFFFFFF00, // Yellow
    0xFFFF4081, // Pink
    0xFFFF0000, // Red
    0xFF621C8D, // Purple
    0xFF62CF2F, // Lime Green
    0xFFFFA500, // Orange
  ], // Light Blue matches with several colors
  0xFF53CDBF: [
    0xFF000000, // Black
    0xFFFFFFFF, // White
    0xFF808080, // Grey
    0xFF30B0E8, // Light Blue
    0xFFFFFF00, // Yellow
    0xFFFF4081, // Pink
    0xFF62CF2F, // Lime Green
    0xFFFFA500, // Orange
  ], // Blue Grey matches with several colors
  0xFF17770F: [
    0xFF000000, // Black
    0xFFFFFFFF, // White
    0xFF808080, // Grey
    0xFF30B0E8, // Light Blue
    0xFFFFFF00, // Yellow
    0xFFFF4081, // Pink
    0xFF62CF2F, // Lime Green
    0xFFFFA500, // Orange
  ],
  // Green matches with several colors
  0xFFFFA500: [
    0xFF000000, // Black
    0xFFFFFFFF, // White
    0xFF808080, // Grey
    0xFF202FB3, // Blue
    0xFF30B0E8, // Light Blue
    0xFFFF4081, // Pink
    0xFF621C8D, // Purple
    0xFF17770F, // Green
    0xFF62CF2F, // Lime Green
    0xFFFFFF00, // Yellow
  ],
  0xFF62CF2F: [
    0xFF000000, // Black
    0xFFFFFFFF, // White
    0xFF808080, // Grey
    0xFF30B0E8, // Light Blue
    0xFFFFFF00, // Yellow
    0xFFFF4081, // Pink
    0xFF621C8D, // Purple
    0xFFFFA500, // Orange
  ], // Lime Green matches with several colors
};

final Map<int, List<int>> colorNotMatchMap = {
  0xFF000000: [
    0xFF793A1F, // Brown
    0xFFCA93EB, // Deep Purple
  ],
  0xFF808080: [
    0xFF793A1F, // Brown
    0xFFCA93EB, // Deep Purple
    0xFF53CDBF, // Blue Grey
    0xFF62CF2F, // Lime Green
    0xFFFFFF00, // Yellow
    0xFFFFA500, // Orange
    0xFFFF4081, // Pink
    0xFF17770F, // Green
  ],
  0xFFFFFFFF: [
    0xFF793A1F, // Brown
    0xFFCA93EB, // Deep Purple
    0xFF53CDBF, // Blue Grey
  ],
  0xFF621C8D: [
    0xFF793A1F, // Brown
    0xFFFF0000, // Red
    0xFF53CDBF, // Blue Grey
    0xFF202FB3, // Blue
  ],
  0xFFCA93EB: [
    0xFF793A1F, // Brown
    0xFFFF0000, // Red
    0xFF53CDBF, // Blue Grey
    0xFF202FB3, // Blue
  ],
  0xFF202FB3: [
    0xFF793A1F, // Brown
    0xFFFF0000, // Red
    0xFF621C8D, // Purple
    0xFF53CDBF, // Blue Grey
  ],
  0xFF30B0E8: [
    0xFF793A1F, // Brown
    0xFFCA93EB, // Deep Purple
    0xFF53CDBF, // Blue Grey
  ],
  0xFF53CDBF: [
    0xFF793A1F, // Brown
    0xFFFF0000, // Red
    0xFF621C8D, // Purple
    0xFFCA93EB, // Deep Purple
  ],
  0xFF17770F: [
    0xFF793A1F, // Brown
    0xFFFF0000, // Red
    0xFF621C8D, // Purple
    0xFFCA93EB, // Deep Purple
  ],
  0xFF62CF2F: [
    0xFF793A1F, // Brown
    0xFFFF0000, // Red
    0xFFCA93EB, // Deep Purple
    0xFF53CDBF, // Blue Grey
  ],
  0xFFFFFF00: [
    0xFF793A1F, // Brown
    0xFFFF0000, // Red
    0xFFCA93EB, // Deep Purple
    0xFF53CDBF, // Blue Grey
  ],
  0xFFFFA500: [
    0xFF793A1F, // Brown
    0xFFFF0000, // Red
    0xFFCA93EB, // Deep Purple
    0xFF53CDBF, // Blue Grey
  ],
  0xFFFF4081: [
    0xFF793A1F, // Brown
    0xFFFF0000, // Red
    0xFFCA93EB, // Deep Purple
    0xFF53CDBF, // Blue Grey
  ],
  0xFFFF0000: [
    0xFF793A1F, // Brown
    0xFFCA93EB, // Deep Purple
    0xFF53CDBF, // Blue Grey
    0xFF62CF2F, // Lime Green
  ],
  0xFF793A1F: [
    0xFFFF0000, // Red
    0xFF621C8D, // Purple
    0xFF62CF2F, // Lime Green
    0xFF53CDBF, // Blue Grey
  ],
};

String getAdditionalReason(int color1, int color2) {
  if ((color1 == 0xFF000000 && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF000000)) {
    return 'The high contrast between black and white creates a striking and formal appearance. Additionally, black enhances the cleanliness and brightness of white.';
  } else if (color1 == 0xFF000000 && color2 == 0xFF000000) {
    return 'Pairing black with black creates a somber and powerful look, making it appear modern and intriguing.';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF808080) ||
      (color1 == 0xFF808080 && color2 == 0xFF000000)) {
    return 'Pairing neutral tones creates a simple and modern feel. Additionally, gray adds a softness to an all-black outfit.';
  } else if ((color1 == 0xFF000000 && color2 == 0xFFFF0000) ||
      (color1 == 0xFFFF0000 && color2 == 0xFF000000)) {
    return 'Red adds vibrancy to an otherwise plain black outfit, creating a striking and lively appearance.';
  } else if ((color1 == 0xFF000000 && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF000000)) {
    return 'The brightness of yellow creates an interesting contrast, making the outfit look energetic and fun.';
  } else if ((color1 == 0xFF000000 && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFF000000)) {
    return 'Pink adds a touch of softness and friendliness, preventing an all-black outfit from appearing too somber.';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF621C8D) ||
      (color1 == 0xFF621C8D && color2 == 0xFF000000)) {
    return 'Purple adds a touch of luxury and intrigue, giving a black outfit a sense of depth.';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF202FB3) ||
      (color1 == 0xFF202FB3 && color2 == 0xFF000000)) {
    return 'Blue infuses a black outfit with energy and brightness.';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF30B0E8) ||
      (color1 == 0xFF30B0E8 && color2 == 0xFF000000)) {
    return 'Light blue adds a touch of softness and modernity, preventing a black outfit from appearing too intense.';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF53CDBF) ||
      (color1 == 0xFF53CDBF && color2 == 0xFF000000)) {
    return 'Sky blue adds brightness and vitality to a black outfit.';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF17770F) ||
      (color1 == 0xFF17770F && color2 == 0xFF000000)) {
    return 'Green adds brightness and energy to a black outfit.';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF62CF2F) ||
      (color1 == 0xFF62CF2F && color2 == 0xFF000000)) {
    return 'Lime green adds brightness and vibrancy to a black outfit.';
  } else if ((color1 == 0xFF000000 && color2 == 0xFFFFA500) ||
      (color1 == 0xFFFFA500 && color2 == 0xFF000000)) {
    return 'Orange adds fun and energy to a black outfit';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFF808080)) {
    return 'A classic and polite combination, simple and modern. Black makes gray appear clear and prominent';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF0000FF) ||
      (color1 == 0xFF0000FF && color2 == 0xFF808080)) {
    return 'A professional and not over-the-top combination. Blue brightens up gray';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF32CD32) ||
      (color1 == 0xFF32CD32 && color2 == 0xFF808080)) {
    return 'Lime green adds brightness and vibrancy to the outfit. Green also gives gray a sense of energy';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFF808080)) {
    return 'Pink provides a warm and soft feel, making gray look more interesting';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF4B0082) ||
      (color1 == 0xFF4B0082 && color2 == 0xFF808080)) {
    return 'The depth of purple adds luxury and formality to the outfit';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF17770F) ||
      (color1 == 0xFF17770F && color2 == 0xFF808080)) {
    return 'Green makes gray look fresh and lively';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF30B0E8) ||
      (color1 == 0xFF30B0E8 && color2 == 0xFF808080)) {
    return 'Light blue makes gray look more interesting and easy on the eyes';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF53CDBF) ||
      (color1 == 0xFF53CDBF && color2 == 0xFF808080)) {
    return 'Sky blue gives gray a balanced and soothing look';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFFFFFFFF)) {
    return 'High contrast creates a clean and professional look. Black makes white stand out';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFF808080) ||
      (color1 == 0xFF808080 && color2 == 0xFFFFFFFF)) {
    return 'Gray is a neutral tone that pairs simply with white, making the outfit look soft and modern';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFF0000FF) ||
      (color1 == 0xFF0000FF && color2 == 0xFFFFFFFF)) {
    return 'Blue adds a refreshing and formal touch, making the outfit look lively';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFF4B0082) ||
      (color1 == 0xFF4B0082 && color2 == 0xFFFFFFFF)) {
    return 'Dark purple adds depth and luxury to the outfit, making white look sophisticated';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFF32CD32) ||
      (color1 == 0xFF32CD32 && color2 == 0xFFFFFFFF)) {
    return 'Lime green adds brightness and freshness, making the outfit look energetic and fun';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFFFFFFFF)) {
    return 'Pink makes white look soft and bright';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFFFFA500) ||
      (color1 == 0xFFFFA500 && color2 == 0xFFFFFFFF)) {
    return 'Orange makes white look bright and interesting';
  } else if ((color1 == 0xFF621C8D && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF621C8D)) {
    return 'White makes purple stand out and look clean, adding brightness to a purple outfit';
  } else if ((color1 == 0xFF621C8D && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFF621C8D)) {
    return 'Black adds depth and mystery to the outfit, making it look more dimensional';
  } else if ((color1 == 0xFF621C8D && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF621C8D)) {
    return 'Yellow creates an interesting and bright contrast, making the outfit stand out and look lively';
  } else if ((color1 == 0xFF621C8D && color2 == 0xFF32CD32) ||
      (color1 == 0xFF32CD32 && color2 == 0xFF621C8D)) {
    return 'Lime green adds freshness and vibrancy, making the outfit look fun and energetic';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF4B0082)) {
    return 'White helps dark purple stand out without being too dark, making the outfit look clean and modern';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFF808080) ||
      (color1 == 0xFF808080 && color2 == 0xFF4B0082)) {
    return 'Gray adds luxury and formality to the outfit, making it more dimensional';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFF0000FF) ||
      (color1 == 0xFF0000FF && color2 == 0xFF4B0082)) {
    return 'Blue adds a professional touch without being too much, making the outfit balanced';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFF4B0082)) {
    return 'Pink adds softness and romance to the outfit, making it warm and friendly';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF4B0082)) {
    return 'Yellow makes dark purple look bright and lively';
  } else if ((color1 == 0xFF0000FF && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF0000FF)) {
    return 'White makes the outfit look clean and fresh, making blue stand out';
  } else if ((color1 == 0xFF0000FF && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFF0000FF)) {
    return 'Black adds contrast and formality to the outfit, making blue look powerful';
  } else if ((color1 == 0xFF0000FF && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF0000FF)) {
    return 'Yellow adds brightness and vibrancy, making the outfit fun and interesting';
  } else if ((color1 == 0xFF0000FF && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFF0000FF)) {
    return 'Pink adds softness and friendliness, making blue look warmer';
  } else if ((color1 == 0xFF0000FF && color2 == 0xFF30B0E8) ||
      (color1 == 0xFF30B0E8 && color2 == 0xFF0000FF)) {
    return 'Light blue makes blue look balanced and easy on the eyes';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF30B0E8)) {
    return 'White makes the outfit look clean and fresh, making light blue stand out';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFF30B0E8)) {
    return 'Black adds contrast and formality, making light blue look powerful';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF30B0E8)) {
    return 'Yellow adds brightness and vibrancy, making the outfit fun and interesting';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF17770F) ||
      (color1 == 0xFF17770F && color2 == 0xFF30B0E8)) {
    return 'Green adds freshness and vibrancy, making the outfit bright and energetic';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF62CF2F) ||
      (color1 == 0xFF62CF2F && color2 == 0xFF30B0E8)) {
    return 'Lime green makes light blue look bright and vibrant';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFFA500) ||
      (color1 == 0xFFFFA500 && color2 == 0xFF30B0E8)) {
    return 'Orange makes light blue look energetic and fun';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF53CDBF)) {
    return 'White makes the outfit look clean and fresh, making sky blue stand out';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFF53CDBF)) {
    return 'Black adds contrast and formality, making sky blue look powerful';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFF53CDBF)) {
    return 'Pink adds softness and romance, making sky blue look warmer';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF53CDBF)) {
    return 'Yellow adds brightness and vibrancy, making the outfit fun and interesting';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFF62CF2F) ||
      (color1 == 0xFF62CF2F && color2 == 0xFF53CDBF)) {
    return 'Lime green makes sky blue look bright and vibrant';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFFFFA500) ||
      (color1 == 0xFFFFA500 && color2 == 0xFF53CDBF)) {
    return 'Orange makes sky blue look energetic and fun';
  } else if ((color1 == 0xFF17770F && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF17770F)) {
    return 'White makes green look bright && clean, making green stand out';
  } else if ((color1 == 0xFF17770F && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFF17770F)) {
    return 'Black adds contrast and mystery, making green look more dimensional';
  } else if ((color1 == 0xFF17770F && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF17770F)) {
    return 'Yellow adds brightness and vibrancy, making the outfit fun and interesting';
  } else if ((color1 == 0xFF17770F && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFF17770F)) {
    return 'Pink adds softness and friendliness, making green look warmer';
  } else if ((color1 == 0xFF17770F && color2 == 0xFFFFA500) ||
      (color1 == 0xFFFFA500 && color2 == 0xFF17770F)) {
    return 'Orange makes green look bright and energetic';
  } else if ((color1 == 0xFF62CF2F && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF62CF2F)) {
    return 'White makes lime green look bright && clean, making lime green stand out';
  } else if ((color1 == 0xFF62CF2F && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFF62CF2F)) {
    return 'Black adds contrast and mystery, making lime green look more dimensional';
  } else if ((color1 == 0xFF62CF2F && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF62CF2F)) {
    return 'Yellow makes lime green look bright and vibrant';
  } else if ((color1 == 0xFF62CF2F && color2 == 0xFFFF0000) ||
      (color1 == 0xFFFF0000 && color2 == 0xFF62CF2F)) {
    return 'Red makes lime green look bright and interesting';
  } else if ((color1 == 0xFF62CF2F && color2 == 0xFFFFA500) ||
      (color1 == 0xFFFFA500 && color2 == 0xFF62CF2F)) {
    return 'Orange makes lime green look bright and energetic';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFF202FB3)) {
    return 'Blue and pink make a bright and lively combination. Pink makes blue look warm && cute';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF202FB3)) {
    return 'Blue and yellow make a bright and lively combination. Yellow makes blue look energetic and interesting';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFF53CDBF) ||
      (color1 == 0xFF53CDBF && color2 == 0xFF202FB3)) {
    return 'Blue and sky blue make a bright and modern combination. Sky blue makes blue look more interesting and balanced';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFFFF0000) ||
      (color1 == 0xFFFF0000 && color2 == 0xFF202FB3)) {
    return 'Blue and red make a bright and powerful combination. Red makes blue stand out and look lively';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFF621C8D) ||
      (color1 == 0xFF621C8D && color2 == 0xFF202FB3)) {
    return 'Blue and purple make a deep and interesting combination. Purple makes blue look complex and soft';
  } else if (color1 == 0xFF202FB3 && color2 == 0xFF202FB3) {
    return 'Blue makes blue look balanced and easy on the eyes, creating a modern and interesting combination';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFF30B0E8) ||
      (color1 == 0xFF30B0E8 && color2 == 0xFF202FB3)) {
    return 'Light blue makes blue look bright and easy on the eyes';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFF62CF2F) ||
      (color1 == 0xFF62CF2F && color2 == 0xFF202FB3)) {
    return 'Lime green makes blue look bright and lively';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFFFFA500) ||
      (color1 == 0xFFFFA500 && color2 == 0xFF202FB3)) {
    return 'Orange makes blue look energetic and interesting';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFFFFE4C4)) {
    return 'Cream and white make a clean and polite combination. White makes cream look soft and bright';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFF808080) ||
      (color1 == 0xFF808080 && color2 == 0xFFFFE4C4)) {
    return 'Cream and gray make a soft and polite combination. Gray makes cream look modern and easy on the eyes';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFF793A1F) ||
      (color1 == 0xFF793A1F && color2 == 0xFFFFE4C4)) {
    return 'Cream and brown make a warm and soft combination. Brown makes cream look subtle and polite';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFFFFE4C4)) {
    return 'Cream and black make a contrasting and interesting combination. Black makes cream stand out and look polite';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFFFFE4C4)) {
    return 'Cream and yellow make a bright and lively combination. Yellow makes cream look energetic and interesting';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFF202FB3) ||
      (color1 == 0xFF202FB3 && color2 == 0xFFFFE4C4)) {
    return 'Cream and blue make a modern and bright combination. Blue makes cream look balanced and soft';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFF17770F) ||
      (color1 == 0xFF17770F && color2 == 0xFFFFE4C4)) {
    return 'Cream and green make a fresh and soft combination. Green makes cream look energetic and polite';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFFFFE4C4)) {
    return 'Cream and pink make a cute and bright combination. Pink makes cream look warm and lively';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFFFF0000) ||
      (color1 == 0xFFFF0000 && color2 == 0xFFFFE4C4)) {
    return 'Cream and red make a standout and powerful combination. Red makes cream look interesting and lively';
  } else if ((color1 == 0xFF793A1F && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF793A1F)) {
    return 'Brown and white make a clean and polite combination. White makes brown look soft and bright';
  } else if ((color1 == 0xFF793A1F && color2 == 0xFF808080) ||
      (color1 == 0xFF808080 && color2 == 0xFF793A1F)) {
    return 'Brown and gray make a soft and polite combination. Gray makes brown look modern and easy on the eyes';
  } else if ((color1 == 0xFF793A1F && color2 == 0xFF202FB3) ||
      (color1 == 0xFF202FB3 && color2 == 0xFF793A1F)) {
    return 'Brown and blue make a modern and bright combination. Blue makes brown look balanced and soft';
  } else if ((color1 == 0xFF793A1F && color2 == 0xFF17770F) ||
      (color1 == 0xFF17770F && color2 == 0xFF793A1F)) {
    return 'Brown and green make a fresh and soft combination. Green makes brown look energetic and polite';
  } else if ((color1 == 0xFF793A1F && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF793A1F)) {
    return 'Brown and yellow make a bright and lively combination. Yellow makes brown look energetic and interesting';
  } else if ((color1 == 0xFFFF0000 && color2 == 0xFF621C8D) ||
      (color1 == 0xFF621C8D && color2 == 0xFFFF0000)) {
    return 'Red and purple make a deep and interesting combination. Purple makes red look complex and soft';
  } else if ((color1 == 0xFFFF0000 && color2 == 0xFF793A1F) ||
      (color1 == 0xFF793A1F && color2 == 0xFFFF0000)) {
    return 'Red and brown make a warm and polite combination. Brown makes red look interesting and lively';
  } else if ((color1 == 0xFFFF0000 && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFFFF0000)) {
    return 'Red and pink make a cute and bright combination. Pink makes red look warm and lively';
  } else if ((color1 == 0xFFFF0000 && color2 == 0xFF17770F) || (color1 == 0xFF17770F && color2 == 0xFFFF0000)) {
    return 'Red and green make a bright and energetic combination. Green makes red look lively and interesting';
  } else if ((color1 == 0xFFFF0000 && color2 == 0xFFFFFF00) || (color1 == 0xFFFFFF00 && color2 == 0xFFFF0000)) {
    return 'Red and yellow make a bright and energetic combination. Yellow makes red look standout and lively';
  } else if ((color1 == 0xFFFF0000 && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFFFF0000)) {
    return 'Light blue makes red look soft and balanced';
  } else if ((color1 == 0xFFFF4081 && color2 == 0xFF17770F) || (color1 == 0xFF17770F && color2 == 0xFFFF4081)) {
    return 'Pink and green have too much contrast and often do not match well, as pink is soft and warm while green is fresh and energetic';
  } else if ((color1 == 0xFFFF4081 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFFFF4081)) {
    return 'Lime green makes pink look bright and lively';
  } else if ((color1 == 0xFFFF4081 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFFFF4081)) {
    return 'Orange makes pink look bright and energetic';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFF793A1F) || (color1 == 0xFF793A1F && color2 == 0xFFFFFF00)) {
    return 'Yellow and brown make a bright and energetic combination. Brown makes yellow look balanced and interesting';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFF621C8D) || (color1 == 0xFF621C8D && color2 == 0xFFFFFF00)) {
    return 'Yellow and purple make a deep and interesting combination. Purple makes yellow look complex and bright';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFFFFFF00)) {
    return 'Yellow and pink make a cute and bright combination. Pink makes yellow look warm and lively';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFF808080) || (color1 == 0xFF808080 && color2 == 0xFFFFFF00)) {
    return 'Yellow and gray make a bright and polite combination. Gray makes yellow look balanced and easy on the eyes';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFF202FB3) || (color1 == 0xFF202FB3 && color2 == 0xFFFFFF00)) {
    return 'Blue makes yellow look bright and lively';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFFFFFF00)) {
    return 'Light blue makes yellow look bright and easy on the eyes';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFFFFFF00)) {
    return 'Lime green makes yellow look bright and lively';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFFFFFF00)) {
    return 'Orange makes yellow look bright and energetic';
  } else if ((color1 == 0xFFFFA500 && color2 == 0xFF793A1F) || (color1 == 0xFF793A1F && color2 == 0xFFFFA500)) {
    return 'Orange and brown balance well together. Orange adds brightness and brown adds warmth';
  } else if ((color1 == 0xFFFFA500 && color2 == 0xFF621C8D) || (color1 == 0xFF621C8D && color2 == 0xFFFFA500)) {
    return 'Orange and purple make an interesting contrasting combination. Orange makes purple look bright and purple adds depth to orange';
  } else if ((color1 == 0xFFFFA500 && color2 == 0xFF202FB3) || (color1 == 0xFF202FB3 && color2 == 0xFFFFA500)) {
    return 'Blue makes orange look bright and interesting';
  } else if ((color1 == 0xFFFFA500 && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFFFFA500)) {
    return 'Light blue makes orange look bright and easy on the eyes';
  } else if ((color1 == 0xFFFFA500 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFFFFA500)) {
    return 'Lime green makes orange look bright and lively';
  } else if ((color1 == 0xFFFFA500 && color2 == 0xFF17770F) || (color1 == 0xFF17770F && color2 == 0xFFFFA500)) {
    return 'Green makes orange look bright and energetic';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF53CDBF) || (color1 == 0xFF53CDBF && color2 == 0xFF000000)) {
    return 'Sky blue adds brightness and vitality to a black outfit';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF17770F) || (color1 == 0xFF17770F && color2 == 0xFF000000)) {
    return 'Green adds brightness and energy to a black outfit';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF000000)) {
    return 'Lime green adds brightness and vibrancy to a black outfit';
  } else if ((color1 == 0xFF000000 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF000000)) {
    return 'Orange adds fun and energy to a black outfit';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFFFFFFFF)) {
    return 'Pink makes white look soft and bright';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFFFFFFFF)) {
    return 'Orange makes white look bright and interesting';
  } else if ((color1 == 0xFF621C8D && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF621C8D)) {
    return 'Lime green adds freshness and vibrancy, making the outfit look fun and energetic';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFF4B0082)) {
    return 'Light blue makes dark purple stand out and look lively';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF4B0082)) {
    return 'Lime green makes dark purple look bright and interesting';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF4B0082)) {
    return 'Orange makes dark purple look bright and energetic';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF30B0E8)) {
    return 'Lime green makes light blue look bright and lively';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF30B0E8)) {
    return 'Orange makes light blue look energetic and fun';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF53CDBF)) {
    return 'Lime green makes sky blue look bright and lively';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF53CDBF)) {
    return 'Orange makes sky blue look energetic and fun';
  } else if ((color1 == 0xFF17770F && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF17770F)) {
    return 'Orange makes green look bright and energetic';
  } else if (color1 == 0xFF62CF2F && color2 == 0xFF62CF2F) {
    return 'Lime green looks powerful and balanced';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFF000000)) {
    return 'Light blue adds softness and modernity, making the black outfit look less intense';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFFFFFF) || (color1 == 0xFFFFFFFF && color2 == 0xFFCA93EB)) {
    return 'White makes dark purple stand out and not too dark, making the outfit look clean and modern';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFF808080) || (color1 == 0xFF808080 && color2 == 0xFFCA93EB)) {
    return 'Gray adds luxury and elegance to the outfit, making it look more dimensional';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFFCA93EB)) {
    return 'Light blue makes dark purple stand out and look lively';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFFFF00) || (color1 == 0xFFFFFF00 && color2 == 0xFFCA93EB)) {
    return 'Yellow makes dark purple look bright and vibrant';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFFCA93EB)) {
    return 'Pink adds softness and romance to the outfit, making it look warm and friendly';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFFCA93EB)) {
    return 'Lime green makes dark purple look bright and interesting';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFFCA93EB)) {
    return 'Orange makes dark purple look bright and energetic';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFFFFFF) || (color1 == 0xFFFFFFFF && color2 == 0xFF808080)) {
    return 'Gray and white is a classic and elegant combination. White helps make gray look bright && clean';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF202FB3) || (color1 == 0xFF202FB3 && color2 == 0xFF808080)) {
    return 'Blue adds vibrancy and formality to the outfit. Blue makes gray look brighter';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFF808080)) {
    return 'Light blue adds softness and modernity, making gray look soothing and interesting';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFFFF00) || (color1 == 0xFFFFFF00 && color2 == 0xFF808080)) {
    return 'Yellow creates brightness and vibrancy, making gray look powerful and interesting';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFF808080)) {
    return 'Pink gives a warm and soft feeling, making gray look more interesting';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFF0000) || (color1 == 0xFFFF0000 && color2 == 0xFF808080)) {
    return 'Red helps add brightness and liveliness to the outfit, making gray look less plain';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF621C8D) || (color1 == 0xFF621C8D && color2 == 0xFF808080)) {
    return 'Purple adds luxury and intrigue, making the gray outfit look more dimensional and interesting';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF808080)) {
    return 'Lime green adds brightness and vibrancy to the outfit. Green also makes gray look more energetic';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF808080)) {
    return 'Orange adds fun and energy to the gray outfit, making it lively and interesting';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF000000) || (color1 == 0xFF000000 && color2 == 0xFF30B0E8)) {
    return 'Black increases contrast and formality, making light blue look powerful';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFFFFFF) || (color1 == 0xFFFFFFFF && color2 == 0xFF30B0E8)) {
    return 'White makes the outfit look clean and fresh, making light blue stand out';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF808080) || (color1 == 0xFF808080 && color2 == 0xFF30B0E8)) {
    return 'Gray adds modernity and softness to the light blue outfit';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFFFF00) || (color1 == 0xFFFFFF00 && color2 == 0xFF30B0E8)) {
    return 'Yellow creates brightness and vibrancy, making the outfit fun and interesting';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFF30B0E8)) {
    return 'Pink adds softness and warmth, making light blue look bright && cute';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFF0000) || (color1 == 0xFFFF0000 && color2 == 0xFF30B0E8)) {
    return 'Red adds brightness and vibrancy, making light blue look powerful and prominent';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF621C8D) || (color1 == 0xFF621C8D && color2 == 0xFF30B0E8)) {
    return 'Purple adds luxury and intrigue, making the light blue outfit look dimensional and interesting';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF30B0E8)) {
    return 'Lime green adds brightness and vibrancy, making light blue look bright and energetic';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF30B0E8)) {
    return 'Orange makes light blue look powerful and fun';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFFFFFF) || (color1 == 0xFFFFFFFF && color2 == 0xFFCA93EB)) {
    return 'White makes dark purple stand out and not too dark, making the outfit look clean and modern';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFF808080) || (color1 == 0xFF808080 && color2 == 0xFFCA93EB)) {
    return 'Gray adds luxury and elegance to the outfit, making it look more dimensional';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFFCA93EB)) {
    return 'Light blue makes dark purple stand out and look lively';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFFFF00) || (color1 == 0xFFFFFF00 && color2 == 0xFFCA93EB)) {
    return 'Yellow makes dark purple look bright and vibrant';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFFCA93EB)) {
    return 'Pink adds softness and romance to the outfit, making it look warm and friendly';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFFCA93EB)) {
    return 'Lime green makes dark purple look bright and interesting';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFFCA93EB)) {
    return 'Orange makes dark purple look bright and energetic';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFFFFFF) || (color1 == 0xFFFFFFFF && color2 == 0xFF808080)) {
    return 'Gray and white are a classic and elegant pairing. White helps gray look brighter && cleaner';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF202FB3) || (color1 == 0xFF202FB3 && color2 == 0xFF808080)) {
    return 'Blue adds vibrancy and formality to the outfit. Blue makes gray look more lively';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFF808080)) {
    return 'Light blue adds softness and modernity, making gray look more comfortable and interesting';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFFFF00) || (color1 == 0xFFFFFF00 && color2 == 0xFF808080)) {
    return 'Yellow creates brightness and vibrancy, making gray look energetic and interesting';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFF808080)) {
    return 'Pink adds warmth and softness, making gray look more interesting';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFF0000) || (color1 == 0xFFFF0000 && color2 == 0xFF808080)) {
    return 'Red adds brightness and vibrancy to the outfit, making gray look less plain';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF621C8D) || (color1 == 0xFF621C8D && color2 == 0xFF808080)) {
    return 'Purple adds luxury and intrigue, making the gray outfit look more dimensional and interesting';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF808080)) {
    return 'Lime green adds brightness and vibrancy to the outfit. Green also makes gray look more energetic';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF808080)) {
    return 'Orange adds fun and energy to the gray outfit, making it lively and interesting';
  } else {
    return 'No suggestions for this color pairing';
  }
}

bool isColorMatchingSkinTone(int colorValue, int? skinTone) {
  if (skinTone == null) return false;
  final skinToneColors = skinToneMatchMap[skinTone];
  if (skinToneColors == null) return false;

  final lightColors = skinToneColors['lightColors'] ?? [];
  final brightColors = skinToneColors['brightColors'] ?? [];
  final darkColors = skinToneColors['darkColors'] ?? [];

  return lightColors.contains(colorValue) ||
      brightColors.contains(colorValue) ||
      darkColors.contains(colorValue);
}

Map<String, dynamic> checkMatch(
    List<dynamic> topColors, List<dynamic> lowerColors) {
  if (topColors.isEmpty || lowerColors.isEmpty) {
    return {
      'isGreatMatch': false,
      'topClosestColor': null,
      'lowerClosestColor': null,
    };
  }

  // Ensure that topColors and lowerColors are lists of integers
  final List<int> topColorsList = List<int>.from(topColors);
  final List<int> lowerColorsList = List<int>.from(lowerColors);

  final topPrimaryColor = findClosestColor(topColorsList[0]);
  final lowerPrimaryColor = findClosestColor(lowerColorsList[0]);

  bool isGreatMatch =
      colorMatchMap[topPrimaryColor]?.contains(lowerPrimaryColor) ?? false;

  return {
    'isGreatMatch': isGreatMatch,
    'topClosestColor': topPrimaryColor,
    'lowerClosestColor': lowerPrimaryColor,
  };
}

Map<String, dynamic> checkMatchWithSkinTone(
    List<dynamic> topColors, List<dynamic> lowerColors, int? skinTone) {
  if (topColors.isEmpty || lowerColors.isEmpty) {
    return {
      'isGreatMatch': false,
      'topClosestColor': null,
      'lowerClosestColor': null,
    };
  }

  final List<int> topColorsList = List<int>.from(topColors);
  final List<int> lowerColorsList = List<int>.from(lowerColors);

  final topPrimaryColor = findClosestColor(topColorsList[0]);
  final lowerPrimaryColor = findClosestColor(lowerColorsList[0]);

  bool isGreatMatch =
      colorMatchMap[topPrimaryColor]?.contains(lowerPrimaryColor) ?? false;

  // Check if the colors match the user's skin tone preferences
  bool topMatchesSkinTone = isColorMatchingSkinTone(topPrimaryColor, skinTone);
  bool lowerMatchesSkinTone =
      isColorMatchingSkinTone(lowerPrimaryColor, skinTone);

  return {
    'isGreatMatch': isGreatMatch && topMatchesSkinTone && lowerMatchesSkinTone,
    'topClosestColor': topPrimaryColor,
    'lowerClosestColor': lowerPrimaryColor,
  };
}
