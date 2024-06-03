import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/news_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';
import 'dart:math';

class CartController extends GetxController {
  //text controllers for shipping details
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

  void toggleMobileBankingExpanded() {
    isMobileBankingExpanded.value = !isMobileBankingExpanded.value;
  }

  var productSnapshot = <QueryDocumentSnapshot>[].obs;
  var totalP = 0.obs;

  void calculate(List<QueryDocumentSnapshot> data) {
    totalP.value =
        data.fold<int>(0, (sum, item) => sum + (item['tprice'] as int));
  }

  void incrementCount(String docId) {
    var currentItem =
        productSnapshot.firstWhere((element) => element.id == docId);
    int currentQty = currentItem['qty'];
    int price = currentItem['tprice'];
    int newQty = currentQty + 1;
    int newTprice = price * newQty;
    FirestoreServices.updateDocumentCart(
        docId, {'qty': newQty, 'tprice': newTprice});
    currentItem.reference.update({'qty': newQty, 'tprice': newTprice});
    recalculateTotalPrice();
  }

  void decrementCount(String docId) {
    var currentItem =
        productSnapshot.firstWhere((element) => element.id == docId);
    int currentQty = currentItem['qty'];
    if (currentQty > 1) {
      int currentTprice = currentItem['tprice'];
      int unitPrice = currentTprice ~/ currentQty;
      int newQty = currentQty - 1;
      int newTprice = unitPrice * newQty;
      FirestoreServices.updateDocumentCart(
          docId, {'qty': newQty, 'tprice': newTprice});
      currentItem.reference.update({'qty': newQty, 'tprice': newTprice});
      recalculateTotalPrice();
    }
  }

  void recalculateTotalPrice() {
    totalP.value = productSnapshot.fold<int>(
        0, (sum, item) => sum + (item['tprice'] as int));
  }

  Map<String, dynamic>? _selectedAddress;

  List<Map<String, dynamic>> selectedProducts = [];
  double totalPrice = 0.0;

  void setSelectedAddress(Map<String, dynamic>? address) {
    _selectedAddress = address;
  }

  // Toggle individual item selection
  void toggleItemSelection(String id) {
    final isSelected = selectedItems[id] ?? false;
    selectedItems[id] = !isSelected;
    updateSelectedItems();
  }

  // Toggle the selection of all items
  void toggleSelectAll() {
    final newState = !selectAll.value;
    selectAll.value = newState;
    selectedItems.forEach((key, _) {
      selectedItems[key] = newState;
    });
  }

  // Update the selectAll status based on individual item selections
  void updateSelectedItems() {
    if (selectedItems.values.any((isSelected) => !isSelected)) {
      selectAll.value = false;
    } else {
      selectAll.value = true;
    }
  }

  // Method to calculate total price (implementation depends on your data structure)
  double calculateTotalPrice() {
    // Placeholder calculation, replace with your logic
    return 0.0;
  }

/*   calculate(data) {
    totalP.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  } */

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

/*   placeMyOrder({required orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);
    await getProductDetails();
    String orderCode = generateRandomOrderCode(8);

    String firstname = _selectedAddress?['firstname'] ?? '';
    String surname = _selectedAddress?['surname'] ?? '';
    String address = _selectedAddress?['address'] ?? '';
    String state = _selectedAddress?['state'] ?? '';
    String city = _selectedAddress?['city'] ?? '';
    String phone = _selectedAddress?['phone'] ?? '';
    String postalcode = _selectedAddress?['postalCode'] ?? '';

    await firestore.collection(ordersCollection).doc().set({
      'order_code': orderCode,
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<NewsController>().username,
      'order_by_email': currentUser!.email,
      'order_by_firstname': firstname,
      'order_by_surname': surname,
      'order_by_address': address,
      'order_by_state': state,
      'order_by_city': city,
      'order_by_phone': phone,
      'order_by_postalcode': postalcode,
      'shipping_method': "Home Delivery",
      'payment_method': orderPaymentMethod,
      'order_placed': true,
      'order_confirmed': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products),
      'vendors': FieldValue.arrayUnion(vendors)
    });
    placingOrder(false);
  } */

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

    // Group products by vendor_id
    Map<String, List<Map<String, dynamic>>> groupedProducts = {};
    for (var product in products) {
      String vendorId = product['vendor_id'];
      if (!groupedProducts.containsKey(vendorId)) {
        groupedProducts[vendorId] = [];
      }
      groupedProducts[vendorId]!.add(product);
    }

    double totalOrderAmount = 0.0;

    // Create separate order documents for each vendor
    for (var entry in groupedProducts.entries) {
      String vendorId = entry.key;
      List<Map<String, dynamic>> vendorProducts = entry.value;

      // Fetch vendor details
      var vendorSnapshot =
          await firestore.collection(vendorsCollection).doc(vendorId).get();
      String vendorName = 'Unknown Vendor';
      if (vendorSnapshot.exists) {
        vendorName = vendorSnapshot['vendor_name'] ?? 'Unknown Vendor';
      }

      // Calculate total amount for this vendor
      double vendorTotalAmount = vendorProducts.fold(0.0, (sum, item) {
        double itemPrice =
            item['price'] != null ? item['price'].toDouble() : 0.0;
        return sum + itemPrice;
      });

      // Add vendorTotalAmount to the overall total
      totalOrderAmount += vendorTotalAmount;

      // Create a new document and get its ID
      var orderRef = await firestore.collection(ordersCollection).add({
        'order_code': generateRandomOrderCode(8),
        'order_date': FieldValue.serverTimestamp(),
        'order_by': currentUser!.uid,
        'order_by_name': Get.find<NewsController>().username,
        'order_by_email': currentUser!.email,
        'order_by_firstname': firstname,
        'order_by_surname': surname,
        'order_by_address': address,
        'order_by_state': state,
        'order_by_city': city,
        'order_by_phone': phone,
        'order_by_postalcode': postalcode,
        'shipping_method': "Home Delivery",
        'payment_method': orderPaymentMethod,
        'order_placed': true,
        'order_confirmed': false,
        'order_delivered': false,
        'order_on_delivery': false,
        'total_amount': vendorTotalAmount,
        'orders': vendorProducts,
        'vendor_id': vendorId,
        'vendor_name': vendorName,
      });

      await orderRef.update({'id': orderRef.id});
    }
    // Update the overall total amount
    print('Total order amount: $totalOrderAmount');

    placingOrder(false);
  }

  getProductDetails() {
    products.clear();
    vendors.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'product_id': productSnapshot[i]['document_id'],
        'img': productSnapshot[i]['img'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'price': productSnapshot[i]['tprice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title'],
        'sellername': productSnapshot[i]['sellername'],
        'reviews': false,
      });
      vendors.add(productSnapshot[i]['vendor_id']);
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
