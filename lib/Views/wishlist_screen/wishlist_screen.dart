import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/views/collection_screen/item_details.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          whiteColor, // Ensure whiteColor is correctly defined in consts.dart
      appBar: AppBar(
        title: const Text(
          "Favourite",
          style: TextStyle(
            color:
                fontGreyDark, // Ensure fontGreyDark is correctly defined in consts.dart
            fontSize: 24,
            fontFamily: bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreServices.getWishlists(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!.docs;
          if (data.isEmpty) {
            return const Center(
                child: Text("No orders yet!",
                    style: TextStyle(color: fontGreyDark)));
          }
          return ListView.separated(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetails(
                        title: data[index]['p_name'],
                        data: data[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color:
                        whiteColor, // Ensure whiteColor is correctly defined in consts.dart
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data[index]['p_imgs'][0],
                            height: 75,
                            width: 65,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data[index]['p_name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: regular,
                                ),
                              ),
                              Text(
                                "${data[index]['p_price']}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: light,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection(productsCollection)
                              .doc(data[index].id)
                              .update({
                            'p_wishlist': FieldValue.arrayRemove(
                                [FirebaseAuth.instance.currentUser!.uid])
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal:
                      10), // ปรับระยะห่างของเส้นคั่นจากขอบด้านซ้ายและขวา
              child: Divider(
                color: Colors.grey[
                    200], // ปรับให้เป็นสีเทาอ่อนกว่า คุณสามารถเปลี่ยนเป็น [300], [200] หรือค่าอื่นๆ เพื่อปรับความเข้มของสี
                thickness: 1, // สามารถปรับความหนาของเส้นคั่นได้ตามต้องการ
              ),
            ),
          );
        },
      ),
    );
  }
}
