import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_finalproject/Views/home_screen/mainHome.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:omise_flutter/omise_flutter.dart';

class CreditCardScreen extends StatefulWidget {
  const CreditCardScreen({Key? key}) : super(key: key);

  @override
  _CreditCardScreenState createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  var controller = Get.find<CartController>();
  String cardHolderName = 'Card owner\'s name';
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController mmController = TextEditingController();
  TextEditingController yyController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cvcController = TextEditingController();

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
        String visibleDigits = newNumber.substring(0, 12);
        cardNumberMasked = visibleDigits + 'X' * (newNumber.length - 12);
      } else {
        cardNumberMasked = newNumber;
      }

      cardNumberMasked = cardNumberMasked
          .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ")
          .trim(); // ตัดช่องว่างที่เหลือท้ายสุดออก
    });
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
                    color: primaryApp,
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

  Widget _buildNameTextField() {
    return _buildTextField(
      label: 'Name',
      controller: nameController,
      textColor: greyColor,
      onChanged: _updateCardHolderName,
    );
  }

  Widget _buildCardNumberTextField() {
    String determineImageAsset() {
      if (cardNumberMasked.startsWith('5')) {
        return imgmastercard;
      } else if (cardNumberMasked.startsWith('4')) {
        return imgvisacard;
      } else {
        return '';
      }
    }

    final String imageAssetPath = determineImageAsset();

    final Widget? suffixIconWidget = imageAssetPath.isNotEmpty
        ? Image.asset(imageAssetPath, width: 24, height: 24)
        : null;

    return _buildTextField(
      label: 'Card number',
      controller: cardNumberController,
      textColor: greyColor,
      suffixIcon: suffixIconWidget,
    );
  }

  Widget _buildVCCTextField() {
    return _buildTextField(
      label: 'VCC',
      controller: cvcController,
      textColor: greyColor,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(3),
      ],
      keyboardType: TextInputType.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          "Card Detail",
        ).text.size(26).fontFamily(semiBold).color(blackColor).make(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
        child: SizedBox(
          height: 50,
          child: tapButton(
            onPress: () {
              getTokenandSourceTest();
            },
            color: primaryApp,
            textColor: whiteColor,
            title: "Confirm",
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(18),
        children: <Widget>[
          _buildCardDetail(),
          SizedBox(height: 15),
          _buildNameTextField(),
          SizedBox(height: 15),
          _buildCardNumberTextField(),
          SizedBox(height: 15),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildTextField(
                  label: 'MM',
                  controller: mmController,
                  textColor: greyColor,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(2),
                  ],
                  keyboardType: TextInputType.number,
                ),
              ),
              15.widthBox,
              Expanded(
                child: _buildTextField(
                  label: 'YY',
                  controller: yyController,
                  textColor: greyColor,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(4),
                  ],
                  keyboardType: TextInputType.number,
                ),
              ),
              15.widthBox,
              Expanded(child: _buildVCCTextField()),
            ],
          ),
          SizedBox(height: 24),
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
            image: AssetImage(/* imgbgVisa */ imgbgVisa1),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Text('',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 24,
                    fontFamily: bold,
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
                    color: whiteColor,
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
                  color: whiteColor,
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
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    Function(String)? onChanged,
    Color textColor = blackColor,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: greyLine),
        ),
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        fillColor: whiteColor,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: greyColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: suffixIcon,
      ),
      style: TextStyle(color: textColor),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      onChanged: onChanged,
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
    String name = nameController.text;
    String cardNumber = cardNumberController.text
        .replaceAll(' ', ''); // ลบช่องว่างออกจากหมายเลขบัตร
    String expMonth = mmController.text;
    String expYear = yyController.text;
    String cvc = cvcController.text;

    OmiseFlutter omise = OmiseFlutter('pkey_test_5yzhwpn9nih3syz8e2v');
    await omise.token
        .create(name, cardNumber, expMonth, expYear, cvc)
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
        _showSuccessDialog(context);
      } else if (resultCharge['status'] == 'failed') {
        VxToast.show(context, msg: "Wrong your card or informaton");
      } else {
        VxToast.show(context, msg: "Wrong your card or informaton");
      }
    });
  }
}
