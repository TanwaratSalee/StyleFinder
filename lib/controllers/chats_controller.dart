import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/news_controller.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController {
  @override
  void onInit() {
    getChatId();
    super.onInit();
  }

  var chats = firestore.collection(chatsCollection);

  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];
  var friendImageUrl = ''.obs; 

  var senderName = Get.find<NewsController>().username;
  var currentId = currentUser!.uid;
  var currentUserImageUrl = ''.obs; 

  var msgController = TextEditingController();

  dynamic chatDocId;

  var isLoading = false.obs;

  getChatId() async {
    isLoading(true);

    // imageUrl for both users
    await firestore.collection('users').doc(friendId).get().then((doc) {
      if (doc.exists) {
        friendImageUrl.value = doc['imageUrl'] ?? '';
      }
    });

    await firestore.collection('users').doc(currentId).get().then((doc) {
      if (doc.exists) {
        currentUserImageUrl.value = doc['imageUrl'] ?? '';
      }
    });

    // Check friend_name matches vendor_name 
    await firestore.collection(vendorsCollection).where('vendor_name', isEqualTo: friendName).limit(1).get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var vendorDoc = snapshot.docs.single;
        friendImageUrl.value = vendorDoc['imageUrl'] ?? '';
      }
    });

    await chats
        .where('users', isEqualTo: {friendId: null, currentId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        chatDocId = snapshot.docs.single.id;
      } else {
        chats.add({
          'created_on': null,
          'last_msg': '',
          'users': {friendId: null, currentId: null},
          'toId': '',
          'fromId': '',
          'friend_name': friendName,
          'sender_name': senderName,
          'friend_image_url': friendImageUrl.value,
          'current_user_image_url': currentUserImageUrl.value
        }).then((value) {
          chatDocId = value.id;
        });
      }
    });
    isLoading(false);
  }

  sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': friendId,
        'fromId': currentId,
      });

      chats.doc(chatDocId).collection(messagesCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': friendId,
      });
    }
  }
}
