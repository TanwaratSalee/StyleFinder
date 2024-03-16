import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/collection_screen/item_details.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';

class WishlistScreen extends StatelessWidget {
  final dynamic data;
  const WishlistScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreylight,
      appBar: AppBar(
        title: "Favourite"
            .text
            .color(fontGreyDark)
            .size(28)
            .fontFamily(bold)
            .make(),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getWishlists(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndcator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return "No orders yet!".text.color(fontGreyDark).makeCentered();
            } else {
              var data = snapshot.data!.docs;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
  shrinkWrap: true,
  itemCount: data.length,
  itemBuilder: (BuildContext context, int index) {
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
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        decoration: BoxDecoration(
          color: whiteColor, 
          borderRadius: BorderRadius.circular(8), 
        ),
        child: ListTile(
          leading: Image.network(
            "${data[index]['p_imgs'][0]}",
            height: 350,
            fit: BoxFit.cover,
          ),
          title: "${data[index]['p_name']}"
              .text
              .fontFamily(regular)
              .size(16)
              .make(),
          subtitle: "${data[index]['p_price']}"
              .numCurrency
              .text
              .color(primaryApp)
              .fontFamily(regular)
              .make(),
          trailing: const Icon(Icons.favorite, color: redColor).onTap(() async {
            await firestore
                .collection(productsCollection)
                .doc(data[index].id)
                .set({
              'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
            }, SetOptions(merge: true));
          }),
        ),
      ),
    );
  },
),

                  ),
                ],
              );
            }
          }),
    );
  }
}
