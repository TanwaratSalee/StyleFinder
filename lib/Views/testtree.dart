// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/profile_screen/menu_setting_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/profile_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          automaticallyImplyLeading: false,
          title: const Text(
            'Profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: fontBlack,
              fontSize: 26,
              fontFamily: 'regular',
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: fontBlack,
              ),
              onPressed: () {
                Get.to(() => const MenuSettingScreen());
              },
            ),
          ],
          centerTitle: true,
        ),
        backgroundColor: whiteColor,
        body: StreamBuilder(
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
            }));
  }
}

Widget _buildProductTab(BuildContext context) {
    
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('ONE-PIECE SWIMSUIT'),
            subtitle: Text('39,000.00 Bath'),
            trailing: IconButton(
              icon: Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                
              },
            ),
          ),
          
        ],
      )
    );
  }

  Widget _buildMatchTab(BuildContext context) {
    
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.check_circle),
            title: Text('Perfect Match Item'),
            subtitle: Text('Your perfect match description here'),
            trailing: IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {
                
              },
            ),
          ),
          
        ],
      ),
    );
  }