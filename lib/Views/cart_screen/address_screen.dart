import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/collection_screen/address_controller.dart';
import 'package:flutter_finalproject/controllers/editaddress_controller.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {

  List<String>? addresses;
  List<String>? addressesDocumentIds;
  List<String> loadedAddressesDocumentIds = [];

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

Future<void> loadAddresses() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    List<String> loadedAddresses = [];
    querySnapshot.docs.forEach((doc) {
      String documentId = doc.id;
      loadedAddressesDocumentIds.add(documentId);
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('address') && data['address'] is List) {
        List<dynamic> addressesList = data['address'];
        addressesList.forEach((address) {
          if (address is Map<String, dynamic>) {
            String formattedAddress =
                '${address['firstname']}, ${address['surname']}, ${address['address']}, ${address['city']}, ${address['state']}, ${address['postalCode']}, ${address['phone']}';
            loadedAddresses.add(formattedAddress);
          }
        });
      }
    });
    setState(() {
      addresses = loadedAddresses;
      addressesDocumentIds = loadedAddressesDocumentIds;
    });
  } catch (error) {
    print('Failed to load addresses: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text('Address'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            color: primaryApp,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddressForm()),
                );
              },
              child: Text(
                ' + Add a new address',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: Container(
              color: Colors.white,
              child: addresses != null
                  ? ListView.builder(
                      itemCount: addresses?.length ?? 0,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            //
                          },
                          child: Card(
                            color: Colors.white,
                            child: ListTile(
                              title: Text(addresses![index]),
                              trailing: TextButton(
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(color: primaryApp),
                                ),
                                onPressed: () {
                                  final addressData = addresses![index].split(', ');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => editaddress_controller(
                                        documentId: addressesDocumentIds![index],
                                        firstname: addressData[0],
                                        surname: addressData[1],
                                        address: addressData[2],
                                        city: addressData[3],
                                        state: addressData[4],
                                        postalCode: addressData[5],
                                        phone: addressData[6],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}