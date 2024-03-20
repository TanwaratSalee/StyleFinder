
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/cart_screen/payment_method.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';


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
}

class ShippingDetails extends StatefulWidget {
  const ShippingDetails({Key? key}) : super(key: key);

  @override
  _ShippingDetailsState createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    loadCurrentUserAddress(); // โหลดข้อมูลที่อยู่ของผู้ใช้เมื่อวิดเจ็ตถูกสร้าง
  }

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
        }
      }
    } catch (error) {
      print('Failed to load user address: $error');
      setState(() {
        _currentAddress = 'Failed to load user address';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info".text.fontFamily(regular).color(fontGreyDark).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ourButton(
          onPress: () {
            if(controller.addressController.text.length > 10) {
              Get.to(()=> const PaymentMethods());
            } else {
              VxToast.show(context, msg: "Please dill the form");
            }
          },
          color: primaryApp,
          textColor: whiteColor,
          title: "Continue"
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
                Text(_currentAddress ?? 'Loading...',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
            customTextField(label: "Address", isPass: false, readOnly: false, /*title: "Address",*/ controller: controller.addressController),
            customTextField(label: "City", isPass: false, readOnly: false, /*title: "City",*/ controller: controller.cityController),
            customTextField(label: "State", isPass: false, readOnly: false, /*title: "State",*/ controller: controller.stateController),
            customTextField(label: "Postal Cod", isPass: false, readOnly: false, /*title: "Postal Cod",*/ controller: controller.postalcodeController),
            customTextField(label: "Phone", isPass: false, readOnly: false, /*title: "Phone",*/ controller: controller.phoneController),
          ],
        ),
      ),
    );
  }
}