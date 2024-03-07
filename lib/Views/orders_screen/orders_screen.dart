import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/orders_screen/orders_details.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Order".text.color(fontGreyDark).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getAllOrders(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndcator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return "No orders yet!".text.color(fontGreyDark).makeCentered();
            } else {
              var data = snapshot.data!.docs;

              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: "${index + 1}"
                          .text
                          .fontFamily(bold)
                          .color(fontBlack)
                          .xl
                          .make(),
                      title: data[index]['order_code']
                          .toString()
                          .text
                          .color(primaryApp)
                          .fontFamily(semibold)
                          .make(),
                      // subtitle: (data[index]['total_amount'] as num?)?.numCurrency.text.fontFamily(bold).make() ?? 'No amount'.text.make(),
                      subtitle: data[index]['total_amount']
                          .toString()
                          .numCurrency
                          .text
                          .fontFamily(bold)
                          .make(),
                      trailing: IconButton(
                          onPressed: () {
                            Get.to(() => OrdersDetails(data: data[index],));
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: fontGreyDark,
                          )),
                    );
                  });
            }
          }),
    );
  }
}
