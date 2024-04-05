import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/home_screen/mainHome.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:omise_flutter/omise_flutter.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Visa Card Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: VisaCardScreen(),
    );
  }
}

class VisaCardScreen extends StatefulWidget {
  const VisaCardScreen({Key? key}) : super(key: key);

  @override
  _VisaCardScreenState createState() => _VisaCardScreenState();
}

class _VisaCardScreenState extends State<VisaCardScreen> {
  var controller = Get.find<CartController>();
  String cardHolderName = 'Card owner\'s name';
  String cardNumber = '1234 5678 9876 5432';

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

      Get.offAll(() => MainHome());
    });
  }

  void _updateCardHolderName(String newName) {
    setState(() {
      cardHolderName = newName.isNotEmpty
          ? newName[0].toUpperCase() + newName.substring(1)
          : newName;
    });
  }

  void _updateCardNumber(String newNumber) {
    setState(() {
      if (newNumber.length <= 4) {
        cardNumber = 'XXXX XXXX XXXX ' + newNumber.padLeft(4, 'X');
      } else {
        String masked = newNumber
            .substring(0, newNumber.length - 4)
            .replaceAll(RegExp(r'\d'), 'X');
        String visibleDigits = newNumber.substring(newNumber.length - 4);
        cardNumber = masked.padLeft(16, 'X') + visibleDigits;
      }

      cardNumber = cardNumber.replaceAllMapped(
          RegExp(r".{4}"), (match) => "${match.group(0)} ");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Visa Card",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Bold',
            color: Colors.grey[900],
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          _buildCardDetail(),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Name',
            onChanged: (newName) {
              setState(() {
                cardHolderName = newName;
              });
            },
          ),
          SizedBox(height: 8),
          _buildTextField(label: 'Card number'),
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: _buildTextField(label: 'Expiry date')),
              SizedBox(width: 8),
              Expanded(child: _buildTextField(label: 'VCC')),
            ],
          ),
          SizedBox(height: 24),
          ElevatedButton(
            child: Text('Confirm'),
            onPressed: () {
              getTokenandSourceTest();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetail() {
    return Card(
      elevation: 4,
      child: Container(
        height: 200,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[300]!, Colors.purple[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('VISA',
                style: TextStyle(
                    color: Colors.white, fontSize: 24, fontFamily: 'Bold')),
            Text(cardNumber,
                style: TextStyle(color: Colors.white, fontSize: 21)),
            Text(cardHolderName,
                style: TextStyle(
                    color: Colors.white, fontSize: 18, fontFamily: 'Regular')),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, Function(String)? onChanged}) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
      onChanged: onChanged,
    );
  }
}
