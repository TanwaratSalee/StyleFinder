import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/chat_screen/chat_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  Future<Map<String, String>> getVendorDetails(String vendorId) async {
    if (vendorId.isEmpty) {
      debugPrint('Error: vendorId is empty.');
      return {'name': 'Unknown Vendor', 'imageUrl': ''};
    }

    try {
      var vendorSnapshot = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .get();
      if (vendorSnapshot.exists) {
        var vendorData = vendorSnapshot.data() as Map<String, dynamic>?;
        return {
          'name': vendorData?['name'] ?? 'Unknown Vendor',
          'imageUrl': vendorData?['imageUrl'] ?? ''
        };
      } else {
        return {'name': 'Unknown Vendor', 'imageUrl': ''};
      }
    } catch (e) {
      debugPrint('Error getting vendor details: $e');
      return {'name': 'Unknown Vendor', 'imageUrl': ''};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          "Message",
          style: TextStyle(
            fontSize: 26,
            fontFamily: semiBold,
            color: blackColor,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getAllMessages(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No messages yet!",
                  style: TextStyle(
                    color: greyDark,
                  ),
                ),
              );
            } else {
              var data = snapshot.data!.docs;

              // Sort data based on 'created_on' timestamp in descending order
              data.sort((a, b) {
                var aTimestamp = a['created_on'] as Timestamp?;
                var bTimestamp = b['created_on'] as Timestamp?;
                var aDate =
                    aTimestamp != null ? aTimestamp.toDate() : DateTime.now();
                var bDate =
                    bTimestamp != null ? bTimestamp.toDate() : DateTime.now();
                return bDate.compareTo(aDate);
              });

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var timestamp =
                              data[index]['created_on'] as Timestamp?;
                          var date = timestamp != null
                              ? timestamp.toDate()
                              : DateTime.now();
                          var now = DateTime.now();
                          var formattedDate = '';

                          if (now.difference(date).inHours < 24) {
                            formattedDate = DateFormat('HH:mm').format(date);
                          } else {
                            formattedDate =
                                DateFormat('dd/MM/yyyy').format(date);
                          }

                          var vendorId = data[index]['vendor_id'] ?? '';
                          debugPrint('vendorId: $vendorId');

                          return FutureBuilder<Map<String, String>>(
                            future: getVendorDetails(vendorId),
                            builder: (context, vendorSnapshot) {
                              if (vendorSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (vendorSnapshot.hasError) {
                                return Text('Error: ${vendorSnapshot.error}');
                              } else if (!vendorSnapshot.hasData ||
                                  vendorSnapshot.data!['name']!.isEmpty) {
                                return Text('Unknown Vendor');
                              }

                              var vendorName = vendorSnapshot.data!['name'] ??
                                  'Unknown Vendor';
                              var vendorImageUrl =
                                  vendorSnapshot.data!['imageUrl'] ?? '';

                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => const ChatScreen(), arguments: [
                                    vendorId,
                                    data[index]['vendor_id']
                                  ]);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 8),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: greyThin,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 27,
                                        backgroundColor: primaryApp,
                                        backgroundImage:
                                            vendorImageUrl.isNotEmpty
                                                ? NetworkImage(vendorImageUrl)
                                                : null,
                                        child: vendorImageUrl.isEmpty
                                            ? Icon(
                                                Icons.person,
                                                color: whiteColor,
                                                size: 27,
                                              )
                                            : null,
                                      )
                                          .box
                                          .border(color: greyLine)
                                          .roundedFull
                                          .make(),
                                      15.widthBox,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            vendorName.text
                                                .fontFamily(medium)
                                                .size(16)
                                                .color(blackColor)
                                                .make(),
                                            5.heightBox,
                                            SizedBox(
                                              width: 250,
                                              height: 20,
                                              child: Text(
                                                "${data[index]['last_msg']}",
                                                style:
                                                    TextStyle(color: greyDark),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              )
                                                  .text
                                                  .fontFamily(regular)
                                                  .size(14)
                                                  .color(greyColor)
                                                  .make(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        formattedDate,
                                        style: TextStyle(color: greyDark),
                                      ),
                                    ],
                                  ).box.make(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
