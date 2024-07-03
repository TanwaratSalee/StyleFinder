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
      List<String> selectedSiturations,
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
              'situations': selectedSiturations,
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
    case 4289672092:
      return 'Medium Skin';
    case 4280391411:
      return 'Tan Skin';
    case 4278215680:
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
            'สีแดง: สื่อถึงพลังและความมั่นใจ เนื่องจากวันอาทิตย์เป็นวันที่เกี่ยวข้องกับพระอาทิตย์ ซึ่งมีสีแดงเป็นสัญลักษณ์',
        0xFFFFFFFF:
            'สีขาว: สื่อถึงความบริสุทธิ์และความสงบ ช่วยเสริมความคิดสร้างสรรค์',
        0xFFFFC0CB:
            'สีชมพู: สื่อถึงความรักและความเมตตา ช่วยสร้างความสัมพันธ์ที่ดี',
        0xFF17770F: 'สีเขียว: สื่อถึงความสมดุลและความสงบ',
        0xFF000000: 'สีดำ: สื่อถึงความมั่นคงและความเข้มแข็ง',
        0xFF621C8D: 'สีม่วง: สื่อถึงความหรูหราและสติปัญญา',
        0xFFFFA500: 'สีส้ม: สื่อถึงความสุขและความอบอุ่น',
        0xFF808080: 'สีเทา: สื่อถึงความสงบและความสุขุม'
      };
    case 'Monday':
      return {
        0xFFFFFF00: 'สีเหลือง: สื่อถึงความอบอุ่นและความสดใส',
        0xFFFFFFFF: 'สีขาว: สื่อถึงความบริสุทธิ์และความสงบ',
        0xFF17770F: 'สีเขียว: สื่อถึงความสมดุลและความสงบ',
        0xFF621C8D: 'สีม่วง: สื่อถึงความหรูหราและสติปัญญา',
        0xFFFFA500: 'สีส้ม: สื่อถึงความสุขและความอบอุ่น',
        0xFF30B0E8: 'สีฟ้าอ่อน: สื่อถึงความสงบและความเยือกเย็น',
        0xFF202FB3: 'สีน้ำเงิน: สื่อถึงความมั่นคงและความไว้วางใจ'
      };
    case 'Tuesday':
      return {
        0xFFFFC0CB: 'สีชมพู: สื่อถึงความรักและความเมตตา',
        0xFF17770F: 'สีเขียว: สื่อถึงความสมดุลและความสงบ',
        0xFF621C8D: 'สีม่วง: สื่อถึงความหรูหราและสติปัญญา',
        0xFFFFA500: 'สีส้ม: สื่อถึงความสุขและความอบอุ่น',
        0xFF808080: 'สีเทา: สื่อถึงความสงบและความสุขุม',
        0xFF30B0E8: 'สีฟ้าอ่อน: สื่อถึงความสงบและความเยือกเย็น',
        0xFF202FB3: 'สีน้ำเงิน: สื่อถึงความมั่นคงและความไว้วางใจ',
        0xFFFF0000: 'สีแดง: สื่อถึงพลังและความมั่นใจ'
      };
    case 'Wednesday':
      return {
        0xFF17770F: 'สีเขียว: สื่อถึงความสมดุลและความสงบ',
        0xFF621C8D: 'สีม่วง: สื่อถึงความหรูหราและสติปัญญา',
        0xFFFFD700: 'สีทอง: สื่อถึงความรุ่งเรืองและความมั่งคั่ง',
        0xFF808080: 'สีเทา: สื่อถึงความสงบและความสุขุม',
        0xFF202FB3: 'สีน้ำเงิน: สื่อถึงความมั่นคงและความไว้วางใจ',
        0xFF30B0E8: 'สีฟ้าอ่อน: สื่อถึงความสงบและความเยือกเย็น',
        0xFFFF0000: 'สีแดง: สื่อถึงพลังและความมั่นใจ',
        0xFFFFFF00: 'สีเหลือง: สื่อถึงความอบอุ่นและความสดใส',
        0xFFFFFFFF: 'สีขาว: สื่อถึงความบริสุทธิ์และความสงบ',
        0xFFFFC0CB: 'สีชมพู: สื่อถึงความรักและความเมตตา'
      };
    case 'Thursday':
      return {
        0xFFFFA500: 'สีส้ม: สื่อถึงความสุขและความอบอุ่น',
        0xFF808080: 'สีเทา: สื่อถึงความสงบและความสุขุม',
        0xFF202FB3: 'สีน้ำเงิน: สื่อถึงความมั่นคงและความไว้วางใจ',
        0xFFFF0000: 'สีแดง: สื่อถึงพลังและความมั่นใจ',
        0xFFFFFF00: 'สีเหลือง: สื่อถึงความอบอุ่นและความสดใส',
        0xFFFFFFFF: 'สีขาว: สื่อถึงความบริสุทธิ์และความสงบ',
        0xFFFFC0CB: 'สีชมพู: สื่อถึงความรักและความเมตตา',
        0xFF17770F: 'สีเขียว: สื่อถึงความสมดุลและความสงบ'
      };
    case 'Friday':
      return {
        0xFF202FB3: 'สีน้ำเงิน: สื่อถึงความมั่นคงและความไว้วางใจ',
        0xFFFF0000: 'สีแดง: สื่อถึงพลังและความมั่นใจ',
        0xFFFFFF00: 'สีเหลือง: สื่อถึงความอบอุ่นและความสดใส',
        0xFFFFFFFF: 'สีขาว: สื่อถึงความบริสุทธิ์และความสงบ',
        0xFFFFC0CB: 'สีชมพู: สื่อถึงความรักและความเมตตา',
        0xFF17770F: 'สีเขียว: สื่อถึงความสมดุลและความสงบ',
        0xFF621C8D: 'สีม่วง: สื่อถึงความหรูหราและสติปัญญา',
        0xFFFFA500: 'สีส้ม: สื่อถึงความสุขและความอบอุ่น',
        0xFF808080: 'สีเทา: สื่อถึงความสงบและความสุขุม'
      };
    case 'Saturday':
      return {
        0xFF000000: 'สีดำ: สื่อถึงความมั่นคงและความเข้มแข็ง',
        0xFF621C8D: 'สีม่วง: สื่อถึงความหรูหราและสติปัญญา',
        0xFF808080: 'สีเทา: สื่อถึงความสงบและความสุขุม',
        0xFF202FB3: 'สีน้ำเงิน: สื่อถึงความมั่นคงและความไว้วางใจ',
        0xFFFF0000: 'สีแดง: สื่อถึงพลังและความมั่นใจ',
        0xFFFFFF00: 'สีเหลือง: สื่อถึงความอบอุ่นและความสดใส',
        0xFFFFFFFF: 'สีขาว: สื่อถึงความบริสุทธิ์และความสงบ',
        0xFFFFC0CB: 'สีชมพู: สื่อถึงความรักและความเมตตา'
      };
    default:
      return {};
  }
}

final Map<int, Map<String, List<int>>> skinToneMatchMap = {
  4294961114: {
    // Fair Skin
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
  4289672092: {
    // Medium Skin
    'lightColors': [0xFFFFFFFF, 0xFFFFA500, 0xFFADD8E6, 0xFF9370DB],
    'brightColors': [0xFFFFA500, 0xFF32CD32, 0xFFFF0000, 0xFFFFFF00],
    'darkColors': [0xFF0000FF, 0xFF4B0082, 0xFF808080],
  },
  4280391411: {
    // Tan Skin
    'lightColors': [0xFFFFFFFF, 0xFFFF4081, 0xFFADD8E6],
    'brightColors': [0xFFFFFF00, 0xFFFFA500, 0xFF008000, 0xFF9370DB],
    'darkColors': [0xFF0000FF, 0xFF8B4513, 0xFF808080, 0xFF006400],
  },
  4278215680: {
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
    return 'ความคอนทราสต์ที่สูงระหว่างสีดำและสีขาวทำให้ดูโดดเด่นและเป็นทางการ สีดำยังทำให้สีขาวดูสะอาดและสดใสยิ่งขึ้น';
  } else if (color1 == 0xFF000000 && color2 == 0xFF000000) {
    return 'การจับคู่สีดำกับสีดำสร้างลุคที่ดูเข้มขรึมและทรงพลัง ทำให้ดูทันสมัยและน่าสนใจ';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF808080) ||
      (color1 == 0xFF808080 && color2 == 0xFF000000)) {
    return 'การจับคู่สีโทนกลางทำให้ความรู้สึกเรียบง่ายและทันสมัย สีเทายังเพิ่มความนุ่มนวลให้กับชุดสีดำ';
  } else if ((color1 == 0xFF000000 && color2 == 0xFFFF0000) ||
      (color1 == 0xFFFF0000 && color2 == 0xFF000000)) {
    return 'สีแดงช่วยเพิ่มความสดใสให้กับชุดสีดำที่มักดูเรียบเกินไป สร้างความโดดเด่นและมีชีวิตชีวา';
  } else if ((color1 == 0xFF000000 && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF000000)) {
    return 'ความสดใสของสีเหลืองสร้างความคอนทราสต์ที่น่าสนใจ และทำให้ชุดดูมีพลังและสนุกสนาน';
  } else if ((color1 == 0xFF000000 && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFF000000)) {
    return 'สีชมพูเพิ่มความนุ่มนวลและเป็นกันเอง ทำให้ชุดสีดำดูไม่เข้มขรึมเกินไป';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF621C8D) ||
      (color1 == 0xFF621C8D && color2 == 0xFF000000)) {
    return 'สีม่วงเพิ่มความหรูหราและน่าค้นหา ทำให้ชุดสีดำดูมีความลึก';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF202FB3) ||
      (color1 == 0xFF202FB3 && color2 == 0xFF000000)) {
    return 'สีฟ้าทำให้ชุดสีดำดูมีพลังและความสดใส';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF30B0E8) ||
      (color1 == 0xFF30B0E8 && color2 == 0xFF000000)) {
    return 'สีฟ้าอ่อนเพิ่มความนุ่มนวลและทันสมัย ทำให้ชุดสีดำดูไม่เข้มเกินไป';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF53CDBF) ||
      (color1 == 0xFF53CDBF && color2 == 0xFF000000)) {
    return 'สีเทาฟ้าเพิ่มความสดใสและมีชีวิตชีวาให้กับชุดสีดำ';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF17770F) ||
      (color1 == 0xFF17770F && color2 == 0xFF000000)) {
    return 'สีเขียวทำให้ชุดสีดำดูสดใสและมีพลัง';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF62CF2F) ||
      (color1 == 0xFF62CF2F && color2 == 0xFF000000)) {
    return 'สีเขียวมะนาวเพิ่มความสดใสและมีชีวิตชีวาให้กับชุดสีดำ';
  } else if ((color1 == 0xFF000000 && color2 == 0xFFFFA500) ||
      (color1 == 0xFFFFA500 && color2 == 0xFF000000)) {
    return 'สีส้มเพิ่มความสนุกสนานและพลังให้กับชุดสีดำ';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFF808080)) {
    return 'การจับคู่สีที่คลาสสิกและสุภาพ เรียบง่ายและทันสมัย สีดำทำให้สีเทาดูชัดเจนและโดดเด่น';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF0000FF) ||
      (color1 == 0xFF0000FF && color2 == 0xFF808080)) {
    return 'การจับคู่สีที่ดูโปรเฟสชั่นแนลและไม่มากเกินไป สีฟ้าทำให้สีเทาดูสดใสขึ้น';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF32CD32) ||
      (color1 == 0xFF32CD32 && color2 == 0xFF808080)) {
    return 'สีเขียวมะนาวช่วยเพิ่มความสดใสและมีชีวิตชีวาให้กับชุด สีเขียวยังทำให้สีเทาดูมีพลัง';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFF808080)) {
    return 'สีชมพูให้ความรู้สึกอบอุ่นและนุ่มนวล ทำให้สีเทาดูมีความน่าสนใจมากขึ้น';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF4B0082) ||
      (color1 == 0xFF4B0082 && color2 == 0xFF808080)) {
    return 'ความลึกของสีม่วงเพิ่มความหรูหราและเป็นทางการให้กับชุด';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF17770F) ||
      (color1 == 0xFF17770F && color2 == 0xFF808080)) {
    return 'สีเขียวทำให้สีเทาดูสดชื่นและมีชีวิตชีวา';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF30B0E8) ||
      (color1 == 0xFF30B0E8 && color2 == 0xFF808080)) {
    return 'สีฟ้าอ่อนทำให้สีเทาดูมีความน่าสนใจและสบายตา';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF53CDBF) ||
      (color1 == 0xFF53CDBF && color2 == 0xFF808080)) {
    return 'สีเทาฟ้าทำให้สีเทาดูมีความสมดุลและสบายตา';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFFFFFFFF)) {
    return 'การคอนทราสต์ที่สูงทำให้ดูสะอาดและมีความโปรเฟสชั่นแนล สีดำทำให้สีขาวดูโดดเด่น';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFF808080) ||
      (color1 == 0xFF808080 && color2 == 0xFFFFFFFF)) {
    return 'สีเทาเป็นสีโทนกลางที่เข้ากับสีขาวได้อย่างเรียบง่าย ทำให้ชุดดูนุ่มนวลและทันสมัย';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFF0000FF) ||
      (color1 == 0xFF0000FF && color2 == 0xFFFFFFFF)) {
    return 'สีฟ้าช่วยเพิ่มความสดชื่นและเป็นทางการ ทำให้ชุดดูมีชีวิตชีวา';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFF4B0082) ||
      (color1 == 0xFF4B0082 && color2 == 0xFFFFFFFF)) {
    return 'สีม่วงเข้มเพิ่มความลึกและความหรูหราให้กับชุด สีม่วงทำให้สีขาวดูมีความซับซ้อน';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFF32CD32) ||
      (color1 == 0xFF32CD32 && color2 == 0xFFFFFFFF)) {
    return 'สีเขียวมะนาวเพิ่มความสดใสและสดชื่น ทำให้ชุดดูมีพลังและสนุกสนาน';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFFFFFFFF)) {
    return 'สีชมพูทำให้สีขาวดูนุ่มนวลและสดใส';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFFFFA500) ||
      (color1 == 0xFFFFA500 && color2 == 0xFFFFFFFF)) {
    return 'สีส้มทำให้สีขาวดูสดใสและน่าสนใจ';
  } else if ((color1 == 0xFF621C8D && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF621C8D)) {
    return 'สีขาวทำให้สีม่วงดูโดดเด่นและสะอาดตา เพิ่มความสดใสให้กับชุดสีม่วง';
  } else if ((color1 == 0xFF621C8D && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFF621C8D)) {
    return 'สีดำเพิ่มความลึกและความลึกลับให้กับชุด ทำให้ชุดดูมีมิติมากขึ้น';
  } else if ((color1 == 0xFF621C8D && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF621C8D)) {
    return 'สีเหลืองสร้างความคอนทราสต์ที่น่าสนใจและสดใส ทำให้ชุดดูโดดเด่นและมีชีวิตชีวา';
  } else if ((color1 == 0xFF621C8D && color2 == 0xFF32CD32) ||
      (color1 == 0xFF32CD32 && color2 == 0xFF621C8D)) {
    return 'สีเขียวมะนาวเพิ่มความสดชื่นและมีชีวิตชีวา ทำให้ชุดดูสนุกสนานและมีพลัง';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF4B0082)) {
    return 'สีขาวช่วยให้สีม่วงเข้มดูโดดเด่นและไม่มืดเกินไป ทำให้ชุดดูสะอาดและทันสมัย';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFF808080) ||
      (color1 == 0xFF808080 && color2 == 0xFF4B0082)) {
    return 'สีเทาเพิ่มความหรูหราและสุภาพให้กับชุด ทำให้ชุดดูมีมิติมากขึ้น';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFF0000FF) ||
      (color1 == 0xFF0000FF && color2 == 0xFF4B0082)) {
    return 'สีฟ้าเพิ่มความโปรเฟสชั่นแนลและไม่มากเกินไป ทำให้ชุดดูมีความสมดุล';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFF4B0082)) {
    return 'สีชมพูเพิ่มความนุ่มนวลและโรแมนติกให้กับชุด ทำให้ชุดดูอบอุ่นและเป็นกันเอง';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF4B0082)) {
    return 'สีเหลืองทำให้สีม่วงเข้มดูสดใสและมีชีวิตชีวา';
  } else if ((color1 == 0xFF0000FF && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF0000FF)) {
    return 'สีขาวทำให้ชุดดูสะอาดและสดชื่น ทำให้สีฟ้าดูโดดเด่น';
  } else if ((color1 == 0xFF0000FF && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFF0000FF)) {
    return 'สีดำเพิ่มความคอนทราสต์และความสุภาพให้กับชุด ทำให้สีฟ้าดูมีพลัง';
  } else if ((color1 == 0xFF0000FF && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF0000FF)) {
    return 'สีเหลืองสร้างความสดใสและมีชีวิตชีวา ทำให้ชุดดูสนุกสนานและน่าสนใจ';
  } else if ((color1 == 0xFF0000FF && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFF0000FF)) {
    return 'สีชมพูเพิ่มความนุ่มนวลและเป็นกันเอง ทำให้สีฟ้าดูอบอุ่นมากขึ้น';
  } else if ((color1 == 0xFF0000FF && color2 == 0xFF30B0E8) ||
      (color1 == 0xFF30B0E8 && color2 == 0xFF0000FF)) {
    return 'สีฟ้าอ่อนทำให้สีฟ้าดูมีความสมดุลและสบายตา';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF30B0E8)) {
    return 'สีขาวทำให้ชุดดูสะอาดและสดชื่น ทำให้สีฟ้าอ่อนดูโดดเด่น';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFF30B0E8)) {
    return 'สีดำเพิ่มความคอนทราสต์และความสุภาพ ทำให้สีฟ้าอ่อนดูมีพลัง';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF30B0E8)) {
    return 'สีเหลืองสร้างความสดใสและมีชีวิตชีวา ทำให้ชุดดูสนุกสนานและน่าสนใจ';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF17770F) ||
      (color1 == 0xFF17770F && color2 == 0xFF30B0E8)) {
    return 'สีเขียวเพิ่มความสดชื่นและมีชีวิตชีวา ทำให้ชุดดูสดใสและมีพลัง';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF62CF2F) ||
      (color1 == 0xFF62CF2F && color2 == 0xFF30B0E8)) {
    return 'สีเขียวมะนาวทำให้สีฟ้าอ่อนดูสดใสและมีชีวิตชีวา';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFFA500) ||
      (color1 == 0xFFFFA500 && color2 == 0xFF30B0E8)) {
    return 'สีส้มทำให้สีฟ้าอ่อนดูมีพลังและสนุกสนาน';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF53CDBF)) {
    return 'สีขาวทำให้ชุดดูสะอาดและสดชื่น ทำให้สีเทาฟ้าดูโดดเด่น';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFF53CDBF)) {
    return 'สีดำเพิ่มความคอนทราสต์และความสุภาพ ทำให้สีเทาฟ้าดูมีพลัง';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFF53CDBF)) {
    return 'สีชมพูเพิ่มความนุ่มนวลและโรแมนติก ทำให้สีเทาฟ้าดูอบอุ่นมากขึ้น';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF53CDBF)) {
    return 'สีเหลืองสร้างความสดใสและมีชีวิตชีวา ทำให้ชุดดูสนุกสนานและน่าสนใจ';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFF62CF2F) ||
      (color1 == 0xFF62CF2F && color2 == 0xFF53CDBF)) {
    return 'สีเขียวมะนาวทำให้สีเทาฟ้าดูสดใสและมีชีวิตชีวา';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFFFFA500) ||
      (color1 == 0xFFFFA500 && color2 == 0xFF53CDBF)) {
    return 'สีส้มทำให้สีเทาฟ้าดูมีพลังและสนุกสนาน';
  } else if ((color1 == 0xFF17770F && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF17770F)) {
    return 'สีขาวทำให้สีเขียวดูสดใสและสะอาดตา ทำให้สีเขียวดูโดดเด่น';
  } else if ((color1 == 0xFF17770F && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFF17770F)) {
    return 'สีดำเพิ่มความคอนทราสต์และความลึกลับ ทำให้สีเขียวดูมีมิติมากขึ้น';
  } else if ((color1 == 0xFF17770F && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF17770F)) {
    return 'สีเหลืองสร้างความสดใสและมีชีวิตชีวา ทำให้ชุดดูสนุกสนานและน่าสนใจ';
  } else if ((color1 == 0xFF17770F && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFF17770F)) {
    return 'สีชมพูเพิ่มความนุ่มนวลและเป็นกันเอง ทำให้สีเขียวดูอบอุ่นมากขึ้น';
  } else if ((color1 == 0xFF17770F && color2 == 0xFFFFA500) ||
      (color1 == 0xFFFFA500 && color2 == 0xFF17770F)) {
    return 'สีส้มทำให้สีเขียวดูสดใสและมีพลัง';
  } else if ((color1 == 0xFF62CF2F && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF62CF2F)) {
    return 'สีขาวทำให้สีเขียวมะนาวดูสดใสและสะอาดตา ทำให้สีเขียวมะนาวดูโดดเด่น';
  } else if ((color1 == 0xFF62CF2F && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFF62CF2F)) {
    return 'สีดำเพิ่มความคอนทราสต์และความลึกลับ ทำให้สีเขียวมะนาวดูมีมิติมากขึ้น';
  } else if ((color1 == 0xFF62CF2F && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF62CF2F)) {
    return 'สีเหลืองทำให้สีเขียวมะนาวดูสดใสและมีชีวิตชีวา';
  } else if ((color1 == 0xFF62CF2F && color2 == 0xFFFF0000) ||
      (color1 == 0xFFFF0000 && color2 == 0xFF62CF2F)) {
    return 'สีแดงทำให้สีเขียวมะนาวดูสดใสและน่าสนใจ';
  } else if ((color1 == 0xFF62CF2F && color2 == 0xFFFFA500) ||
      (color1 == 0xFFFFA500 && color2 == 0xFF62CF2F)) {
    return 'สีส้มทำให้สีเขียวมะนาวดูสดใสและมีพลัง';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFF202FB3)) {
    return 'สีฟ้าและสีชมพูเป็นคู่สีที่สดใสและมีชีวิตชีวา สีชมพูทำให้สีฟ้าดูอบอุ่นและน่ารัก';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF202FB3)) {
    return 'สีฟ้าและสีเหลืองเป็นคู่สีที่สดใสและมีชีวิตชีวา สีเหลืองทำให้สีฟ้าดูมีพลังและน่าสนใจ';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFF53CDBF) ||
      (color1 == 0xFF53CDBF && color2 == 0xFF202FB3)) {
    return 'สีฟ้าและสีเทาฟ้าเป็นคู่สีที่สดใสและทันสมัย สีเทาฟ้าทำให้สีฟ้าดูมีความน่าสนใจและสมดุล';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFFFF0000) ||
      (color1 == 0xFFFF0000 && color2 == 0xFF202FB3)) {
    return 'สีฟ้าและสีแดงเป็นคู่สีที่สดใสและมีพลัง สีแดงทำให้สีฟ้าดูโดดเด่นและมีชีวิตชีวา';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFF621C8D) ||
      (color1 == 0xFF621C8D && color2 == 0xFF202FB3)) {
    return 'สีฟ้าและสีม่วงเป็นคู่สีที่มีความลึกและน่าสนใจ สีม่วงทำให้สีฟ้าดูมีความซับซ้อนและนุ่มนวล';
  } else if (color1 == 0xFF202FB3 && color2 == 0xFF202FB3) {
    return 'สีฟ้าทำให้สีฟ้าดูมีความสมดุลและสบายตา เป็นคู่สีที่ดูทันสมัยและน่าสนใจ';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFF30B0E8) ||
      (color1 == 0xFF30B0E8 && color2 == 0xFF202FB3)) {
    return 'สีฟ้าอ่อนทำให้สีฟ้าดูสดใสและสบายตา';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFF62CF2F) ||
      (color1 == 0xFF62CF2F && color2 == 0xFF202FB3)) {
    return 'สีเขียวมะนาวทำให้สีฟ้าดูสดใสและมีชีวิตชีวา';
  } else if ((color1 == 0xFF202FB3 && color2 == 0xFFFFA500) ||
      (color1 == 0xFFFFA500 && color2 == 0xFF202FB3)) {
    return 'สีส้มทำให้สีฟ้าดูมีพลังและน่าสนใจ';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFFFFE4C4)) {
    return 'สีครีมและสีขาวเป็นคู่สีที่ดูสะอาดและสุภาพ สีขาวทำให้สีครีมดูนุ่มนวลและสดใส';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFF808080) ||
      (color1 == 0xFF808080 && color2 == 0xFFFFE4C4)) {
    return 'สีครีมและสีเทาเป็นคู่สีที่ดูนุ่มนวลและสุภาพ สีเทาทำให้สีครีมดูมีความทันสมัยและสบายตา';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFF793A1F) ||
      (color1 == 0xFF793A1F && color2 == 0xFFFFE4C4)) {
    return 'สีครีมและสีน้ำตาลเป็นคู่สีที่ดูอบอุ่นและนุ่มนวล สีน้ำตาลทำให้สีครีมดูมีความสุขุมและสุภาพ';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFF000000) ||
      (color1 == 0xFF000000 && color2 == 0xFFFFE4C4)) {
    return 'สีครีมและสีดำเป็นคู่สีที่มีความคอนทราสต์และน่าสนใจ สีดำทำให้สีครีมดูโดดเด่นและมีความสุภาพ';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFFFFE4C4)) {
    return 'สีครีมและสีเหลืองเป็นคู่สีที่สดใสและมีชีวิตชีวา สีเหลืองทำให้สีครีมดูมีพลังและน่าสนใจ';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFF202FB3) ||
      (color1 == 0xFF202FB3 && color2 == 0xFFFFE4C4)) {
    return 'สีครีมและสีฟ้าเป็นคู่สีที่ดูทันสมัยและสดใส สีฟ้าทำให้สีครีมดูมีความสมดุลและนุ่มนวล';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFF17770F) ||
      (color1 == 0xFF17770F && color2 == 0xFFFFE4C4)) {
    return 'สีครีมและสีเขียวเป็นคู่สีที่ดูสดชื่นและนุ่มนวล สีเขียวทำให้สีครีมดูมีพลังและสุภาพ';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFFFF4081) ||
      (color1 == 0xFFFF4081 && color2 == 0xFFFFE4C4)) {
    return 'สีครีมและสีชมพูเป็นคู่สีที่น่ารักและสดใส สีชมพูทำให้สีครีมดูอบอุ่นและมีชีวิตชีวา';
  } else if ((color1 == 0xFFFFE4C4 && color2 == 0xFFFF0000) ||
      (color1 == 0xFFFF0000 && color2 == 0xFFFFE4C4)) {
    return 'สีครีมและสีแดงเป็นคู่สีที่ดูโดดเด่นและมีพลัง สีแดงทำให้สีครีมดูน่าสนใจและมีชีวิตชีวา';
  } else if ((color1 == 0xFF793A1F && color2 == 0xFFFFFFFF) ||
      (color1 == 0xFFFFFFFF && color2 == 0xFF793A1F)) {
    return 'สีน้ำตาลและสีขาวเป็นคู่สีที่ดูสะอาดและสุภาพ สีขาวทำให้สีน้ำตาลดูนุ่มนวลและสดใส';
  } else if ((color1 == 0xFF793A1F && color2 == 0xFF808080) ||
      (color1 == 0xFF808080 && color2 == 0xFF793A1F)) {
    return 'สีน้ำตาลและสีเทาเป็นคู่สีที่ดูนุ่มนวลและสุภาพ สีเทาทำให้สีน้ำตาลดูมีความทันสมัยและสบายตา';
  } else if ((color1 == 0xFF793A1F && color2 == 0xFF202FB3) ||
      (color1 == 0xFF202FB3 && color2 == 0xFF793A1F)) {
    return 'สีน้ำตาลและสีฟ้าเป็นคู่สีที่ดูทันสมัยและสดใส สีฟ้าทำให้สีน้ำตาลดูมีความสมดุลและนุ่มนวล';
  } else if ((color1 == 0xFF793A1F && color2 == 0xFF17770F) ||
      (color1 == 0xFF17770F && color2 == 0xFF793A1F)) {
    return 'สีน้ำตาลและสีเขียวเป็นคู่สีที่ดูสดชื่นและนุ่มนวล สีเขียวทำให้สีน้ำตาลดูมีพลังและสุภาพ';
  } else if ((color1 == 0xFF793A1F && color2 == 0xFFFFFF00) ||
      (color1 == 0xFFFFFF00 && color2 == 0xFF793A1F)) {
    return 'สีน้ำตาลและสีเหลืองเป็นคู่สีที่สดใสและมีชีวิตชีวา สีเหลืองทำให้สีน้ำตาลดูมีพลังและน่าสนใจ';
  } else if ((color1 == 0xFFFF0000 && color2 == 0xFF621C8D) ||
      (color1 == 0xFF621C8D && color2 == 0xFFFF0000)) {
    return 'สีแดงและสีม่วงเป็นคู่สีที่มีความลึกและน่าสนใจ สีม่วงทำให้สีแดงดูมีความซับซ้อนและนุ่มนวล';
  } else if ((color1 == 0xFFFF0000 && color2 == 0xFF793A1F) ||
      (color1 == 0xFF793A1F && color2 == 0xFFFF0000)) {
    return 'สีแดงและสีน้ำตาลเป็นคู่สีที่ดูอบอุ่นและสุภาพ สีน้ำตาลทำให้สีแดงดูน่าสนใจและมีชีวิตชีวา';
  } else if ((color1 == 0xFFFF0000 && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFFFF0000)) {
    return 'สีแดงและสีชมพูเป็นคู่สีที่ดูน่ารักและสดใส สีชมพูทำให้สีแดงดูอบอุ่นและมีชีวิตชีวา';
  } else if ((color1 == 0xFFFF0000 && color2 == 0xFF17770F) || (color1 == 0xFF17770F && color2 == 0xFFFF0000)) {
    return 'สีแดงและสีเขียวเป็นคู่สีที่ดูสดใสและมีพลัง สีเขียวทำให้สีแดงดูมีชีวิตชีวาและน่าสนใจ';
  } else if ((color1 == 0xFFFF0000 && color2 == 0xFFFFFF00) || (color1 == 0xFFFFFF00 && color2 == 0xFFFF0000)) {
    return 'สีแดงและสีเหลืองเป็นคู่สีที่ดูสดใสและมีพลัง สีเหลืองทำให้สีแดงดูโดดเด่นและมีชีวิตชีวา';
  } else if ((color1 == 0xFFFF0000 && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFFFF0000)) {
    return 'สีฟ้าอ่อนทำให้สีแดงดูนุ่มนวลและสมดุล';
  } else if ((color1 == 0xFFFF4081 && color2 == 0xFF17770F) || (color1 == 0xFF17770F && color2 == 0xFFFF4081)) {
    return 'สีชมพูและสีเขียวมีความคอนทราสต์ที่มากเกินไป และมักดูไม่เข้ากันเนื่องจากสีชมพูเป็นสีที่นุ่มนวลและอบอุ่น ขณะที่สีเขียวเป็นสีที่สดชื่นและมีพลัง';
  } else if ((color1 == 0xFFFF4081 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFFFF4081)) {
    return 'สีเขียวมะนาวทำให้สีชมพูดูสดใสและมีชีวิตชีวา';
  } else if ((color1 == 0xFFFF4081 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFFFF4081)) {
    return 'สีส้มทำให้สีชมพูดูสดใสและมีพลัง';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFF793A1F) || (color1 == 0xFF793A1F && color2 == 0xFFFFFF00)) {
    return 'สีเหลืองและสีน้ำตาลเป็นคู่สีที่สดใสและมีพลัง สีน้ำตาลทำให้สีเหลืองดูมีความสมดุลและน่าสนใจ';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFF621C8D) || (color1 == 0xFF621C8D && color2 == 0xFFFFFF00)) {
    return 'สีเหลืองและสีม่วงเป็นคู่สีที่มีความลึกและน่าสนใจ สีม่วงทำให้สีเหลืองดูมีความซับซ้อนและสดใส';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFFFFFF00)) {
    return 'สีเหลืองและสีชมพูเป็นคู่สีที่น่ารักและสดใส สีชมพูทำให้สีเหลืองดูอบอุ่นและมีชีวิตชีวา';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFF808080) || (color1 == 0xFF808080 && color2 == 0xFFFFFF00)) {
    return 'สีเหลืองและสีเทาเป็นคู่สีที่สดใสและสุภาพ สีเทาทำให้สีเหลืองดูมีความสมดุลและสบายตา';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFF202FB3) || (color1 == 0xFF202FB3 && color2 == 0xFFFFFF00)) {
    return 'สีฟ้าทำให้สีเหลืองดูสดใสและมีชีวิตชีวา';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFFFFFF00)) {
    return 'สีฟ้าอ่อนทำให้สีเหลืองดูสดใสและสบายตา';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFFFFFF00)) {
    return 'สีเขียวมะนาวทำให้สีเหลืองดูสดใสและมีชีวิตชีวา';
  } else if ((color1 == 0xFFFFFF00 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFFFFFF00)) {
    return 'สีส้มทำให้สีเหลืองดูสดใสและมีพลัง';
  } else if ((color1 == 0xFFFFA500 && color2 == 0xFF793A1F) || (color1 == 0xFF793A1F && color2 == 0xFFFFA500)) {
    return 'สีส้มและสีน้ำตาลมีความสมดุลกันอย่างดี สีส้มเพิ่มความสดใสและสีน้ำตาลเพิ่มความอบอุ่น';
  } else if ((color1 == 0xFFFFA500 && color2 == 0xFF621C8D) || (color1 == 0xFF621C8D && color2 == 0xFFFFA500)) {
    return 'สีส้มและสีม่วงเป็นคู่สีที่มีความคอนทราสต์ที่น่าสนใจ สีส้มทำให้สีม่วงดูสดใสและสีม่วงทำให้สีส้มดูมีความลึก';
  } else if ((color1 == 0xFFFFA500 && color2 == 0xFF202FB3) || (color1 == 0xFF202FB3 && color2 == 0xFFFFA500)) {
    return 'สีฟ้าทำให้สีส้มดูสดใสและน่าสนใจ';
  } else if ((color1 == 0xFFFFA500 && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFFFFA500)) {
    return 'สีฟ้าอ่อนทำให้สีส้มดูสดใสและสบายตา';
  } else if ((color1 == 0xFFFFA500 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFFFFA500)) {
    return 'สีเขียวมะนาวทำให้สีส้มดูสดใสและมีชีวิตชีวา';
  } else if ((color1 == 0xFFFFA500 && color2 == 0xFF17770F) || (color1 == 0xFF17770F && color2 == 0xFFFFA500)) {
    return 'สีเขียวทำให้สีส้มดูสดใสและมีพลัง';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF53CDBF) || (color1 == 0xFF53CDBF && color2 == 0xFF000000)) {
    return 'สีเทาฟ้าเพิ่มความสดใสและมีชีวิตชีวาให้กับชุดสีดำ';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF17770F) || (color1 == 0xFF17770F && color2 == 0xFF000000)) {
    return 'สีเขียวทำให้ชุดสีดำดูสดใสและมีพลัง';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF000000)) {
    return 'สีเขียวมะนาวเพิ่มความสดใสและมีชีวิตชีวาให้กับชุดสีดำ';
  } else if ((color1 == 0xFF000000 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF000000)) {
    return 'สีส้มเพิ่มความสนุกสนานและพลังให้กับชุดสีดำ';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFFFFFFFF)) {
    return 'สีชมพูทำให้สีขาวดูนุ่มนวลและสดใส';
  } else if ((color1 == 0xFFFFFFFF && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFFFFFFFF)) {
    return 'สีส้มทำให้สีขาวดูสดใสและน่าสนใจ';
  } else if ((color1 == 0xFF621C8D && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF621C8D)) {
    return 'สีเขียวมะนาวเพิ่มความสดชื่นและมีชีวิตชีวา ทำให้ชุดดูสนุกสนานและมีพลัง';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFF4B0082)) {
    return 'สีฟ้าอ่อนทำให้สีม่วงเข้มดูโดดเด่นและมีชีวิตชีวา';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF4B0082)) {
    return 'สีเขียวมะนาวทำให้สีม่วงเข้มดูสดใสและน่าสนใจ';
  } else if ((color1 == 0xFF4B0082 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF4B0082)) {
    return 'สีส้มทำให้สีม่วงเข้มดูสดใสและมีพลัง';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF30B0E8)) {
    return 'สีเขียวมะนาวทำให้สีฟ้าอ่อนดูสดใสและมีชีวิตชีวา';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF30B0E8)) {
    return 'สีส้มทำให้สีฟ้าอ่อนดูมีพลังและสนุกสนาน';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF53CDBF)) {
    return 'สีเขียวมะนาวทำให้สีเทาฟ้าดูสดใสและมีชีวิตชีวา';
  } else if ((color1 == 0xFF53CDBF && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF53CDBF)) {
    return 'สีส้มทำให้สีเทาฟ้าดูมีพลังและสนุกสนาน';
  } else if ((color1 == 0xFF17770F && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF17770F)) {
    return 'สีส้มทำให้สีเขียวดูสดใสและมีพลัง';
  } else if (color1 == 0xFF62CF2F && color2 == 0xFF62CF2F) {
    return 'สีเขียวมะนาวทำให้ดูมีพลังและความสมดุล';
  } else if ((color1 == 0xFF000000 && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFF000000)) {
    return 'สีฟ้าอ่อนเพิ่มความนุ่มนวลและทันสมัย ทำให้ชุดสีดำดูไม่เข้มเกินไป';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFFFFFF) || (color1 == 0xFFFFFFFF && color2 == 0xFFCA93EB)) {
    return 'สีขาวทำให้สีม่วงเข้มดูโดดเด่นและไม่มืดเกินไป ทำให้ชุดดูสะอาดและทันสมัย';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFF808080) || (color1 == 0xFF808080 && color2 == 0xFFCA93EB)) {
    return 'สีเทาเพิ่มความหรูหราและสุภาพให้กับชุด ทำให้ชุดดูมีมิติมากขึ้น';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFFCA93EB)) {
    return 'สีฟ้าอ่อนทำให้สีม่วงเข้มดูโดดเด่นและมีชีวิตชีวา';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFFFF00) || (color1 == 0xFFFFFF00 && color2 == 0xFFCA93EB)) {
    return 'สีเหลืองทำให้สีม่วงเข้มดูสดใสและมีชีวิตชีวา';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFFCA93EB)) {
    return 'สีชมพูเพิ่มความนุ่มนวลและโรแมนติกให้กับชุด ทำให้ชุดดูอบอุ่นและเป็นกันเอง';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFFCA93EB)) {
    return 'สีเขียวมะนาวทำให้สีม่วงเข้มดูสดใสและน่าสนใจ';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFFCA93EB)) {
    return 'สีส้มทำให้สีม่วงเข้มดูสดใสและมีพลัง';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFFFFFF) || (color1 == 0xFFFFFFFF && color2 == 0xFF808080)) {
    return 'สีเทาและสีขาวเป็นการจับคู่ที่คลาสสิคและสุภาพ สีขาวช่วยทำให้สีเทาดูสว่างและสะอาดตา';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF202FB3) || (color1 == 0xFF202FB3 && color2 == 0xFF808080)) {
    return 'สีฟ้าเพิ่มความมีชีวิตชีวาและเป็นทางการให้กับชุด สีฟ้าทำให้สีเทาดูสดใสขึ้น';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFF808080)) {
    return 'สีฟ้าอ่อนเพิ่มความนุ่มนวลและทันสมัย ทำให้สีเทาดูสบายตาและมีความน่าสนใจ';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFFFF00) || (color1 == 0xFFFFFF00 && color2 == 0xFF808080)) {
    return 'สีเหลืองสร้างความสดใสและมีชีวิตชีวา ทำให้สีเทาดูมีพลังและน่าสนใจ';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFF808080)) {
    return 'สีชมพูให้ความรู้สึกอบอุ่นและนุ่มนวล ทำให้สีเทาดูมีความน่าสนใจมากขึ้น';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFF0000) || (color1 == 0xFFFF0000 && color2 == 0xFF808080)) {
    return 'สีแดงช่วยเพิ่มความสดใสและมีชีวิตชีวาให้กับชุด ทำให้สีเทาดูไม่เรียบเกินไป';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF621C8D) || (color1 == 0xFF621C8D && color2 == 0xFF808080)) {
    return 'สีม่วงเพิ่มความหรูหราและน่าค้นหา ทำให้ชุดสีเทาดูมีมิติและน่าสนใจ';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF808080)) {
    return 'สีเขียวมะนาวช่วยเพิ่มความสดใสและมีชีวิตชีวาให้กับชุด สีเขียวยังทำให้สีเทาดูมีพลัง';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF808080)) {
    return 'สีส้มเพิ่มความสนุกสนานและพลังให้กับชุดสีเทา ทำให้สีเทาดูมีชีวิตชีวาและน่าสนใจ';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF000000) || (color1 == 0xFF000000 && color2 == 0xFF30B0E8)) {
    return 'สีดำเพิ่มความคอนทราสต์และความสุภาพ ทำให้สีฟ้าอ่อนดูมีพลัง';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFFFFFF) || (color1 == 0xFFFFFFFF && color2 == 0xFF30B0E8)) {
    return 'สีขาวทำให้ชุดดูสะอาดและสดชื่น ทำให้สีฟ้าอ่อนดูโดดเด่น';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF808080) || (color1 == 0xFF808080 && color2 == 0xFF30B0E8)) {
    return 'สีเทาเพิ่มความทันสมัยและความนุ่มนวลให้กับชุดสีฟ้าอ่อน';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFFFF00) || (color1 == 0xFFFFFF00 && color2 == 0xFF30B0E8)) {
    return 'สีเหลืองสร้างความสดใสและมีชีวิตชีวา ทำให้ชุดดูสนุกสนานและน่าสนใจ';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFF30B0E8)) {
    return 'สีชมพูเพิ่มความนุ่มนวลและอบอุ่น ทำให้สีฟ้าอ่อนดูสดใสและน่ารัก';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFF0000) || (color1 == 0xFFFF0000 && color2 == 0xFF30B0E8)) {
    return 'สีแดงช่วยสร้างความสดใสและมีชีวิตชีวา ทำให้สีฟ้าอ่อนดูมีพลังและโดดเด่น';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF621C8D) || (color1 == 0xFF621C8D && color2 == 0xFF30B0E8)) {
    return 'สีม่วงเพิ่มความหรูหราและน่าค้นหา ทำให้ชุดสีฟ้าอ่อนดูมีมิติและน่าสนใจ';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF30B0E8)) {
    return 'สีเขียวมะนาวเพิ่มความสดใสและมีชีวิตชีวา ทำให้สีฟ้าอ่อนดูสดใสและมีพลัง';
  } else if ((color1 == 0xFF30B0E8 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF30B0E8)) {
    return 'สีส้มทำให้สีฟ้าอ่อนดูมีพลังและสนุกสนาน';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFFFFFF) || (color1 == 0xFFFFFFFF && color2 == 0xFFCA93EB)) {
    return 'สีขาวทำให้สีม่วงเข้มดูโดดเด่นและไม่มืดเกินไป ทำให้ชุดดูสะอาดและทันสมัย';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFF808080) || (color1 == 0xFF808080 && color2 == 0xFFCA93EB)) {
    return 'สีเทาเพิ่มความหรูหราและสุภาพให้กับชุด ทำให้ชุดดูมีมิติมากขึ้น';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFFCA93EB)) {
    return 'สีฟ้าอ่อนทำให้สีม่วงเข้มดูโดดเด่นและมีชีวิตชีวา';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFFFF00) || (color1 == 0xFFFFFF00 && color2 == 0xFFCA93EB)) {
    return 'สีเหลืองทำให้สีม่วงเข้มดูสดใสและมีชีวิตชีวา';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFFCA93EB)) {
    return 'สีชมพูเพิ่มความนุ่มนวลและโรแมนติกให้กับชุด ทำให้ชุดดูอบอุ่นและเป็นกันเอง';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFFCA93EB)) {
    return 'สีเขียวมะนาวทำให้สีม่วงเข้มดูสดใสและน่าสนใจ';
  } else if ((color1 == 0xFFCA93EB && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFFCA93EB)) {
    return 'สีส้มทำให้สีม่วงเข้มดูสดใสและมีพลัง';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFFFFFF) || (color1 == 0xFFFFFFFF && color2 == 0xFF808080)) {
    return 'สีเทาและสีขาวเป็นการจับคู่ที่คลาสสิคและสุภาพ สีขาวช่วยทำให้สีเทาดูสว่างและสะอาดตา';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF202FB3) || (color1 == 0xFF202FB3 && color2 == 0xFF808080)) {
    return 'สีฟ้าเพิ่มความมีชีวิตชีวาและเป็นทางการให้กับชุด สีฟ้าทำให้สีเทาดูสดใสขึ้น';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF30B0E8) || (color1 == 0xFF30B0E8 && color2 == 0xFF808080)) {
    return 'สีฟ้าอ่อนเพิ่มความนุ่มนวลและทันสมัย ทำให้สีเทาดูสบายตาและมีความน่าสนใจ';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFFFF00) || (color1 == 0xFFFFFF00 && color2 == 0xFF808080)) {
    return 'สีเหลืองสร้างความสดใสและมีชีวิตชีวา ทำให้สีเทาดูมีพลังและน่าสนใจ';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFF4081) || (color1 == 0xFFFF4081 && color2 == 0xFF808080)) {
    return 'สีชมพูให้ความรู้สึกอบอุ่นและนุ่มนวล ทำให้สีเทาดูมีความน่าสนใจมากขึ้น';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFF0000) || (color1 == 0xFFFF0000 && color2 == 0xFF808080)) {
    return 'สีแดงช่วยเพิ่มความสดใสและมีชีวิตชีวาให้กับชุด ทำให้สีเทาดูไม่เรียบเกินไป';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF621C8D) || (color1 == 0xFF621C8D && color2 == 0xFF808080)) {
    return 'สีม่วงเพิ่มความหรูหราและน่าค้นหา ทำให้ชุดสีเทาดูมีมิติและน่าสนใจ';
  } else if ((color1 == 0xFF808080 && color2 == 0xFF62CF2F) || (color1 == 0xFF62CF2F && color2 == 0xFF808080)) {
    return 'สีเขียวมะนาวช่วยเพิ่มความสดใสและมีชีวิตชีวาให้กับชุด สีเขียวยังทำให้สีเทาดูมีพลัง';
  } else if ((color1 == 0xFF808080 && color2 == 0xFFFFA500) || (color1 == 0xFFFFA500 && color2 == 0xFF808080)) {
    return 'สีส้มเพิ่มความสนุกสนานและพลังให้กับชุดสีเทา ทำให้สีเทาดูมีชีวิตชีวาและน่าสนใจ';
  } else {
    return 'ไม่มีคำแนะนำสำหรับคู่สีนี้';
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
