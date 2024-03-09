import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/profile_screen/edit_profile_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:flutter_finalproject/controllers/store_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';

class StoreScreen extends StatelessWidget {
  
  const StoreScreen({super.key});
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: bgGreylight,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios)),
              
        ),
        body: StreamBuilder(
            stream: FirestoreServices.getVendor(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
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
                                Text(
                                  data['name'],
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: fontBlack),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                );
              }
            }));
  }
}
