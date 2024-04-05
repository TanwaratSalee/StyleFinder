import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/profile_screen/menu_setting_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController; 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    
    return Scaffold(
      backgroundColor: whiteColor, // Replace with your actual color
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
            'Profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: fontBlack, // Replace with your actual color
              fontSize: 26,
              fontFamily: 'regular', // Replace with your actual font
            ),
          ),
        actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: fontBlack, // Replace with your actual color
              ),
              onPressed: () {
                Get.to(() => const MenuSettingScreen());
              },
            ),
          ],
          centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductTab(),
                _buildMatchTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: TabBar(
          controller: _tabController,
          labelColor: fontBlack, // Replace with your actual color
          unselectedLabelColor: Colors.grey, // Or any other color for unselected text
          tabs: const [
            Tab(text: 'Product'),
            Tab(text: 'Match'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
  return StreamBuilder(
            stream: FirestoreServices.getUser(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primaryApp),
                  ),
                );
              } else {
                var data = snapshot.data!.docs[0];

                return SafeArea(
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                data['imageUrl'] == ''
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.asset(
                                          imProfile,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          data['imageUrl'],
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                const SizedBox(height: 5),
                                Text(
                                  data['name'][0].toUpperCase() +
                                      data['name'].substring(1),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: fontBlack,
                                      fontFamily: regular),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const TabBar(
                        tabs: [
                          Tab(text: 'Product'),
                          Tab(text: 'Match'),
                        ],
                      ),
                    ],
                  ),
                );
              }
            });
}


  Widget _buildProductTab() {
  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        _buildProfileHeader(),
        // Placeholder for actual product list - replace this with your own data fetching and rendering logic
        ListTile(
          leading: Icon(Icons.shopping_bag),
          title: Text('Product 1'),
          subtitle: Text('Price: 1,000.00 Bath'),
          trailing: IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              // Handle the favorite button tap
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.shopping_bag),
          title: Text('Product 2'),
          subtitle: Text('Price: 2,000.00 Bath'),
          trailing: IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              // Handle the favorite button tap
            },
          ),
        ),
        // ... More ListTiles for each product ...
      ],
    ),
  );
}

Widget _buildMatchTab() {
  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        _buildProfileHeader(),
        // Placeholder for actual match list - replace this with your own data fetching and rendering logic
        ListTile(
          leading: Icon(Icons.check_circle_outline),
          title: Text('Match 1'),
          subtitle: Text('Compatibility: 90%'),
          trailing: IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              // Handle the favorite button tap
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.check_circle_outline),
          title: Text('Match 2'),
          subtitle: Text('Compatibility: 85%'),
          trailing: IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              // Handle the favorite button tap
            },
          ),
        ),
        // ... More ListTiles for each match ...
      ],
    ),
  );
}

}
