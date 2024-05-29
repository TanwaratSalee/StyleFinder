import 'dart:async';
import 'dart:convert'; // แก้ไขบรรทัดนี้
import 'dart:io';

import 'package:flutter_finalproject/Views/home_screen/mainHome.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PromptpayScreen extends StatefulWidget {
  const PromptpayScreen({Key? key}) : super(key: key);

  @override
  _PromptpayScreenState createState() => _PromptpayScreenState();
}

class _PromptpayScreenState extends State<PromptpayScreen> {
  var controller = Get.find<CartController>();
  String? downloadUri;

  @override
  void initState() {
    super.initState();
    createChargeWithMobileBanking();
  }

/*   createChargeWithPromptPay() async {
    String secretKey = 'skey_test_5yzhwpoh5cu85yb4qrr'; // ใช้ Secret Key ของคุณ
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
  } */

  createChargeWithMobileBanking() async {
    String secretKey = 'skey_test_5yzhwpoh5cu85yb4qrr'; // ใช้ Secret Key ของคุณ
    String urlAPI = 'https://api.omise.co/charges';

    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$secretKey:'));

    Map<String, String> headerMap = {};
    headerMap['authorization'] = basicAuth;
    headerMap['Cache-Control'] = 'no-cache';
    headerMap['Content-Type'] = 'application/x-www-form-urlencoded';

    Map<String, dynamic> data = {};
    data['amount'] = controller.totalP.value.toString();
    data['currency'] = 'thb';
    data['return_uri'] = 'myapp://payments';
    data['source[type]'] = 'mobile_banking_kbank';

    Uri uri = Uri.parse(urlAPI);

    http.Response response = await http.post(
      uri,
      headers: headerMap,
      body: data,
    );

  if (response.statusCode == 200) {
    final resultCharge = jsonDecode(response.body);
    print('Charge created: ${resultCharge['id']}');
    
    Timer.periodic(Duration(seconds: 3), (Timer timer) async {
      http.Response statusResponse = await http.get(
        Uri.parse('https://api.omise.co/charges/${resultCharge['id']}'),
        headers: headerMap,
      );

      if (statusResponse.statusCode == 200) {
        final updatedResultCharge = jsonDecode(statusResponse.body);

        if (updatedResultCharge['status'] == 'successful') {
          timer.cancel();
          _showSuccessDialog(context);

        } else if (updatedResultCharge['status'] == 'failed' || updatedResultCharge['status'] == 'expired') {
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

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> banks = [
      {'name': 'KBANK', 'icon': Icons.account_balance},
      {'name': 'SCB', 'icon': Icons.account_balance_wallet},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Display QR Code').text
            .size(28)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
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
          //   child: Center(
          //     child: downloadUri != null
          //         ? Image.network(
          //             downloadUri!,
          //             width: 150,
          //             height: 150,
          //           )
          //         : Text('No image available'),
          //   ),
        ),
      ),
    );
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
              Image.asset(imgSuccessful),
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

  String selectedPaymentMethod = textpaymentMethods[controller.paymentIndex.value];
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
}