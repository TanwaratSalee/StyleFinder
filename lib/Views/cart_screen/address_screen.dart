import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/profile_screen/menu_addAddress_screen.dart';
import 'package:flutter_finalproject/controllers/editaddress_controller.dart';
import 'package:flutter_finalproject/consts/consts.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  List<String>? addresses;
  List<String>? addressesDocumentIds;
  List<String> loadedAddressesDocumentIds = [];
  final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  void initState() {
    super.initState();
    loadAddresses(currentUserUid);
  }

  Future<void> loadAddresses(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      List<String> loadedAddresses = [];
      if (documentSnapshot.exists) {
        String documentId = documentSnapshot.id;
        loadedAddressesDocumentIds.add(documentId);
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null &&
            data.containsKey('address') &&
            data['address'] is List) {
          List<dynamic> addressesList = data['address'];
          addressesList.forEach((address) {
            if (address is Map<String, dynamic>) {
              String formattedAddress = '${address['firstname']},${address['surname']},${address['address']},${address['city']},${address['state']},${address['postalCode']},${address['phone']}';
              loadedAddresses.add(formattedAddress);
            }
          });
        }
      }

      setState(() {
        addresses = loadedAddresses;
        addressesDocumentIds = loadedAddressesDocumentIds;
      });
    } catch (error) {
      print('Failed to load addresses for user $uid: $error');
    }
  }

  Future<void> removeAddress(String uid, int index) async {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      DocumentSnapshot documentSnapshot = await docRef.get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null &&
            data.containsKey('address') &&
            data['address'] is List) {
          List<dynamic> addressesList = List.from(data['address']);

          addressesList.removeAt(index);

          await docRef.update({'address': addressesList});

          await loadAddresses(uid);
        }
      }
    } catch (error) {
      print("Error removing address: $error");
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
            // color: primaryApp,
            child: ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add new address'),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddressForm()),
                );
              },
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: Container(
              color: whiteColor,
              child: addresses != null
                  ? ListView.builder(
                      itemCount: addresses?.length ?? 0,
                      itemBuilder: (context, index) {
                        String uid = currentUser!.uid;
                        return GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(4), // Optional: if you want rounded corners
                                ),
                                child: ListTile(
                                  title: Text(addresses![index]),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        child: const Text(
                                          'Edit',
                                          style: TextStyle(
                                              color:
                                                  primaryApp), // Make sure primaryApp is defined
                                        ),
                                        onPressed: () {
                                          final addressData =
                                              addresses![index].split(',');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  editaddress_controller(
                                                documentId:
                                                    addressesDocumentIds![
                                                        index],
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
                                      TextButton(
                                        child: const Text(
                                          'Remove',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            removeAddress(uid, index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                                const Divider(color: greyColor0).box.margin(EdgeInsets.symmetric(horizontal: 12)).make(),
                            ],
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
