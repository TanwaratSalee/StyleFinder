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

                          var docData =
                              data[index].data() as Map<String, dynamic>;

                          var friendImageUrl =
                              docData['friend_image_url'] ?? '';
                          var friendName = docData['friend_name'] ?? 'Unknown';
                          var lastMsg = docData['last_msg'] ?? '';
                          var toId = docData['toId'] ?? '';

                          return GestureDetector(
                            onTap: () {
                              print('p_seller: $friendName');
                              print('vendor_id: $toId');
                              Get.to(() => const ChatScreen(),
                                  arguments: [friendName, toId]);
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
                                    backgroundImage: friendImageUrl.isNotEmpty
                                        ? NetworkImage(friendImageUrl)
                                        : null,
                                    child: friendImageUrl.isEmpty
                                        ? Icon(
                                            Icons.person,
                                            color: whiteColor,
                                            size: 27,
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          friendName,
                                          style: TextStyle(
                                            fontFamily: medium,
                                            fontSize: 16,
                                            color: blackColor,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        SizedBox(
                                          width: 200,
                                          height: 20,
                                          child: Text(
                                            lastMsg,
                                            style: TextStyle(
                                              color: greyDark,
                                              fontFamily: regular,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(color: greyDark),
                                  ),
                                ],
                              ),
                            ),
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
