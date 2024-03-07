import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/images.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/home_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';


// test
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ใช้ Colors.white หรือตัวแปรที่นิยามสีขาว
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10, left: 20, right: 20,
        ), // แก้ไขที่นี่
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.4,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(card1),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius. circular (8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 4,
                    offset: Offset (3, 3),)
                ]
              ),
            ),
            Container(
              decoration:
              BoxDecoration(
              borderRadius: BorderRadius.circular (5.0), 
              gradient: LinearGradient(
              colors: [
                Color. fromARGB(200, 0, 0, 0), 
                Color. fromARGB(0, 0, 0, 0),
                ], 
                begin: Alignment.bottomCenter, 
                end: Alignment. topCenter,
              ),
              ),
            )
            ],
          ),
        ),
      ), // แก้ไขที่นี่
    );
  }
}