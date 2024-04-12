import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:flutter_finalproject/Views/home_screen/home_screen.dart';
import 'package:flutter_finalproject/Views/home_screen/mainHome.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:omise_flutter/omise_flutter.dart';
import 'package:flutter/material.dart';

class VisaCardScreen extends StatefulWidget {
  const VisaCardScreen({Key? key}) : super(key: key);

  @override
  _VisaCardScreenState createState() => _VisaCardScreenState();
}

class _VisaCardScreenState extends State<VisaCardScreen> {
  var controller = Get.find<CartController>();
  String cardHolderName = 'Card owner\'s name';
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController mmController = TextEditingController();
  TextEditingController yyController = TextEditingController();

  String cardNumberMasked = '';

  @override
  void initState() {
    super.initState();
    cardNumberController.addListener(updateCardNumberMasked);
  }

  @override
  void dispose() {
    cardNumberController.removeListener(updateCardNumberMasked);
    cardNumberController.dispose();
    super.dispose();
  }

  void updateCardNumberMasked() {
    String newNumber = cardNumberController.text;
    setState(() {
      if (newNumber.length > 12) {
        // ถ้าหมายเลขที่ป้อนมีความยาวมากกว่า 12 ตัวอักษร
        String visibleDigits =
            newNumber.substring(0, 12); // เก็บเฉพาะ 12 ตัวอักษรแรก
        cardNumberMasked = visibleDigits +
            'X' * (newNumber.length - 12); // เติม 'X' สำหรับตัวเลขที่เหลือ
      } else {
        // ถ้าหมายเลขที่ป้อนมีความยาวน้อยกว่าหรือเท่ากับ 12 ตัวอักษร
        cardNumberMasked = newNumber;
      }

      // จัดรูปแบบหมายเลขบัตรให้มีช่องว่างทุก ๆ 4 ตัวอักษร เพื่อความสะดวกในการอ่าน
      cardNumberMasked = cardNumberMasked
          .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ")
          .trim(); // ตัดช่องว่างที่เหลือท้ายสุดออก
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          "Card Detail",
          style: TextStyle(
            fontSize: 25,
            fontFamily: bold,
            color: Colors.grey[900],
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          _buildCardDetail(),
          SizedBox(height: 20),
          _buildTextField(
            label: 'Name',
            onChanged: _updateCardHolderName,
          ),
          SizedBox(height: 10),
          _buildCardNumberTextField(),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextFormField(
                    controller: mmController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'MM',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    controller: yyController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'YY',
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(child: _buildTextField(label: 'VCC')),
            ],
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ourButton(
                onPress: () {
                  getTokenandSourceTest();
                  _showCustomDialog(context);
                },
                color: primaryApp,
                textColor: whiteColor,
                title: "Comfirm"),
          )
        ],
      ),
    );
  }

  Widget _buildCardDetail() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: 240,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage('assets/images/card.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Text('VISA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: black,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(128, 0, 0, 0),
                      ),
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(cardNumberMasked,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(128, 0, 0, 0),
                      ),
                    ],
                  )),
            ),
            Text(cardHolderName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: regular,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(128, 0, 0, 0),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    Function(String)? onChanged,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: label == 'Card number' ? cardNumberController : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelText: label,
        fillColor: Color.fromARGB(255, 245, 248, 253),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: greyColor, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: suffixIcon,
      ),
      style: TextStyle(),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(
            RegExp(r'[0-9]')), // กำหนดให้กรอกได้เฉพาะตัวเลข
        LengthLimitingTextInputFormatter(16), // กำหนดความยาวสูงสุดของข้อความ
      ],
      onChanged: onChanged != null ? onChanged as void Function(String)? : null,
      maxLines: 1,
      minLines: 1,
    );
  }

  Widget _buildCardNumberTextField() {
    String determineImageAsset() {
      if (cardNumberMasked.startsWith('5')) {
        return 'assets/images/Mastercard-Logo.png';
      } else if (cardNumberMasked.startsWith('4')) {
        return 'assets/images/Visa.png';
      } else {
        return '';
      }
    }

    final String imageAssetPath = determineImageAsset();

    final Widget? suffixIconWidget = imageAssetPath.isNotEmpty
        ? Image.asset(imageAssetPath, width: 24, height: 24)
        : null;

    return SizedBox(
      height: 50,
      child: _buildTextField(
        label: 'Card number',
        suffixIcon: suffixIconWidget,
      ),
    );
  }

  void _updateCardHolderName(String newName) {
    setState(() {
      cardHolderName = newName.isNotEmpty
          ? newName[0].toUpperCase() + newName.substring(1)
          : newName;
    });
  }

  getTokenandSourceTest() async {
    OmiseFlutter omise = OmiseFlutter('pkey_test_5yzhwpn9nih3syz8e2v');
    await omise.token
        .create("John Doe", "4111111111140011", "12", "2026", "123")
        .then((value) async {
      String token = value.id.toString();
      print(token);

      String secreKey = 'skey_test_5yzhwpoh5cu85yb4qrr';
      String urlAPI = 'https://api.omise.co/charges';
      String basicAuth = 'Basic ' + base64Encode(utf8.encode(secreKey + ":"));

      Map<String, String> headerMap = {};
      headerMap['authorization'] = basicAuth;
      headerMap['Cache-Control'] = 'no-cache';
      headerMap['Content-Type'] = 'application/x-www-form-urlencoded';

      Map<String, dynamic> data = {};
      data['amount'] = controller.totalP.value.toString();
      data['currency'] = 'thb';
      data['card'] = token;

      print(controller.totalP.value.toString());

      Uri uri = Uri.parse(urlAPI);

      http.Response response = await http.post(
        uri,
        headers: headerMap,
        body: data,
      );

      var resultCharge = jsonDecode(response.body);
      print('status ของการตัดบัตร ===> ${resultCharge['status']}');

      if (resultCharge['status'] == 'successful') {
        _showSuccessDialog();
      } else if (resultCharge['status'] == 'failed') {
        VxToast.show(context, msg: "Wrong your card or informaton");
      } else {
        VxToast.show(context, msg: "Wrong your card or informaton");
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment completed'),
          content: Text('Your payment has been completed.'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด dialog
              },
            ),
          ],
        );
      },
    ).then((_) async {
      String selectedPaymentMethod =
          paymentMethods[controller.paymentIndex.value];
      await controller.placeMyOrder(
        orderPaymentMethod: selectedPaymentMethod,
        totalAmount: controller.totalP.value,
      );
      // Get.to(() => CartScreen());
    });
  }
}

// Future<void> _showCustomDialog(BuildContext context) async {
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         // title: Text(
//         //   'Complete!',
//         //   textAlign: TextAlign.center, // ข้อความอยู่ตรงกลาง
//         //   style: TextStyle(
//         //     fontWeight: FontWeight.bold, // ทำให้ตัวหนา
//         //   ),
//         // ),
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: <Widget>[
//               SizedBox(
//                 height: 50,
//               ),
//               Image.asset('assets/images/Finishpay.PNG'),
//               SizedBox(
//                 height: 40,
//               ),
//               Text(
//                 'Payment was successful!',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 '1,400,000 Bath',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: Text('OK'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//         content: Container(
//           padding: EdgeInsets.all(20.0), // กำหนดขอบรอบของข้อความ
//           child: Text('Your message here'), // เพิ่มข้อความที่ต้องการแสดงในกรอบ
//         ),
//       );
//     },
//   );
// }
Future<void> _showCustomDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: whiteColor,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              SizedBox(height: 50),
              Image.asset('assets/images/Finishpay.PNG'),
              SizedBox(height: 40),
              Text(
                'Payment was successful!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 15),
              Text(
                '1,400,000 Bath',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => MainHome());
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainHome()),
                );
              },
              child: Text(
                ' Back to home ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(primaryApp),
              ),
            ),
          ),
        ],
      );
    },
  );
}



// class OurButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final Widget child;

//   const OurButton({
//     Key? key,
//     required this.onPressed,
//     required this.child,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.all<Color>(
//           Colors.blue,
//         ),
//       ),
//       onPressed: onPressed,
//       child: child,
//     );
//   }
// }
