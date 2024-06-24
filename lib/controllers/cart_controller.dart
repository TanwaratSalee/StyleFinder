import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/news_controller.dart';
import 'package:get/get.dart';
import 'dart:math';

class CartController extends GetxController {
  // Text controllers for shipping details
  var firstnameController = TextEditingController();
  var surnameController = TextEditingController();
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalcodeController = TextEditingController();
  var phoneController = TextEditingController();

  var paymentIndex = 0.obs;
  var products = [];
  var vendors = [];
  var placingOrder = false.obs;
  var selectedItems = RxMap<String, bool>();
  var selectAll = false.obs;
  var isMobileBankingExpanded = false.obs;
  var productSnapshot = <DocumentSnapshot>[].obs;
  var totalP = 0.obs;

  void updateCart(List<QueryDocumentSnapshot> products) {
    productSnapshot.value = products.cast<DocumentSnapshot>();
    recalculateTotalPrice();
  }

  void calculate(List<DocumentSnapshot> data) {
    totalP.value =
        data.fold<int>(0, (sum, item) => sum + (item['total_price'] as int));
  }

  void toggleMobileBankingExpanded() {
    isMobileBankingExpanded.value = !isMobileBankingExpanded.value;
  }

  void incrementCount(String docId) async {
    var currentItem =
        productSnapshot.firstWhere((element) => element.id == docId);
    int currentQty = currentItem['qty'];
    double unitPrice =
        (currentItem['total_price'] as num).toDouble() / currentQty;
    int newQty = currentQty + 1;
    double newTprice = unitPrice * newQty;

    await currentItem.reference.update({
      'qty': newQty,
      'total_price': newTprice,
    });

    DocumentSnapshot updatedItem = await currentItem.reference.get();
    int index = productSnapshot.indexWhere((element) => element.id == docId);
    if (index != -1 && updatedItem.exists) {
      productSnapshot[index] = updatedItem;
    }
    recalculateTotalPrice();
  }

  void decrementCount(String docId) async {
    try {
      var currentItem =
          productSnapshot.firstWhere((element) => element.id == docId);
      Map<String, dynamic>? currentData =
          currentItem.data() as Map<String, dynamic>?;

      if (currentData != null) {
        int currentQty = currentData['qty'] ?? 0;
        if (currentQty > 1) {
          double unitPrice =
              (currentData['total_price'] as num).toDouble() / currentQty;
          int newQty = currentQty - 1;
          double newTprice = unitPrice * newQty;

          await currentItem.reference.update({
            'qty': newQty,
            'total_price': newTprice,
          });

          var updatedItem = await currentItem.reference.get();
          int index =
              productSnapshot.indexWhere((element) => element.id == docId);
          if (index != -1 && updatedItem.exists) {
            productSnapshot[index] = updatedItem;
          }
        } else {
          await currentItem.reference.delete();
          productSnapshot.removeWhere((element) => element.id == docId);
        }
        recalculateTotalPrice();
      } else {
        print("Current item data is null");
      }
    } catch (e) {
      print("Error decrementing count: $e");
    }
  }

  void recalculateTotalPrice() {
    totalP.value = productSnapshot.fold<double>(0.0, (sum, item) {
      var price = (item.data() as Map<String, dynamic>)['total_price'];
      return sum + (price is int ? price.toDouble() : price as double);
    }).toInt();
  }

  void removeItem(String docId) async {
    try {
      var currentItem =
          productSnapshot.firstWhere((element) => element.id == docId);
      await currentItem.reference.delete();
      productSnapshot.removeWhere((element) => element.id == docId);
      recalculateTotalPrice();
    } catch (e) {
      print("Error removing item: $e");
    }
  }

  Map<String, dynamic>? _selectedAddress;

  List<Map<String, dynamic>> selectedProducts = [];
  double totalPrice = 0.0;

  void setSelectedAddress(Map<String, dynamic>? address) {
    _selectedAddress = address;
  }

  void toggleItemSelection(String id) {
    final isSelected = selectedItems[id] ?? false;
    selectedItems[id] = !isSelected;
    updateSelectedItems();
  }

  void toggleSelectAll() {
    final newState = !selectAll.value;
    selectAll.value = newState;
    selectedItems.forEach((key, _) {
      selectedItems[key] = newState;
    });
  }

  void updateSelectedItems() {
    if (selectedItems.values.any((isSelected) => !isSelected)) {
      selectAll.value = false;
    } else {
      selectAll.value = true;
    }
  }

  double calculateTotalPrice() {
    return selectedItems.entries.fold(0.0, (sum, entry) {
      if (entry.value) {
        var item =
            productSnapshot.firstWhere((element) => element.id == entry.key);
        return sum + (item['total_price'] as int).toDouble();
      }
      return sum;
    });
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);
    await getProductDetails();

    String firstname = _selectedAddress?['firstname'] ?? '';
    String surname = _selectedAddress?['surname'] ?? '';
    String address = _selectedAddress?['address'] ?? '';
    String state = _selectedAddress?['state'] ?? '';
    String city = _selectedAddress?['city'] ?? '';
    String phone = _selectedAddress?['phone'] ?? '';
    String postalcode = _selectedAddress?['postalCode'] ?? '';

    Map<String, List<Map<String, dynamic>>> groupedProducts = {};
    for (var product in products) {
      String vendorId = product['vendor_id'];
      if (!groupedProducts.containsKey(vendorId)) {
        groupedProducts[vendorId] = [];
      }
      groupedProducts[vendorId]!.add(product);
    }

    double totalOrderAmount = 0.0;

    for (var entry in groupedProducts.entries) {
      String vendorId = entry.key;
      List<Map<String, dynamic>> vendorProducts = entry.value;

      var vendorSnapshot =
          await firestore.collection('vendors').doc(vendorId).get();
      String vendorName = 'Unknown Vendor';
      if (vendorSnapshot.exists) {
        vendorName = vendorSnapshot['name'] ?? 'Unknown Vendor';
      }

      double vendorTotalAmount = vendorProducts.fold(0.0, (sum, item) {
        double itemPrice =
            item['total_price'] != null ? item['total_price'].toDouble() : 0.0;
        return sum + itemPrice;
      });

      totalOrderAmount += vendorTotalAmount;

      var orderRef = await firestore.collection(ordersCollection).add({
        'created_at': FieldValue.serverTimestamp(),
        'user_id': currentUser!.uid,
        'address': {
          'order_by_email': currentUser!.email,
          'order_by_firstname': firstname,
          'order_by_surname': surname,
          'order_by_address': address,
          'order_by_state': state,
          'order_by_city': city,
          'order_by_phone': phone,
          'order_by_postalcode': postalcode,
        },
        'payment_method': orderPaymentMethod,
        'order_placed': true,
        'order_confirmed': false,
        'order_delivered': false,
        'order_on_delivery': false,
        'total_amount': vendorTotalAmount,
        'orders': vendorProducts,
        'vendor_id': vendorId,
      });

      await orderRef.update({'order_id': orderRef.id});
    }

    print('Total order amount: $totalOrderAmount');

    placingOrder(false);
  }

  getProductDetails() async {
    products.clear();
    vendors.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      var cartProductData = productSnapshot[i].data() as Map<String, dynamic>;
      var productId =
          cartProductData['product_id']; // Use product_id from cart data

      // Print the productId
      print('Processing productId: $productId');

      // Fetch product details from 'products' collection using product_id
      var productDetailsSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (productDetailsSnapshot.exists &&
          productDetailsSnapshot.data() != null) {
        var productData =
            productDetailsSnapshot.data() as Map<String, dynamic>?;

        // Fetch vendor name from 'vendors' collection using vendor_id
        var vendorId = cartProductData['vendor_id'];
        var vendorSnapshot = await FirebaseFirestore.instance
            .collection('vendors')
            .doc(vendorId)
            .get();

        String vendorName = 'Unknown Vendor';
        if (vendorSnapshot.exists && vendorSnapshot.data() != null) {
          var vendorData = vendorSnapshot.data() as Map<String, dynamic>;
          vendorName = vendorData['name'] ?? 'Unknown Vendor';
        }

        products.add({
          'product_id': productId,
          'vendor_id': vendorId ?? '',
          'qty': cartProductData['qty'] ?? 0,
          'total_price': cartProductData['total_price'] ?? 0,
          'reviews': false,
        });
        vendors.add(vendorId ?? '');
      } else {
        products.add({
          'product_id': productId,
          'qty': cartProductData['qty'] ?? 0,
          'total_price': cartProductData['total_price'] ?? 0,
          'reviews': false,
        });
        vendors.add(cartProductData['vendor_id'] ?? '');
      }
    }
  }

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }

  isSelected(String id) {}

  void toggleSelected(String id, bool bool) {}
}

String generateRandomOrderCode(int length) {
  final Random _random = Random();
  const String _availableChars = '0123456789';
  final String _randomString = List.generate(length,
      (_) => _availableChars[_random.nextInt(_availableChars.length)]).join();

  return _randomString;
}
