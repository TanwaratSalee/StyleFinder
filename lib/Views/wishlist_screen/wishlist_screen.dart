import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Wishlist".text.color(fontGreyDark).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(stream: FirestoreServices.getWishlists(), 
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return Center(
            child: loadingIndcator(),
          );
        } else if(snapshot.data!.docs.isEmpty){
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
                    return ListTile(
                      leading: Image.network(
                        "${data[index]['p_imgs'][0]}",
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      title: "${data[index]['p_name']}".text.fontFamily(semibold).size(16).make(),
                      subtitle: "${data[index]['p_price']}".numCurrency.text.color(primaryApp).fontFamily(semibold).make(),
                      trailing: const Icon(Icons.favorite, color: primaryApp).onTap(() async {
                        await firestore.collection(productsCollection).doc(data[index].id).set( {
                           'p_wishlist':FieldValue.arrayRemove([currentUser!.uid])
                         }, SetOptions(merge: true));
                      }),
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