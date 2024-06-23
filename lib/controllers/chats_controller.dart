import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/news_controller.dart';

class ChatsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getChatId();
    listenToFriendDetails();
  }

  var chats = firestore.collection(chatsCollection);

  var friendName = ''.obs;
  var friendId = Get.arguments[1];
  var friendImageUrl = ''.obs;

  var senderName = Get.find<NewsController>().username;
  var currentId = currentUser!.uid;
  var currentUserImageUrl = ''.obs;

  var msgController = TextEditingController();

  dynamic chatDocId;

  var isLoading = false.obs;

  void getChatId() async {
    isLoading(true);

    // Fetch current user's imageUrl from vendors collection
    await firestore
        .collection(vendorsCollection)
        .doc(currentId)
        .get()
        .then((doc) {
      if (doc.exists) {
        currentUserImageUrl.value = doc['imageUrl'] ?? '';
      }
    });

    // Check if a chat already exists between the two users
    await chats
        .where('users', isEqualTo: {friendId: null, currentId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
            chatDocId = snapshot.docs.single.id;
          } else {
            chats.add({
              'created_on': FieldValue.serverTimestamp(),
              'user_id': currentId,
              'last_msg': '',
              'vendor_id': friendId,
              'users': {friendId: null, currentId: null},
            }).then((value) {
              chatDocId = value.id;
            });
          }
        });

    isLoading(false);
  }

  void listenToFriendDetails() {
    firestore
        .collection(vendorsCollection)
        .doc(friendId)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        friendName.value = doc['name'] ?? '';
        friendImageUrl.value = doc['imageUrl'] ?? '';
      }
    });
  }

  void sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
      });

      chats.doc(chatDocId).collection(messagesCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });
    }
  }
}
