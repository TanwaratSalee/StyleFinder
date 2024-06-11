import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/cart_screen/shipping_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter/services.dart';


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
          VxToast.show(context, msg: "Successful save Address");
          Navigator.pop(context); // Pop back to AddressScreen
        } catch (e) {
          VxToast.show(context, msg: "Error saving address: ${e.toString()}");
        }
      } else {
        if (address.length <= 10) {
          VxToast.show(context,
              msg: "Address should be at least 10 characters long");
        }
        if (phone.length < 10) {
          VxToast.show(context,
              msg: "Phone number should be at least 10 digits long");
        }
        if (postalCode.length < 5) {
          VxToast.show(context,
              msg: "Postal code should be at least 5 digits long");
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
        title: "Add Address"
            .text
            .size(26)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
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
                  controller: _postalCodeController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
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


class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;

    // สตริงที่ได้จากการลบตัวอักษรทั้งหมดที่ไม่ใช่ตัวเลขออก
    final digitsOnly = newText.replaceAll(RegExp(r'\D'), '');

    // 3 หรือ 6 (i == 3 หรือ i == 6), จะเพิ่มขีดกลาง (-) 
    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 3 || i == 6) {
        formatted += '-';
      }
      formatted += digitsOnly[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
