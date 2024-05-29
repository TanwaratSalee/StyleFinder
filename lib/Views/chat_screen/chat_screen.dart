import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/chat_screen/component/sender_bubble.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/chats_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));

    if (DateFormat('yyyyMMdd').format(date) == DateFormat('yyyyMMdd').format(now)) {
      return 'Today';
    } else if (DateFormat('yyyyMMdd').format(date) == DateFormat('yyyyMMdd').format(yesterday)) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          backgroundColor: whiteColor,
          elevation: 4,
          title: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: primaryApp,
                backgroundImage: controller.friendImageUrl.value.isNotEmpty
                    ? NetworkImage(controller.friendImageUrl.value)
                    : null,
                child: controller.friendImageUrl.value.isEmpty
                    ? Icon(
                        Icons.person,
                        color: whiteColor,
                        size: 22,
                      )
                    : null,
              ),
              SizedBox(width: 15),
              Text(
                "${controller.friendName}",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: medium,
                  color: blackColor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Obx(
              () => controller.isLoading.value
                  ? Center(child: loadingIndicator())
                  : Expanded(
                      child: StreamBuilder(
                        stream: FirestoreServices.getChatMessages(controller.chatDocId.toString()),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: loadingIndicator());
                          } else if (snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                "Send a message...",
                                style: TextStyle(color: greyDark),
                              ),
                            );
                          } else {
                            List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
                            Map<String, List<QueryDocumentSnapshot>> groupedMessages = {};

                            for (var message in messages) {
                              String date;
                              try {
                                date = formatDate(message['created_at']);
                              } catch (e) {
                                date = 'Unknown Date'; 
                              }
                              if (!groupedMessages.containsKey(date)) {
                                groupedMessages[date] = [];
                              }
                              groupedMessages[date]!.add(message);
                            }

                            return ListView.builder(
                              itemCount: groupedMessages.length,
                              itemBuilder: (context, index) {
                                String date = groupedMessages.keys.elementAt(index);
                                List<QueryDocumentSnapshot> dayMessages = groupedMessages[date]!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Center(
                                        child: Text(
                                          date,
                                          style: TextStyle(color: greyDark, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    ...dayMessages.map((data) {
                                      return Align(
                                        alignment: data['uid'] == currentUser!.uid
                                            ? Alignment.centerLeft
                                            : Alignment.centerRight,
                                        child: senderBubble(data),
                                      );
                                    }).toList(),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.msgController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: greyLine),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: greyColor),
                      ),
                      hintText: "Type a message...",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.sendMsg(controller.msgController.text);
                    controller.msgController.clear();
                  },
                  icon: const Icon(Icons.send, color: primaryApp),
                ),
              ],
            ).box.padding(const EdgeInsets.all(12)).margin(const EdgeInsets.only(bottom: 10)).height(80).make(),
          ],
        ),
      ),
    );
  }
}
