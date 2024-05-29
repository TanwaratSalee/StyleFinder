import 'package:flutter_finalproject/Views/cart_screen/creditcard_screen.dart';
import 'package:flutter_finalproject/Views/cart_screen/mobileBanking_screen.dart';
import 'package:flutter_finalproject/Views/home_screen/mainHome.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';

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
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text('Select Payment Method')
           .text
            .size(28)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 28),
          child: Column(
            children: [
              ...List.generate(
                  textPaymentMethods.length,
                  (index) => InkWell(
                        onTap: () {
                          setState(() {
                            selectedMethod = textPaymentMethods[index];
                            selectedBank = null;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(8,12,8,0),
                          decoration: BoxDecoration(
                            color: selectedMethod == textPaymentMethods[index]
                                ? thinPrimaryApp
                                : whiteColor,
                            border: Border.all(
                              color: selectedMethod == textPaymentMethods[index]
                                  ? Theme.of(context).primaryColor
                                  : greyLine,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(paymentIcons[index]),
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
                            // margin: EdgeInsets.symmetric(vertical: 2),
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
                              .margin(EdgeInsets.symmetric(horizontal: 24))
                              .border(color: greyLine)
                              .make(),
                        )),
            ],
          ).box.padding(EdgeInsets.symmetric(horizontal: 12)).rounded.make(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
        child: SizedBox(
          height: 50,
          child: Obx(() => controller.placingOrder.value
              ? Center(child: CircularProgressIndicator())
              : tapButton(
                  onPress: () async {
                    print('Selected Payment Method: $selectedMethod');

                    if (selectedMethod == 'Credit Card') {
                      Get.to(() => const CreditCardScreen());
                    } else if (selectedMethod == 'Cash on Delivery') {
                      print('Processing Cash on Delivery');
                      await controller.placeMyOrder(
                          orderPaymentMethod: selectedMethod,
                          totalAmount: controller.totalP.value);
                      await controller.clearCart();
                      VxToast.show(context, msg: "Order placed successfully");
                      Get.offAll(() => MainHome());
                    } else if (selectedMethod == 'Mobile Banking') {
                      if (selectedBank != null) {
                        Get.to(() => const MobileBankingScreenextends());
                      } else {
                        VxToast.show(context,
                            msg: "Please select a bank first.");
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
      ),
    );
  }
}
