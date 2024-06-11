import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_finalproject/Views/profile_screen/menu_addaddress_screen.dart';
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
        title: const Text('Address')
            .text
            .size(26)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
            Divider(color: greyThin)
                .box
                .padding(EdgeInsets.symmetric(horizontal: 12))
                .make(),
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

                    Map<String, dynamic>? data =
                        snapshot.data!.data() as Map<String, dynamic>?;
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
                                  title: Text(formattedAddress)
                                      .text
                                      .fontFamily(regular)
                                      .color(greyDark)
                                      .make(),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        child: const Text(
                                          'Edit',
                                        )
                                            .text
                                            .size(16)
                                            .fontFamily(medium)
                                            .color(primaryApp)
                                            .make(),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  editaddress_controller(
                                                documentId: snapshot.data!.id,
                                                firstname:
                                                    address['firstname'] ?? '',
                                                surname:
                                                    address['surname'] ?? '',
                                                address:
                                                    address['address'] ?? '',
                                                city: address['city'] ?? '',
                                                state: address['state'] ?? '',
                                                postalCode:
                                                    address['postalCode'] ?? '',
                                                phone: address['phone'] ?? '',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          'Remove',
                                        )
                                            .text
                                            .size(16)
                                            .fontFamily(medium)
                                            .color(redColor)
                                            .make(),
                                        onPressed: () async {
                                          popupDeleteAddress(context, index);
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

          // Show toast notification
          VxToast.show(context, msg: "Address deleted successfully");
        }
      }
    } catch (error) {
      print("Error removing address: $error");
    }
  }

  void popupDeleteAddress(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              15.heightBox,
              const Text('Delete Address')
                  .text
                  .size(24)
                  .fontFamily(semiBold)
                  .color(blackColor)
                  .makeCentered(),
              10.heightBox,
              const Text('Are you sure you want to delete this address?')
                  .text
                  .size(14)
                  .fontFamily(regular)
                  .color(greyDark)
                  .makeCentered(),
              5.heightBox,
              Center(
                child: const Text(
                        'This action cannot be undone.')
                    .text
                    .size(12)
                    .fontFamily(regular)
                    .color(greyDark)
                    .makeCentered(),
              ),
              15.heightBox,
              const Divider(
                height: 1,
                color: greyLine,
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        child: const Text('Cancel',
                            style: TextStyle(
                                color: greyDark,
                                fontFamily: medium,
                                fontSize: 14)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const VerticalDivider(
                        width: 1, thickness: 1, color: greyLine),
                    Expanded(
                      child: TextButton(
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                              color: redColor,
                              fontFamily: medium,
                              fontSize: 14),
                        ),
                        onPressed: () async {
                          await removeAddress(index);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
