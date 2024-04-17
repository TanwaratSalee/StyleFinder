import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_finalproject/Views/home_screen/mainHome.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:omise_flutter/omise_flutter.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  var controller = Get.find<CartController>();
  String? downloadUri;

  @override
  void initState() {
    super.initState();
    createChargeWithKbank();
  }

  createChargeWithPromptPay() async {
    String secretKey = 'skey_test_5yzhwpoh5cu85yb4qrr';
    String urlAPI = 'https://api.omise.co/charges';

    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$secretKey:'));

    Map<String, String> headerMap = {};
    headerMap['authorization'] = basicAuth;
    headerMap['Cache-Control'] = 'no-cache';
    headerMap['Content-Type'] = 'application/x-www-form-urlencoded';

    Map<String, dynamic> data = {};
    data['amount'] = controller.totalP.value.toString();
    data['currency'] = 'thb';
    data['source[type]'] = 'promptpay';

    Uri uri = Uri.parse(urlAPI);

    http.Response response = await http.post(
      uri,
      headers: headerMap,
      body: data,
    );

    if (response.statusCode == 200) {
      final resultCharge = jsonDecode(response.body);
      print('Charge created: ${resultCharge['id']}');

      // ตรวจสอบและเข้าถึง download_uri
      downloadUri =
          resultCharge['source']?['scannable_code']?['image']?['download_uri'];
      if (downloadUri != null) {
        setState(() {
          downloadUri =
              resultCharge['source']['scannable_code']['image']['download_uri'];
          print('Dddddddddd: $downloadUri');
        });
      } else {
        print('Download URI not found');
      }
    } else {
      print('Failed to create charge: ${response.body}');
    }
  }

  createChargeWithKbank() async {
    String secretKey = 'skey_test_5yzhwpoh5cu85yb4qrr';
    String urlAPI = 'https://api.omise.co/charges';

    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$secretKey:'));

    Map<String, String> headerMap = {};
    headerMap['authorization'] = basicAuth;
    headerMap['Cache-Control'] = 'no-cache';
    headerMap['Content-Type'] = 'application/x-www-form-urlencoded';

    Map<String, dynamic> data = {};
    data['amount'] = controller.totalP.value.toString();
    data['currency'] = 'thb';
    data['source[type]'] = 'mobile_banking_kbank';
    data['return_uri'] = 'com.example.flutter.finalproject://login-callback';

    Uri uri = Uri.parse(urlAPI);

    http.Response response = await http.post(
      uri,
      headers: headerMap,
      body: data,
    );

      var resultCharge = jsonDecode(response.body);
      print('status Kbank ===> ${resultCharge['status']}');

      await checkStatus(resultCharge['id'], context);
    }

Future<void> checkStatus(String chargeId, BuildContext context) async {
  while (true) {
    await Future.delayed(Duration(seconds: 5)); // ตรวจสอบทุก 5 วินาที

    String secretKey = 'skey_test_5yzhwpoh5cu85yb4qrr';
    String urlAPI = 'https://api.omise.co/charges/$chargeId';

    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$secretKey:'));

    Map<String, String> headerMap = {};
    headerMap['authorization'] = basicAuth;
    headerMap['Cache-Control'] = 'no-cache';
    headerMap['Content-Type'] = 'application/x-www-form-urlencoded';

    Uri uri = Uri.parse(urlAPI);

    http.Response response = await http.get(uri, headers: headerMap);

    var resultCharge = jsonDecode(response.body);
    print('status Kbank ===> ${resultCharge['status']}');

    if (resultCharge['status'] == 'successful') {
      _showSuccessDialog(context);
      break; // หยุดตรวจสอบเมื่อชำระเงินสำเร็จ
    } else if (resultCharge['status'] == 'failed') {
      VxToast.show(context, msg: "failed");
      break; // หยุดตรวจสอบเมื่อชำระเงินไม่สำเร็จ
    } else {
      // หากยังไม่สำเร็จ ทำให้ลูปวนต่อไป
      continue;
    }
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
                '${controller.totalP.value} Bath',
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
      );
    },
  );

  String selectedPaymentMethod = paymentMethods[controller.paymentIndex.value];
  await controller.placeMyOrder(
    orderPaymentMethod: selectedPaymentMethod,
    totalAmount: controller.totalP.value,
  );

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
        title: Text('Display QR Code'),
        backgroundColor: whiteColor, // สีของ AppBar
      ),
      backgroundColor: whiteColor, // สีพื้นหลังของ Scaffold
      body: Center(
        child: Container(
          width: 300, // ความกว้างของสี่เหลี่ยม
          height: 200, // ความสูงของสี่เหลี่ยม
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // สีของเส้นกรอบ
              width: 2.0, // ความหนาของเส้นกรอบ
            ),
          ),
            child: Center(
              child: Text(downloadUri ?? ''),
            ),
        ),
      ),
    );
  }
}
