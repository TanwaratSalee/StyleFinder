
// ignore_for_file: file_names

import 'package:flutter_finalproject/Views/cart_screen/payment_method.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info".text.fontFamily(regular).color(fontGreyDark).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ourButton(
          onPress: () {
            if(controller.addressController.text.length > 10) {
              Get.to(()=> const PaymentMethods());
            } else {
              VxToast.show(context, msg: "Please dill the form");
            }
          },
          color: primaryApp,
          textColor: whiteColor,
          title: "Continue"
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(label: "Address", isPass: false, readOnly: false, title: "Address", controller: controller.addressController),
            customTextField(label: "City", isPass: false, readOnly: false, title: "City", controller: controller.cityController),
            customTextField(label: "State", isPass: false, readOnly: false, title: "State", controller: controller.stateController),
            customTextField(label: "Postal Cod", isPass: false, readOnly: false, title: "Postal Cod", controller: controller.postalcodeController),
            customTextField(label: "Phone", isPass: false, readOnly: false, title: "Phone", controller: controller.phoneController),
          ],
        ),
      ),
    );
  }
}