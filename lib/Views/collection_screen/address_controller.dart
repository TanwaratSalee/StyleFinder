import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

Future<void> updateAddressForCurrentUser(String userId, String firstname, String surname, String address,
    String city, String state, String postalCode, String phone) async {
  try {
    // ตรวจสอบว่าค่าไม่เป็นค่าว่างเปล่าก่อนที่จะทำการอัปเดต
    if (firstname.isNotEmpty &&
    surname.isNotEmpty &&
      address.isNotEmpty &&
        city.isNotEmpty &&
        state.isNotEmpty &&
        postalCode.isNotEmpty &&
        phone.isNotEmpty) {
      // อ่านข้อมูลที่มีอยู่และตรวจสอบสำหรับการเพิ่ม address
      DocumentSnapshot documentSnapshot =
          await usersCollection.doc(currentUser!.uid).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? userData =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (userData != null) {
          // ตรวจสอบว่ามีข้อมูลใน field 'address' หรือไม่
          if (userData.containsKey('address')) {
            // สร้าง List ของ address ที่มีอยู่แล้ว
            List<dynamic>? addressList = List.from(userData['address']);
            if (addressList == null) {
              addressList = [];
            }
            // เพิ่ม address ลงใน List
            addressList.add({
              'firstname': firstname,
              'surname': surname,
              'address': address,
              'city': city,
              'state': state,
              'postalCode': postalCode,
              'phone': phone,
            });
            // ทำการอัปเดตข้อมูลในฐานข้อมูล
            await usersCollection.doc(currentUser!.uid).update({
              'address': addressList,
            });
          } else {
            // ถ้ายังไม่มี field 'address' ให้เพิ่มข้อมูลลงใน field 'address'
            await usersCollection.doc(currentUser!.uid).update({
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
  String userId = currentUser!.uid;
  String firstname = _firstnameController.text;
  String surname = _surnameController.text;
  String address = _addressController.text;
  String city = _cityController.text;
  String state = _stateController.text;
  String postalCode = _postalCodeController.text.replaceAll(RegExp(r'\D'), '');
  String phone = _phoneController.text.replaceAll(RegExp(r'\D'), '');

  if (firstname.isNotEmpty && surname.isNotEmpty && address.isNotEmpty && city.isNotEmpty && state.isNotEmpty && postalCode.isNotEmpty && phone.isNotEmpty) {
    if (address.length > 10 && phone.length >= 10 && postalCode.length >= 5) {
      try {
        await FirebaseService().updateAddressForCurrentUser(userId, firstname, surname, address, city, state, postalCode, phone);
        VxToast.show(context, msg: "Suscessful save Address");
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
        title:
            "Edit Address".text.fontFamily(regular).color(greyDarkColor).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ourButton(
            onPress: () {
              saveAddressToFirestore();
            },
            color: primaryApp,
            textColor: whiteColor,
            title: "Save"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(
                label: "Firstname",
                isPass: false,
                readOnly: false,
                controller: _firstnameController),
            customTextField(
                label: "Surname",
                isPass: false,
                readOnly: false,
                controller: _surnameController),
            customTextField(
                label: "Address",
                isPass: false,
                readOnly: false,
                controller: _addressController),
            customTextField(
                label: "City",
                isPass: false,
                readOnly: false,
                controller: _cityController),
            customTextField(
                label: "State",
                isPass: false,
                readOnly: false,
                controller: _stateController),
            customTextField(
                label: "Postal Code",
                isPass: false,
                readOnly: false,
                controller: _postalCodeController),
            customTextField(
                label: "Phone",
                isPass: false,
                readOnly: false,
                controller: _phoneController),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
