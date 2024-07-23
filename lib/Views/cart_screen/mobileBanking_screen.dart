import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/home_screen/mainHome.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MobileBankingScreenextends extends StatefulWidget {
  const MobileBankingScreenextends({Key? key}) : super(key: key);

  @override
  _MobileBankingScreenextendsState createState() =>
      _MobileBankingScreenextendsState();
}

class _MobileBankingScreenextendsState
    extends State<MobileBankingScreenextends> {
  final controller = Get.find<CartController>();
  String? downloadUri;

  @override
  void initState() {
    super.initState();
    createChargeWithMobileBanking();
  }

  Future<void> createChargeWithMobileBanking() async {
    const String secretKey = 'skey_test_5yzhwpoh5cu85yb4qrr';
    const String urlAPI = 'https://api.omise.co/charges';
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$secretKey:'));

    final Map<String, String> headerMap = {
      'authorization': basicAuth,
      'Cache-Control': 'no-cache',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final int amountInSmallestUnit = (controller.totalP.value * 100).toInt();

    final Map<String, dynamic> data = {
      'amount': amountInSmallestUnit.toString(),
      'currency': 'thb',
      'return_uri': 'myapp://payments',
      'source[type]': 'mobile_banking_kbank',
    };

    final Uri uri = Uri.parse(urlAPI);

    final http.Response response =
        await http.post(uri, headers: headerMap, body: data);

    if (response.statusCode == 200) {
      final resultCharge = jsonDecode(response.body);
      print('Charge created: ${resultCharge['id']}');

      Timer.periodic(Duration(seconds: 3), (Timer timer) async {
        final http.Response statusResponse = await http.get(
          Uri.parse('https://api.omise.co/charges/${resultCharge['id']}'),
          headers: headerMap,
        );

        if (statusResponse.statusCode == 200) {
          final updatedResultCharge = jsonDecode(statusResponse.body);

          if (updatedResultCharge['status'] == 'successful') {
            timer.cancel();
            _showSuccessDialog(context);
          } else if (updatedResultCharge['status'] == 'failed' ||
              updatedResultCharge['status'] == 'expired') {
            timer.cancel();
            print('Transaction failed or expired');
          }
        } else {
          print('Failed to fetch charge status: ${statusResponse.body}');
        }
      });
    } else {
      print('Failed to create charge: ${response.body}');
    }
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: whiteColor,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(height: 50),
                Image.asset(
                  imgSuccessful,
                  height: 60,
                ),
                SizedBox(height: 40),
                Text(
                  'Payment was successful!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  '${controller.totalP.value} Bath',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: bold,
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    String selectedPaymentMethod =
        textpaymentMethods[controller.paymentIndex.value];
    await controller.placeMyOrder(
        orderPaymentMethod: selectedPaymentMethod,
        totalAmount: controller.totalP.value.toDouble());

    await controller.clearCart();
    VxToast.show(context, msg: "Order placed successfully");
    await Future.delayed(Duration(seconds: 4));
    Get.find<CartController>().totalP.refresh();
    Get.offAll(() => MainHome());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Banking')
            .text
            .size(26)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imgPaymentSuccful,
              height: 300,
            ),
            SizedBox(height: 20),
            Text('Loading', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text('Please wait while we are checking the transaction'),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
