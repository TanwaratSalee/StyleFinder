import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/collection_screen/address_controller.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_finalproject/Views/cart_screen/payment_method.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';

class FirebaseService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  //real time
  Stream<DocumentSnapshot> streamCurrentUserAddress(String userId) {
    return usersCollection.doc(userId).snapshots();
  }

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

  String capitalize(String text) {
    if (text.isEmpty) return "";
    return text[0].toUpperCase() + text.substring(1);
  }

  String formatPhoneNumber(String phone) {
    return '(+66) $phone';
  }

  Future<void> loadCurrentUserAddress() async {
    String userId = currentUser!.uid; // Ensure currentUser is not null
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseService().getCurrentUserAddress(userId);
      if (documentSnapshot.exists) {
        Map<String, dynamic>? userData =
            documentSnapshot.data() as Map<String, dynamic>?;
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
        title: const Text('Selected Address'),
        content: Text(address),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            const Text("Shipping Info").text.size(24).fontFamily(medium).color(greyDark2).make(),
        backgroundColor: whiteColor,
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ourButton(
          onPress: () {
            if (_selectedAddress != null ||
                controller.addressController.text.isNotEmpty) {
              Get.to(() => const PaymentMethods());
            } else {
              VxToast.show(context, msg: "Choose an address");
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
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add new address'),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddressForm()),
                );
              },
            ),
            const Divider(color: thinGrey0),
            // ourButton(
            //   onPress: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => AddressForm()),
            //   ),
            //   color: whiteColor,
            //   textColor: greyDark2,
            //   title: "+ Add a new address",
            // ),
            // const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseService().streamCurrentUserAddress(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text("No addresses found."));
                  }

                  Map<String, dynamic>? userData =
                      snapshot.data!.data() as Map<String, dynamic>?;
                  List<dynamic> addressesList = userData?['address'] ?? [];
                  return ListView.separated(
                    itemCount: addressesList.length,
                    itemBuilder: (context, index) {
                      var address =
                          Map<String, dynamic>.from(addressesList[index]);
                      bool isSelected = _selectedAddress != null &&
                          _selectedAddress!.containsValue(address['address']);

                      return Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? thinPrimaryApp.withOpacity(0.2)
                              : whiteColor,
                          border: isSelected
                              ? Border.all(color: primaryApp, width: 2,)
                              : null,borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                color: greyDark1,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      '${capitalize(address['firstname'])} ${capitalize(address['surname'])},\n',
                                  style: TextStyle(
                                      fontFamily: medium,fontSize: 16 , height: 3.0),
                                ),
                                TextSpan(
                                  text:
                                      '${formatPhoneNumber(address['phone'])},\n',
                                  style:
                                      TextStyle(fontFamily: regular,fontSize: 16 , height: 1.5),
                                ),
                                TextSpan(
                                  text:
                                      '${capitalize(address['address'])}, ${capitalize(address['city'])},\n${capitalize(address['state'])},${address['postalCode']}\n',
                                  style:
                                      TextStyle(fontFamily: regular,fontSize: 16 ,height: 1.5),
                                ),
                              ],
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: primaryApp)
                              : null,
                          onTap: () {
                            setState(() {
                              controller.setSelectedAddress(address);
                              _selectedAddress = address;
                            });
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(color: thinGrey01),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
