import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_finalproject/consts/consts.dart';
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
  var controller = Get.find<CartController>(); // ตัวอย่างการเข้าถึง controller
  String? downloadUri;

  @override
  void initState() {
    super.initState();
    createChargeWithPromptPay();
  }

  createChargeWithPromptPay() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display QR Code'),
        backgroundColor: Colors.white, // สีของ AppBar
      ),
      backgroundColor: Colors.white, // สีพื้นหลังของ Scaffold
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
}
