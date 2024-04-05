import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/cart_screen/payment_method.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';

class FirebaseService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot> getCurrentUserAddress() async {
    try {
      String userId = currentUser!.uid;
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
  String? _currentAddress;
  bool _useExistingAddress = true;

  @override
  void initState() {
    super.initState();
    loadCurrentUserAddress();
  }

  Future<void> loadCurrentUserAddress() async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseService().getCurrentUserAddress();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? userData =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('address')) {
          Map<String, dynamic> addressData = userData['address'];
          setState(() {
            _currentAddress =
                '${addressData['address']}, ${addressData['city']}, ${addressData['state']}, ${addressData['postalCode']}, ${addressData['phone']}';
          });
        }
      }
    } catch (error) {
      print('Failed to load user address: $error');
      setState(() {
        _currentAddress = 'Failed to load user address';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text("Shipping Info")
            .text
            .fontFamily(regular)
            .color(fontGreyDark)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ourButton(
          onPress: () {
            if (_useExistingAddress ||
                controller.addressController.text.length > 10) {
              // Here, add logic to save or use the existing/new address as needed
              Get.to(() => const PaymentMethods());
            } else {
              VxToast.show(context, msg: "Please fill the form");
            }
          },
          color: primaryApp,
          textColor: whiteColor,
          title: "Continue",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: Text("Use Current Address ?"),
              value: _useExistingAddress,
              onChanged: (bool value) {
                setState(() {
                  _useExistingAddress = value;
                });
              },
            ),
            if (_useExistingAddress)
              Text(
                _currentAddress ?? 'No Address in Data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            else
              Column(
                children: [
                  customTextField(
                      label: "Address",
                      isPass: false,
                      readOnly: false,
                      controller: controller.addressController),
                  customTextField(
                      label: "City",
                      isPass: false,
                      readOnly: false,
                      controller: controller.cityController),
                  customTextField(
                      label: "State",
                      isPass: false,
                      readOnly: false,
                      controller: controller.stateController),
                  customTextField(
                      label: "Postal Code",
                      isPass: false,
                      readOnly: false,
                      controller: controller.postalcodeController),
                  customTextField(
                      label: "Phone",
                      isPass: false,
                      readOnly: false,
                      controller: controller.phoneController),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
