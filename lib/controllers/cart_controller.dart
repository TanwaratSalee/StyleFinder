import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/news_controller.dart';
import 'package:get/get.dart';
import 'dart:math';

class CartController extends GetxController {
  var totalP = 0.obs;

  //text controllers for shipping details
  var firstnameController = TextEditingController();
  var surnameController = TextEditingController();
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalcodeController = TextEditingController();
  var phoneController = TextEditingController();

  var paymentIndex = 0.obs;

  late dynamic productSnapshot;
  var products = [];
  var vendors = [];

  var placingOrder = false.obs;

  var selectedItems = RxMap<String, bool>(); // Tracks selected items by ID
  var selectAll = false.obs; 
  var isMobileBankingExpanded = false.obs;

  void toggleMobileBankingExpanded() {
    isMobileBankingExpanded.value = !isMobileBankingExpanded.value;
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

  calculate(data) {
    totalP.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {
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
  }

  getProductDetails() {
    products.clear();
    vendors.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'color': productSnapshot[i]['color'],
        'img': productSnapshot[i]['img'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'price': productSnapshot[i]['tprice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title']
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
