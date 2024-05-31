import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/profile_screen/Add_Address_screen.dart';
import 'package:flutter_finalproject/controllers/editaddress_controller.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  String formatPhoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'\D'), '');

    if (cleaned.length == 10) {
      final RegExp regExp = RegExp(r'(\d{3})(\d{3})(\d{4})');
      return cleaned.replaceAllMapped(regExp, (Match match) {
        return '(+66) ${match[1]}-${match[2]}-${match[3]}';
      });
    } else if (cleaned.length == 9) {
      final RegExp regExp = RegExp(r'(\d{2})(\d{3})(\d{4})');
      return cleaned.replaceAllMapped(regExp, (Match match) {
        return '(+66) ${match[1]}-${match[2]}-${match[3]}';
      });
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text('Address').text
            .size(26)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
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
            child: ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add new address'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddressForm()),
                );
              },
            ),
          ),
          Divider(color: greyThin).box.padding(EdgeInsets.symmetric(horizontal: 12)).make(),
          Expanded(
            child: Container(
              color: whiteColor,
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUserUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text('No addresses found.'));
                  }

                  Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
                  List<dynamic> addressesList = data?['address'] ?? [];

                  return ListView.builder(
                    itemCount: addressesList.length,
                    itemBuilder: (context, index) {
                      var address = addressesList[index];
                      String formattedAddress =
                          '${address['firstname'] ?? ''} ${address['surname'] ?? ''},\n${address['address'] ?? ''}, ${address['city'] ?? ''}, ${address['state'] ?? ''}, ${address['postalCode'] ?? ''} \n${formatPhoneNumber(address['phone'] ?? '')}';
                      return GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ListTile(
                                title: Text(formattedAddress),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      child: const Text(
                                        'Edit',
                                        style: TextStyle(color: primaryApp),
                                      ),
                                      onPressed: () {
                                        Navigator.push(context,
                                          MaterialPageRoute(
                                            builder: (context) => editaddress_controller(
                                              documentId: snapshot.data!.id,
                                              firstname: address['firstname'] ?? '',
                                              surname: address['surname'] ?? '',
                                              address: address['address'] ?? '',
                                              city: address['city'] ?? '',
                                              state: address['state'] ?? '',
                                              postalCode: address['postalCode'] ?? '',
                                              phone: address['phone'] ?? '',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    TextButton(
                                      child: const Text(
                                        'Remove',
                                        style: TextStyle(color: redColor),
                                      ),
                                      onPressed: () async {
                                        await removeAddress(index);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(color: greyThin)
                                .box
                                .margin(EdgeInsets.symmetric(horizontal: 12))
                                .make(),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> removeAddress(int index) async {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(currentUserUid);

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
        }
      }
    } catch (error) {
      print("Error removing address: $error");
    }
  }
}
