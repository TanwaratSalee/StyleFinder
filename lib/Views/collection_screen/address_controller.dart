import 'package:flutter_finalproject/Views/cart_screen/payment_method.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot> getCurrentUserAddress() async {
    try {
      String userId = currentUser!.uid;
      DocumentSnapshot documentSnapshot = await usersCollection.doc(userId).get();
      return documentSnapshot;
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateAddressForCurrentUser(String userId, String address, String city, String state, String postalCode, String phone) async {
    try {
      // ตรวจสอบว่าค่าไม่เป็นค่าว่างเปล่าก่อนที่จะทำการอัปเดต
      if (address.isNotEmpty && city.isNotEmpty && state.isNotEmpty && postalCode.isNotEmpty && phone.isNotEmpty) {
        await usersCollection.doc(currentUser!.uid).update({
          'address': {
            'address': address,
            'city': city,
            'state': state,
            'postalCode': postalCode,
            'phone': phone,
          },
        });
        print('Address updated successfully for user $userId');
      } else {
        print('One or more fields are empty. Failed to update address.');
      }
    } catch (error) {
      print('Failed to update address: $error');
    }
  }
}

class AddressForm extends StatefulWidget {
  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {

  String _currentAddress = '';
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> loadCurrentUserAddress() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseService().getCurrentUserAddress();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? userData = documentSnapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('address')) {
          Map<String, dynamic> addressData = userData['address'];
          setState(() {
            _currentAddress = '${addressData['address']}, ${addressData['city']}, ${addressData['state']}, ${addressData['postalCode']}, ${addressData['phone']}';
          });
          _addressController.text = addressData['address'] ?? '';
          _cityController.text = addressData['city'] ?? '';
          _stateController.text = addressData['state'] ?? '';
          _postalCodeController.text = addressData['postalCode'] ?? '';
          _phoneController.text = addressData['phone'] ?? '';
        }
      }
    } catch (error) {
      print('Failed to load user address: $error');
    }
  }

    @override
  void initState() {
    super.initState();
    loadCurrentUserAddress();
  }
  
void saveAddressToFirestore() {
  String userId = currentUser!.uid;
  String address = _addressController.text;
  String city = _cityController.text;
  String state = _stateController.text;
  String postalCode = _postalCodeController.text.replaceAll(RegExp(r'\D'), ''); // เพิ่มเฉพาะตัวเลข
  String phone = _phoneController.text.replaceAll(RegExp(r'\D'), ''); // เพิ่มเฉพาะตัวเลข

  if (address.isNotEmpty && city.isNotEmpty && state.isNotEmpty && postalCode.isNotEmpty && phone.isNotEmpty) {
    if (_addressController.text.length > 10) {
      FirebaseService().updateAddressForCurrentUser(userId, address, city, state, postalCode, phone);
    } else {
      VxToast.show(context, msg: "Address should be at least 10 characters long");
    }

    if (_phoneController.text.length < 10) {
      VxToast.show(context, msg: "Phone number should be at least 10 digits long");
    }

    if (_postalCodeController.text.length < 5) {
      VxToast.show(context, msg: "Postal code should be at least 5 digits long");
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
        title: "Edit Address".text.fontFamily(regular).color(fontGreyDark).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ourButton(
          onPress: () {
            saveAddressToFirestore();
          },
          color: primaryApp,
          textColor: whiteColor,
          title: "Save"
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
  children: [
    customTextField(label: "Address", isPass: false, readOnly: false, controller: _addressController),
    customTextField(label: "City", isPass: false, readOnly: false, controller: _cityController),
    customTextField(label: "State", isPass: false, readOnly: false, controller: _stateController),
    customTextField(label: "Postal Code", isPass: false, readOnly: false, controller: _postalCodeController),
    customTextField(label: "Phone", isPass: false, readOnly: false, controller: _phoneController),
    SizedBox(height: 20),
    _currentAddress.isNotEmpty
        ? Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              'Current Address : $_currentAddress',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        : Container(),
  ],
),
      ),
    );
  }
}

