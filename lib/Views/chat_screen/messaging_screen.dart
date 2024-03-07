import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/chat_screen/chat_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Orders".text.color(fontGreyDark).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(stream: FirestoreServices.getAllMessages(), 
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return Center(
            child: loadingIndcator(),
          );
        } else if(snapshot.data!.docs.isEmpty){
          return "No messages yet!".text.color(fontGreyDark).makeCentered();
        } else {
          var data = snapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index){
                    return Card(
                      child: ListTile( onTap: () {
                        Get.to(() => const ChatScreen(),
                        arguments: [
                          data[index]['friend_name'],
                          data[index]['toId']
                        ]
                        );
                      },
                      leading: const CircleAvatar(
                        backgroundColor: primaryApp,
                        child: Icon(Icons.person, color: whiteColor,),
                      ),
                        title: "${data[index]['friend_name']}".text.fontFamily(semibold).color(fontBlack).make(),
                        subtitle: "${data[index]['last_msg']}".text.make( ),
                      ),
                    );
                  }))
              ],
            ),
          );
        }
      }),
    );
  }
}