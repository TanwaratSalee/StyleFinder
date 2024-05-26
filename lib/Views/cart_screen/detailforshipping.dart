import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/cart_screen/payment_method.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailForShipping extends StatelessWidget {
  final Map<String, dynamic>? address;
  final List<DocumentSnapshot> cartItems;
  final int totalPrice;

  const DetailForShipping({
    Key? key,
    required this.address,
    required this.cartItems,
    required this.totalPrice,
  }) : super(key: key);

  String formatPhoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'\D'), '');

    if (cleaned.length == 10) {
      final RegExp regExp = RegExp(r'(\d{3})(\d{3})(\d{4})');
      return cleaned.replaceAllMapped(regExp, (Match match) {
        return '(+66) ${match[1]}-${match[2]}-${match[3]}';
      });
    } else if (cleaned.length == 9) {
      final RegExp regExp = RegExp(r'(\d{2})(\d{3})(\d{4})');
      return cleaned.replaceAllMapped(regExp, (Match match) {
        return '(+66) ${match[1]}-${match[2]}-${match[3]}';
      });
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    String formattedPrice = NumberFormat('#,##0', 'en_US').format(totalPrice);

    return Scaffold(
      appBar: AppBar(
        title: Text("Order Detail").text.size(24).fontFamily(semiBold).make(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
        child: SizedBox(
          height: 50,
          child: tapButton(
            onPress: () {
              Get.to(() => const PaymentMethods());
            },
            color: primaryApp,
            textColor: whiteColor,
            title: "Confirm order information",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text("Shipping Address")
                    .text
                    .size(18)
                    .fontFamily(medium)
                    .make(),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    20.widthBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (address != null) ...[
                          Text('${address!['firstname']} ${address!['surname']}')
                              .text
                              .size(14)
                              .fontFamily(medium)
                              .make(),
                          Text('${address!['address']}')
                              .text
                              .size(12)
                              .fontFamily(regular)
                              .make(),
                          Text('${address!['city']}, ${address!['state']} ${address!['postalCode']}')
                              .text
                              .size(12)
                              .fontFamily(regular)
                              .make(),
                          Text('${formatPhoneNumber(address!['phone'])}')
                              .text
                              .size(12)
                              .fontFamily(regular)
                              .make(),
                        ],
                      ],
                    )
                  ],
                )
              ],
            )
                .box
                .white
                .shadowSm
                .padding(EdgeInsets.fromLTRB(22, 0, 22, 10))
                .rounded
                .make(),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Ordered List")
                    .text
                    .size(18)
                    .fontFamily(medium)
                    .make(),
                10.heightBox,
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    String itemPrice =
                        NumberFormat('#,##0', 'en_US').format(item['tprice']);
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'x${item['qty']}',
                            )
                                .text
                                .size(12)
                                .fontFamily(regular)
                                .color(greyDark)
                                .make(),
                            const SizedBox(width: 5),
                            Image.network(item['img'],
                                width: 50, height: 60, fit: BoxFit.cover),
                            const SizedBox(width: 15),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                                    .text
                                    .size(14)
                                    .fontFamily(medium)
                                    .color(blackColor)
                                    .make(),
                                Text(
                                  '$itemPrice Bath',
                                  style: const TextStyle(color: greyDark),
                                ),
                              ],
                            )),
                          ],
                        ).box.padding(EdgeInsets.only(bottom: 5)).make(),
                      ],
                    );
                  },
                ),
                // SizedBox(height: 12),
                Text("Total: $formattedPrice Bath",
                        style: TextStyle(fontSize: 18, fontFamily: regular))
                    .box
                    .padding(EdgeInsets.all(8))
                    .rounded
                    .make(),
              ],
            )
                .box
                .white
                .shadowSm
                .padding(EdgeInsets.fromLTRB(22, 10, 22, 0))
                .rounded
                .make()
          ],
        ),
      ),
    );
  }
}
