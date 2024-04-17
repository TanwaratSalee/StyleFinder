import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/collection_screen/address_controller.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_finalproject/Views/cart_screen/payment_method.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';

class ChoicesScreen extends StatefulWidget {
  const ChoicesScreen({Key? key}) : super(key: key);

  @override
  _ChoicesScreenState createState() => _ChoicesScreenState();
}

class _ChoicesScreenState extends State<ChoicesScreen> {
  List<Map<String, dynamic>> _addresses = [];
  Map<String, dynamic>? _selectedAddress;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            const Text("Shipping Info").text.size(24).fontFamily(medium).make(),
        backgroundColor: whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add new address'),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddressForm())),
            ),
            const Divider(color: thinGrey0),
            Expanded(
              child: ListView.builder(
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  var address = _addresses[index];
                  bool isSelected = _selectedAddress == address;
                  return ListTile(
                    title: Text(
                        '${address['firstname']} ${address['surname']}, ${address['address']}'),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: primaryApp)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedAddress = address;
                      });
                    },
                  );
                },
              ),
            ),
            ourButton(
              onPress: () {
                if (_selectedAddress != null) {
                  Get.to(() => const PaymentMethods());
                } else {
                  VxToast.show(context, msg: "Choose an address");
                }
              },
              color: primaryApp,
              textColor: whiteColor,
              title: "Continue",
            ),
          ],
        ),
      ),
    );
  }
}
