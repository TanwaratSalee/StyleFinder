import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/collection_screen/address_controller.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_finalproject/Views/cart_screen/payment_method.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';

class FirebaseService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot> getCurrentUserAddress(String userId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await usersCollection.doc(userId).get();
      return documentSnapshot;
    } catch (error) {
      throw error;
    }
  }
}

class ShippingDetails extends StatefulWidget {
  const ShippingDetails({Key? key}) : super(key: key);

  @override
  _ShippingDetailsState createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {
  List<Map<String, dynamic>> _addresses = [];
  Map<String, dynamic>? _selectedAddress;

  @override
  void initState() {
    super.initState();
    loadCurrentUserAddress();
  }

  Future<void> loadCurrentUserAddress() async {
    String userId = currentUser!.uid; // Ensure currentUser is not null
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseService().getCurrentUserAddress(userId);
      if (documentSnapshot.exists) {
        Map<String, dynamic>? userData = documentSnapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('address')) {
          List<dynamic> addressesList = userData['address'];
          setState(() {
            _addresses = List<Map<String, dynamic>>.from(addressesList);
          });
        }
      }
    } catch (error) {
      print('Failed to load user address: $error');
      // Handle error appropriately
    }
  }

  void _showAddressDialog(String address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Selected Address'),
        content: Text(address),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text("Shipping Info"),
        backgroundColor: primaryApp,
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ourButton(
          onPress: () {
            if (_selectedAddress != null || controller.addressController.text.isNotEmpty) {
              // Logic to save or use the existing/new address as needed
              Get.to(() => const PaymentMethods());
            } else {
              // Show toast or another form of error
            }
          },
          color: primaryApp,
          textColor: whiteColor,
          title: "Continue",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Existing addresses
            Expanded(
              child: ListView.builder(
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  var address = _addresses[index];
                  String addressString = '${address['firstname']}, ${address['surname']}, ${address['address']}, ${address['city']}, ${address['state']}, ${address['postalCode']}, ${address['phone']}';
                  return Card(
                    child: ListTile(
                      title: Text(addressString),
                      onTap: () {
                        setState(() {
                          controller.setSelectedAddress(address);
                          _selectedAddress = address;
                        });
                        _showAddressDialog(addressString);
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            // Button to add a new address
            ourButton(
              onPress: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddressForm()),
              ),
              color: primaryApp,
              textColor: whiteColor,
              title: "+ Add a new address",
            ),
          ],
        ),
      ),
    );
  }
}
