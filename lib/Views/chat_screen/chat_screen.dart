import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/chat_screen/component/sender_bubble.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/chats_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    ScrollController scrollController = ScrollController();
    FocusNode focusNode = FocusNode();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          }
        });
      }
    });

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
                    ? loadingIndicator()
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
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Obx(
                  () => controller.isLoading.value
                      ? Center(child: loadingIndicator())
                      : StreamBuilder(
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
                                  var data = message.data() as Map<String, dynamic>;
                                  if (data['created_on'] != null) {
                                    date = formatDate(data['created_on'] as Timestamp);
                                  } else {
                                    date = 'Unknown Date';
                                  }
                                } catch (e) {
                                  date = 'Unknown Date'; 
                                }
                                if (!groupedMessages.containsKey(date)) {
                                  groupedMessages[date] = [];
                                }
                                groupedMessages[date]!.add(message);
                              }

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (scrollController.hasClients) {
                                  scrollController.jumpTo(scrollController.position.maxScrollExtent);
                                }
                              });

                              return ListView.builder(
                                controller: scrollController,
                                itemCount: groupedMessages.length,
                                itemBuilder: (context, index) {
                                  String date = groupedMessages.keys.elementAt(index);
                                  List<QueryDocumentSnapshot> dayMessages = groupedMessages[date]!;

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        child: Center(
                                          child: Text(
                                            date,
                                            style: TextStyle(color: greyDark, fontFamily: medium),
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
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.msgController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: greyLine),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: greyColor),
                      ),
                      hintText: "Type a message...",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.sendMsg(controller.msgController.text);
                    controller.msgController.clear();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (scrollController.hasClients) {
                        scrollController.jumpTo(scrollController.position.maxScrollExtent);
                      }
                    });
                  },
                  icon: const Icon(Icons.send, color: primaryApp),
                ),
              ],
            ).box.border(color: greyLine).padding(const EdgeInsets.all(12)).height(80).make(),
          ],
        ),
      ),
    );
  }
}
