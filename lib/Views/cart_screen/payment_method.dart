import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/cart_screen/creditcard_screen.dart';
import 'package:flutter_finalproject/Views/cart_screen/promptpay_screen.dart';
import 'package:flutter_finalproject/Views/home_screen/mainHome.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart'; // Make sure to have this import if using GetX for navigation and state management
import 'package:velocity_x/velocity_x.dart'; // For VxToast

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  String? selectedMethod;
  String? selectedBank;

  List<String> textPaymentMethods = [
    'Credit Card',
    'Cash on Delivery',
    'Mobile Banking'
  ];
  List<String> textBank = ['Kbank', 'SCB', 'BB', 'KTB', 'BAY'];

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Select Payment Method')
            .text
            .size(24)
            .fontFamily(medium)
            .color(greyDark2)
            .make(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
                textPaymentMethods.length,
                (index) => InkWell(
                      onTap: () {
                        setState(() {
                          selectedMethod = textPaymentMethods[index];
                          selectedBank =
                              null; // Reset bank selection on payment method change
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          color: selectedMethod == textPaymentMethods[index]
                              ? thinPrimaryApp
                              : whiteColor,
                          border: Border.all(
                            color: selectedMethod == textPaymentMethods[index]
                                ? Theme.of(context).primaryColor
                                : thinGrey01,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(paymentIcons[index]),
                            radius: 20,
                          ),
                          title: Text(textPaymentMethods[index]),
                          trailing: Icon(
                            selectedMethod == textPaymentMethods[index]
                                ? Icons.check_circle
                                : null,
                            color: selectedMethod == textPaymentMethods[index]
                                ? Theme.of(context).primaryColor
                                : null,
                          ),
                        ),
                      ),
                    )),
            if (selectedMethod == 'Mobile Banking')
              ...List.generate(
                  imgBank.length,
                  (index) => InkWell(
                        onTap: () {
                          setState(() {
                            selectedBank = textBank[index];
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(imgBank[index]),
                              radius: 20,
                            ),
                            title: Text(textBank[index]),
                            trailing: Icon(
                              selectedBank == textBank[index]
                                  ? Icons.check_circle
                                  : null,
                              color: selectedBank == textBank[index]
                                  ? Theme.of(context).primaryColor
                                  : null,
                            ),
                          ),
                        )
                            .box
                            .margin(EdgeInsets.symmetric(horizontal: 12))
                            .border(color: thinGrey01)
                            .make(),
                      )),
          ],
        ).box.padding(EdgeInsets.symmetric(horizontal: 24)).rounded.make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: Obx(() => controller.placingOrder.value
            ? Center(child: CircularProgressIndicator())
            : ourButton(
                onPress: () async {
                  print(
                      'Selected Payment Method: $selectedMethod'); // Debugging output

                  if (selectedMethod == 'Credit Card') {
                    Get.to(() => const CreditCardScreen());
                  } else if (selectedMethod == 'Cash on Delivery') {
                    // Make sure this matches exactly with what's being logged
                    print(
                        'Processing Cash on Delivery'); // Confirming correct branch
                    await controller.placeMyOrder(
                        orderPaymentMethod: selectedMethod,
                        totalAmount: controller.totalP.value);
                    await controller.clearCart();
                    VxToast.show(context, msg: "Order placed successfully");
                    Get.offAll(() => MainHome());
                  } else if (selectedMethod == 'Mobile Banking') {
                    if (selectedBank != null) {
                      Get.to(() => const PromptpayScreen());
                    } else {
                      VxToast.show(context, msg: "Please select a bank first.");
                    }
                  } else {
                    VxToast.show(context,
                        msg: "Selected payment method is not supported yet.");
                  }
                },
                color: primaryApp,
                textColor: whiteColor,
                title: "Place my order")),
      ),
    );
  }
}
