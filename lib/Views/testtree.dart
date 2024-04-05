// // ignore_for_file: unused_local_variable

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_finalproject/Views/profile_screen/menu_setting_screen.dart';
// import 'package:flutter_finalproject/consts/consts.dart';
// import 'package:flutter_finalproject/controllers/profile_controller.dart';
// import 'package:flutter_finalproject/services/firestore_services.dart';
// import 'package:get/get.dart';


// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.put(ProfileController());

//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: whiteColor,
//           automaticallyImplyLeading: false,
//           title: const Text(
//             'Profile',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: fontBlack,
//               fontSize: 26,
//               fontFamily: 'regular',
//             ),
//           ),
//           actions: <Widget>[
//             IconButton(
//               icon: const Icon(
//                 Icons.menu,
//                 color: fontBlack,
//               ),
//               onPressed: () {
//                 Get.to(() => const MenuSettingScreen());
//               },
//             ),
//           ],
//           centerTitle: true,
//         ),
//         backgroundColor: whiteColor,
//         body: StreamBuilder(
//             stream: FirestoreServices.getUser(currentUser!.uid),
//             builder:
//                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return const Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation(primaryApp),
//                   ),
//                 );
//               } else {
//                 var data = snapshot.data!.docs[0];

//                 return SafeArea(
//                   child: Column(
//                     children: [
//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: SingleChildScrollView(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 data['imageUrl'] == ''
//                                     ? ClipRRect(
//                                         borderRadius:
//                                             BorderRadius.circular(100),
//                                         child: Image.asset(
//                                           imProfile,
//                                           width: 120,
//                                           height: 120,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       )
//                                     : ClipRRect(
//                                         borderRadius:
//                                             BorderRadius.circular(100),
//                                         child: Image.network(
//                                           data['imageUrl'],
//                                           width: 120,
//                                           height: 120,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                 const SizedBox(height: 5),
//                                 Text(
//                                   data['name'][0].toUpperCase() +
//                                       data['name'].substring(1),
//                                   style: const TextStyle(
//                                       fontSize: 24,
//                                       color: fontBlack,
//                                       fontFamily: regular),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const TabBar(
//                         tabs: [
//                           Tab(text: 'Product'),
//                           Tab(text: 'Match'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               }
//             }));
//   }
// }

// Widget _buildProductTab(BuildContext context) {
    
//     return SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           ListTile(
//             leading: Icon(Icons.shopping_bag),
//             title: Text('ONE-PIECE SWIMSUIT'),
//             subtitle: Text('39,000.00 Bath'),
//             trailing: IconButton(
//               icon: Icon(Icons.favorite, color: Colors.red),
//               onPressed: () {
                
//               },
//             ),
//           ),
          
//         ],
//       )
//     );
//   }

//   Widget _buildMatchTab(BuildContext context) {
    
//     return SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           ListTile(
//             leading: Icon(Icons.check_circle),
//             title: Text('Perfect Match Item'),
//             subtitle: Text('Your perfect match description here'),
//             trailing: IconButton(
//               icon: Icon(Icons.favorite_border),
//               onPressed: () {
                
//               },
//             ),
//           ),
          
//         ],
//       ),
//     );
//   }
// =======


// Widget _buildProductTab(BuildContext context) {
    
//     return SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           ListTile(
//             leading: Icon(Icons.shopping_bag),
//             title: Text('ONE-PIECE SWIMSUIT'),
//             subtitle: Text('39,000.00 Bath'),
//             trailing: IconButton(
//               icon: Icon(Icons.favorite, color: Colors.red),
//               onPressed: () {
                
//               },
//             ),
//           ),
          
//         ],
//       )
//     );
//   }

//   Widget _buildMatchTab(BuildContext context) {
    
//     return SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           ListTile(
//             leading: Icon(Icons.check_circle),
//             title: Text('Perfect Match Item'),
//             subtitle: Text('Your perfect match description here'),
//             trailing: IconButton(
//               icon: Icon(Icons.favorite_border),
//               onPressed: () {
                
//               },
//             ),
//           ),
          
//         ],
//       ),
//     );
//   }

//   import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_finalproject/Views/store_screen/match_detail_screen.dart';
// import 'package:flutter_finalproject/Views/store_screen/reviews_screen.dart';
// import 'package:flutter_finalproject/consts/consts.dart';
// import 'package:flutter_finalproject/controllers/profile_controller.dart';
// import 'package:flutter_finalproject/services/firestore_services.dart';
// import 'package:get/get.dart';

// import 'menu_setting_screen.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgGreylight,
//       appBar: AppBar(
//           backgroundColor: whiteColor,
//           automaticallyImplyLeading: false,
//           title: const Text(
//             'Profile',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: fontBlack,
//               fontSize: 26,
//               fontFamily: 'regular',
//             ),
//           ),
//           actions: <Widget>[
//             IconButton(
//               icon: const Icon(
//                 Icons.menu,
//                 color: fontBlack,
//               ),
//               onPressed: () {
//                 Get.to(() => const MenuSettingScreen());
//               },
//             ),
//           ],
//           centerTitle: true,
//         ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             _buildLogoAndRatingSection(context),
//             _buildReviewHighlights(),
//             _buildProductMatchTabs(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLogoAndRatingSection(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 6.0),
//       child: Column(
//         children: <Widget>[
//           _buildProfileScreen(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileScreen(BuildContext context) {
//     var controller = Get.put(ProfileController());
    
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 1.0),
//       child: StreamBuilder(
//             stream: FirestoreServices.getUser(currentUser!.uid),
//             builder:
//                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return const Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation(primaryApp),
//                   ),
//                 );
//               } else {
//                 var data = snapshot.data!.docs[0];

//                 return SafeArea(
//                   child: Column(
//                     children: [
//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: SingleChildScrollView(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 data['imageUrl'] == ''
//                                     ? ClipRRect(
//                                         borderRadius:
//                                             BorderRadius.circular(100),
//                                         child: Image.asset(
//                                           imProfile,
//                                           width: 120,
//                                           height: 120,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       )
//                                     : ClipRRect(
//                                         borderRadius:
//                                             BorderRadius.circular(100),
//                                         child: Image.network(
//                                           data['imageUrl'],
//                                           width: 120,
//                                           height: 120,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                 const SizedBox(height: 5),
//                                 Text(
//                                   data['name'][0].toUpperCase() +
//                                       data['name'].substring(1),
//                                   style: const TextStyle(
//                                       fontSize: 24,
//                                       color: fontBlack,
//                                       fontFamily: regular),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const TabBar(
//                         tabs: [
//                           Tab(text: 'Product'),
//                           Tab(text: 'Match'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               }
//             })
//     );
//   }

//   Widget _buildReviewHighlights() {
//     return Container(
//       height: 120,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 3,
//         itemBuilder: (context, index) {
//           return _buildReviewCard();
//         },
//       ),
//     );
//   }

//   Widget _buildReviewCard() {
//     return Container(
//       width: 200,
//       margin: EdgeInsets.all(5.0),
//       padding: EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//         color: whiteColor,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: fontGrey,
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Reviewer Name',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           Row(
//             children: List.generate(5, (index) {
//               return Icon(
//                 index < 4 ? Icons.star : Icons.star_border,
//                 color: Colors.amber,
//                 size: 20,
//               );
//             }),
//           ),
//           Text(
//             'The review text goes here...',
//             style: TextStyle(fontSize: 14),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductMatchTabs(BuildContext context) {
//     return DefaultTabController(
//       length: 2, // มีแท็บทั้งหมด 2 แท็บ
//       child: Column(
//         children: <Widget>[
//           TabBar(
//             tabs: [
//               Tab(text: 'Product'),
//               Tab(text: 'Match'),
//             ],
//           ),
//           Container(
//             height: MediaQuery.of(context).size.height * 0.9,
//             child: TabBarView(
//               children: [
//                 _buildProductTab(context),
//                 _buildMatchTab(context),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductTab(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.all(5),
//           child: _buildCategoryTabs(context),
//         ),
//         Expanded(
//           child: Container(),
//         ),
//       ],
//     );
//   }

//   Widget _buildMatchTab(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.all(5),
//           child: _buildCategoryMath(context),
//         ),
//         Expanded(
//           child: Container(),
//         ),
//       ],
//     );
//   }

//   Widget _buildCategoryTabs(BuildContext context) {
//     return DefaultTabController(
//       length: 5,
//       child: Column(
//         children: <Widget>[
//           const TabBar(
//             isScrollable: true,
//             indicatorColor: primaryApp,
//             tabs: [
//               Tab(text: 'All'),
//               Tab(text: 'Outer'),
//               Tab(text: 'Dress'),
//               Tab(text: 'Blouse/Shirt'),
//               Tab(text: 'T-Shirt'),
//             ],
//           ),
//           Container(
//             height: MediaQuery.of(context).size.height * 0.9,
//             child: TabBarView(
//               children: [
//                 _buildProductGrid('All'),
//                 _buildProductGrid('Outer'),
//                 _buildProductGrid('Dress'),
//                 _buildProductGrid('Blouse/Shirt'),
//                 _buildProductGrid('T-Shirt'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryMath(BuildContext context) {
//     return DefaultTabController(
//       length: 5,
//       child: Column(
//         children: <Widget>[
//           const TabBar(
//             isScrollable: true,
//             indicatorColor: primaryApp,
//             tabs: [
//               Tab(text: 'All'),
//               Tab(text: 'Outer'),
//               Tab(text: 'Dress'),
//               Tab(text: 'Blouse/Shirt'),
//               Tab(text: 'T-Shirt'),
//             ],
//           ),
//           Container(
//             height: MediaQuery.of(context).size.height * 0.9,
//             child: TabBarView(
//               children: [
//                 _buildProductMathGrids('All'),
//                 _buildProductMathGrids('Outer'),
//                 _buildProductMathGrids('Dress'),
//                 _buildProductMathGrids('Blouse/Shirt'),
//                 _buildProductMathGrids('T-Shirt'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductGrid(String category) {
//     return GridView.builder(
//       padding: const EdgeInsets.all(8.0),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 1 / 1.1,
//       ),
//       itemBuilder: (BuildContext context, int index) {
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) =>
//                       MatchDetailScreen()), // Ensure you have a class named ItemMatching
//             );
//           },
//           child: Card(
//             clipBehavior: Clip.antiAlias,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Image.asset(
//                   card1,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   height: 150,
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text('Product Title',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           )),
//                       Text('Price',
//                           style: TextStyle(
//                             color: Colors.grey,
//                           )),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       itemCount: 50,
//     );
//   }

//   Widget _buildProductMathGrids(String category) {
//     return GridView.builder(
//       padding: EdgeInsets.all(2),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 1 / 1,
//       ),
//       itemBuilder: (BuildContext context, int index) {
//         String productName1 = "Product $index A";
//         double price1 = 100.0;
//         String productName2 = "Product $index B";
//         double price2 = 150.0;
//         double totalPrice = price1 + price2;
//         return GestureDetector(
//           onTap: () {
//             // Add navigation to ItemMatching page here
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) =>
//                       MatchDetailScreen()), // Ensure you have a class named ItemMatching
//             );
//           },
//           child: Card(
//             clipBehavior: Clip.antiAlias,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Row(
//                   children: [
//                     Column(
//                       children: [
//                         Image.asset(
//                           card1,
//                           width: 80,
//                           height: 80,
//                         ),
//                         Image.asset(
//                           card2,
//                           width: 80,
//                           height: 80,
//                         ),
//                       ],
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             SizedBox(
//                               height: 2,
//                             ),
//                             Text(
//                               productName1,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               'Price: \$${price1.toString()}',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             Text(
//                               productName2,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               'Price: \$${price2.toString()}',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: Text(
//                     'Total Price: \$${totalPrice.toString()}',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       itemCount: 50,
//     );
//   }
// }

// >>>>>>> 527aa17 (a)
