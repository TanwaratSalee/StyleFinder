import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/cart_screen/detailforshipping.dart';
import 'package:flutter_finalproject/Views/profile_screen/menu_addaddress_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';

class AddressForm extends StatefulWidget {
  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void saveAddressToFirestore() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String firstname = _firstnameController.text;
    String surname = _surnameController.text;
    String address = _addressController.text;
    String city = _cityController.text;
    String state = _stateController.text;
    String postalCode = _postalCodeController.text.replaceAll(RegExp(r'\D'), '');
    String phone = _phoneController.text.replaceAll(RegExp(r'\D'), '');

    if (firstname.isNotEmpty &&
        surname.isNotEmpty &&
        address.isNotEmpty &&
        city.isNotEmpty &&
        state.isNotEmpty &&
        postalCode.isNotEmpty &&
        phone.isNotEmpty) {
      if (address.length > 10 && phone.length >= 10 && postalCode.length >= 5) {
        try {
          await FirebaseService().updateAddressForCurrentUser(userId, firstname,
              surname, address, city, state, postalCode, phone);
          VxToast.show(context, msg: "Successfully saved Address");
          Navigator.pop(context);
        } catch (e) {
          VxToast.show(context, msg: "Error saving address: ${e.toString()}");
        }
      } else {
        if (address.length <= 10) {
          VxToast.show(context, msg: "Address should be at least 10 characters long");
        }
        if (phone.length < 10) {
          VxToast.show(context, msg: "Phone number should be at least 10 digits long");
        }
        if (postalCode.length < 5) {
          VxToast.show(context, msg: "Postal code should be at least 5 digits long");
        }
      }
    } else {
      VxToast.show(context, msg: "Please fill all the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Add Address".text.size(26).fontFamily(semiBold).color(blackColor).make(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
        child: tapButton(
            onPress: () {
              saveAddressToFirestore();
            },
            color: primaryApp,
            textColor: whiteColor,
            title: "Save"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          child: Column(
            children: [
              customTextField(
                  label: "First name",
                  isPass: false,
                  readOnly: false,
                  controller: _firstnameController),
              15.heightBox,
              customTextField(
                  label: "Surname",
                  isPass: false,
                  readOnly: false,
                  controller: _surnameController),
              15.heightBox,
              customTextField(
                  label: "Address",
                  isPass: false,
                  readOnly: false,
                  controller: _addressController),
              15.heightBox,
              customTextField(
                  label: "City",
                  isPass: false,
                  readOnly: false,
                  controller: _cityController),
              15.heightBox,
              customTextField(
                  label: "State",
                  isPass: false,
                  readOnly: false,
                  controller: _stateController),
              15.heightBox,
              customTextField(
                  label: "Postal Code",
                  isPass: false,
                  readOnly: false,
                  controller: _postalCodeController),
              15.heightBox,
              customTextField(
                  label: "Phone",
                  isPass: false,
                  readOnly: false,
                  controller: _phoneController,
                   inputFormatters: [PhoneNumberInputFormatter()]),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}

class ShippingInfoDetails extends StatefulWidget {
  const ShippingInfoDetails({Key? key}) : super(key: key);

  @override
  _ShippingInfoDetailsState createState() => _ShippingInfoDetailsState();
}

class _ShippingInfoDetailsState extends State<ShippingInfoDetails> {
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

  Future<void> loadCurrentUserAddress() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      DocumentSnapshot documentSnapshot = await FirebaseService().getCurrentUserAddress(userId);
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
    }
  }

  void showAddressDialog(String address) {
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
        title: const Text("Shipping Info")
            .text
            .size(26)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
        backgroundColor: whiteColor,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
        child: SizedBox(
          height: 50,
          child: tapButton(
            onPress: () {
              if (_selectedAddress != null ||
                  controller.addressController.text.isNotEmpty) {
                Get.to(() => DetailForShipping(
                      address: _selectedAddress,
                      cartItems: controller.productSnapshot,
                      totalPrice: controller.totalP.value,
                    ));
              } else {
                VxToast.show(context, msg: "Choose an address");
              }
            },
            color: primaryApp,
            textColor: whiteColor,
            title: "Continue",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
            const Divider(color: greyLine),
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

                  Map<String, dynamic>? userData = snapshot.data!.data() as Map<String, dynamic>?;
                  List<dynamic> addressesList = userData?['address'] ?? [];
                  return ListView.separated(
                    itemCount: addressesList.length,
                    itemBuilder: (context, index) {
                      var address = Map<String, dynamic>.from(addressesList[index]);
                      bool isSelected = _selectedAddress != null &&
                          _selectedAddress!.containsValue(address['address']);

                      return Container(
                        decoration: BoxDecoration(
                          color: isSelected ? thinPrimaryApp.withOpacity(0.2) : whiteColor,
                          border: isSelected ? Border.all(color: primaryApp, width: 2) : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 14, color: blackColor),
                              children: [
                                TextSpan(
                                  text: '${capitalize(address['firstname'])} ${capitalize(address['surname'])},\n',
                                  style: TextStyle(fontFamily: medium, height: 2),
                                ),
                                TextSpan(
                                  text: '${formatPhoneNumber(address['phone'])},\n',
                                  style: TextStyle(fontFamily: light),
                                ),
                                TextSpan(
                                  text: '${capitalize(address['address'])}, ${capitalize(address['city'])},\n ${capitalize(address['state'])}, ${address['postalCode']}\n',
                                  style: TextStyle(fontFamily: light),
                                ),
                              ],
                            ),
                          ),
                          trailing: isSelected ? Icon(Icons.check_circle, color: primaryApp) : null,
                          onTap: () {
                            setState(() {
                              controller.setSelectedAddress(address);
                              _selectedAddress = address;
                            });
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(color: greyLine),
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
class FirebaseService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  // Real-time stream
  Stream<DocumentSnapshot> streamCurrentUserAddress(String userId) {
    return usersCollection.doc(userId).snapshots();
  }

  Future<DocumentSnapshot> getCurrentUserAddress(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await usersCollection.doc(userId).get();
      return documentSnapshot;
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateAddressForCurrentUser(
      String userId,
      String firstname,
      String surname,
      String address,
      String city,
      String state,
      String postalCode,
      String phone) async {
    try {
      if (firstname.isNotEmpty &&
          surname.isNotEmpty &&
          address.isNotEmpty &&
          city.isNotEmpty &&
          state.isNotEmpty &&
          postalCode.isNotEmpty &&
          phone.isNotEmpty) {
        DocumentSnapshot documentSnapshot = await usersCollection.doc(userId).get();
        if (documentSnapshot.exists) {
          Map<String, dynamic>? userData = documentSnapshot.data() as Map<String, dynamic>?;
          if (userData != null) {
            if (userData.containsKey('address')) {
              List<dynamic>? addressList = List.from(userData['address']);
              if (addressList == null) {
                addressList = [];
              }

              addressList.add({
                'firstname': firstname,
                'surname': surname,
                'address': address,
                'city': city,
                'state': state,
                'postalCode': postalCode,
                'phone': phone,
              });

              await usersCollection.doc(userId).update({
                'address': addressList,
              });
            } else {
              await usersCollection.doc(userId).update({
                'address': [
                  {
                    'firstname': firstname,
                    'surname': surname,
                    'address': address,
                    'city': city,
                    'state': state,
                    'postalCode': postalCode,
                    'phone': phone,
                  }
                ],
              });
            }
          }
        }
        print('Address updated successfully for user $userId');
      } else {
        print('One or more fields are empty. Failed to update address.');
      }
    } catch (error) {
      print('Failed to update address: $error');
    }
  }
}

