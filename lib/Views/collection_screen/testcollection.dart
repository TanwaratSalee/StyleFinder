// import 'package:flutter/material.dart';
// import 'package:flutter_finalproject/consts/consts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CollectionDetails extends StatelessWidget {
//   const CollectionDetails({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('products').snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         return ListView(
//           children: snapshot.data!.docs.map((document){
//             return Container(
//               child: FittedBox(child: Text(document["p_collection"]),),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }
