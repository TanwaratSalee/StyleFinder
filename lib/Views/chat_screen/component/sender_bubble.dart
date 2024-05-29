import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/consts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

Widget senderBubble(DocumentSnapshot data) {
  var t =
      data['created_on'] == null ? DateTime.now() : data['created_on'].toDate();
  var time = intl.DateFormat("h:mma").format(t);

  return Directionality(
    textDirection: data['uid'] == currentUser!.uid ? TextDirection.rtl : TextDirection.ltr,
    child: Column(
      crossAxisAlignment: data['uid'] == currentUser!.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: data['uid'] == currentUser!.uid ? greyMessage : primaryMessage,
            borderRadius: data['uid'] == currentUser!.uid
                ? BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
          ),
          constraints: BoxConstraints(maxWidth: 200), 
          child: "${data['msg']}".text.black.fontFamily(regular).size(14).make(),
        ),
        time.text.size(12).fontFamily(regular).color(blackColor.withOpacity(0.8)).make(),
      ],
    ),
  );
}
