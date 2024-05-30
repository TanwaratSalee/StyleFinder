import 'package:cloud_firestore/cloud_firestore.dart';
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
        title: "Message"
            .text
            .size(26)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
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
              return "No messages yet!".text.color(greyDark).makeCentered();
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

                          var friendImageUrl = data[index]['friend_image_url'] ?? '';

                          return GestureDetector(
                            onTap: () {
                              Get.to(() => const ChatScreen(), arguments: [
                                data[index]['friend_name'],
                                data[index]['toId']
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
                                  15.widthBox,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        "${data[index]['friend_name']}"
                                            .text
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
                                            style: TextStyle(color: greyDark),
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
