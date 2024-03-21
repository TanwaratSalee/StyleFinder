import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/cart_screen/qr_screen.dart';
import 'package:flutter_finalproject/Views/cart_screen/visa_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/consts/styles.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../home_screen/navigationBar.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();

    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
          height: 70,
          child: controller.placingOrder.value
              ? Center(
                  child: loadingIndcator(), // Make sure this function name matches your implementation
                )
              : ourButton(
                  onPress: () async {
                    String selectedPaymentMethod = paymentMethods[controller.paymentIndex.value];

                    if (selectedPaymentMethod == 'QR Promptly') {
                      // Navigate to QRScreen
                      Get.to(() => QRScreen()); // Make sure this matches your QRScreen class constructor
                    } else if (selectedPaymentMethod == 'Visa') {
                      // Navigate to VisaCardScreen
                      Get.to(() => VisaCardScreen()); // Make sure this matches your VisaCardScreen class constructor
                    } else if (selectedPaymentMethod == 'Cash on Delivery') {
                      // Existing logic for placing an order
                      await controller.placeMyOrder(
                          orderPaymentMethod: selectedPaymentMethod,
                          totalAmount: controller.totalP.value);
                      
                      await controller.clearCart();
                      VxToast.show(context, msg: "Order placed successfully");
                      
                      Get.offAll(() => MainNavigationBar()); // Make sure this matches your MainNavigationBar class constructor
                    } else {
                      VxToast.show(context, msg: "Selected payment method is not supported yet.");
                    }
                  },
                  color: primaryApp,
                  textColor: whiteColor,
                  title: "Place my order"),
        ),
        appBar: AppBar(
          title: "Choose Payment Method"
              .text
              .fontFamily(regular)
              .color(fontGreyDark)
              .make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            () => Column(
              children: List.generate(
                paymentMethodsImg.length,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      controller.changePaymentIndex(index);
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: controller.paymentIndex.value == index
                                ? primaryApp
                                : Colors.transparent,
                            width: 4,
                          )),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.asset(paymentMethodsImg[index],
                              width: double.infinity,
                              height: 120,
                              colorBlendMode:
                                  controller.paymentIndex.value == index
                                      ? BlendMode.darken
                                      : BlendMode.color,
                              color: controller.paymentIndex.value == index
                                  ? Colors.black.withOpacity(0.4)
                                  : Colors.transparent,
                              fit: BoxFit.cover),
                          controller.paymentIndex.value == index
                              ? Transform.scale(
                                  scale: 1.3,
                                  child: Checkbox(
                                    activeColor: primaryApp,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    value: true,
                                    onChanged: (value) {},
                                  ),
                                )
                              : Container(),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: paymentMethods[index]
                                .text
                                .white
                                .fontFamily(bold)
                                .size(16)
                                .make(),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
