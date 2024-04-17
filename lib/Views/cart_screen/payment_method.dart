// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/cart_screen/qr_screen.dart';
import 'package:flutter_finalproject/Views/cart_screen/visa_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/home_screen/mainHome.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/consts/styles.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

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
                  child: loadingIndicator(),
                )
              : ourButton(
                  onPress: () async {
                    String selectedPaymentMethod =
                        paymentMethods[controller.paymentIndex.value];
                    if (selectedPaymentMethod == 'QR Promptpay') {
                      print('Selected Payment Method: $selectedPaymentMethod');
                      Get.to(() => const QRScreen());
                    } else if (selectedPaymentMethod == 'Visa') {
                      print('Selected Payment Method: $selectedPaymentMethod');
                      Get.to(() => const VisaCardScreen());
                    } else if (selectedPaymentMethod == 'Cash On Delivery') {
                      print('Selected Payment Method: $selectedPaymentMethod');
                      await controller.placeMyOrder(
                          orderPaymentMethod: selectedPaymentMethod,
                          totalAmount: controller.totalP.value);

                      await controller.clearCart();
                      VxToast.show(context, msg: "Order placed successfully");

                      Get.offAll(() => MainHome());
                    } else {
                      VxToast.show(context,
                          msg: "Selected payment method is not supported yet.");
                    }
                  },
                  color: primaryApp,
                  textColor: whiteColor,
                  title: "Place my order"),
        ),
        appBar: AppBar(
          title: "Choose Payment "
              .text
              .color(greyDark2)
              .fontFamily(regular)
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
                                  ? blackColor.withOpacity(0.4)
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
                                .color(greyColor)
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
