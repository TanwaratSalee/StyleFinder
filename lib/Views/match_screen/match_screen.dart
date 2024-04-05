import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/search_screen/search_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/appbar_ontop.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/images.dart';
import 'package:get/get.dart';
import '../cart_screen/cart_screen.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  int selectedCardIndex = 0; // เก็บ index ของการ์ดที่ถูกเลือก

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        title: appbarField(),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: Image.asset(
                icCart,
                width: 21,
              ),
              onPressed: () {
                Get.to(() => const CartScreen());
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 75,
                ),
                buildCardSetTop(),
                SizedBox(height: 5),
                buildCardSetBottom(),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    // เพิ่ม `child:` ก่อน Row เพื่อให้เป็น child ของ Container
                    mainAxisAlignment: MainAxisAlignment
                        .center, // ใช้เพื่อจัดกึ่งกลางของแถว, คุณสามารถปรับเปลี่ยนได้ตามความต้องการ
                    children: <Widget>[
                      Text(
                        'Match with you',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: Image.asset(
                          icLikeButton,
                          width: 67,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardSetTop() {
    return Container(
      height: 250.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10, // จำนวนการ์ด
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 300.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/product${index % 3 + 1}.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget buildCardSetBottom() {
  return Container(
    height: 250.0, // กำหนดความสูงของ container ที่มีการ์ด
    child: ListView.builder(
      scrollDirection: Axis.horizontal, // ให้การ์ดเลื่อนได้ในแนวนอน
      itemCount: 10, // จำนวนการ์ด
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 300.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/product${index % 3 + 1}.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget buildheart() {
  return Container(
    height: 100.0, // กำหนดความสูงของ container ที่มีการ์ด
    child: ListView.builder(
      scrollDirection: Axis.horizontal, // ให้การ์ดเลื่อนได้ในแนวนอน
      itemCount: 10, // จำนวนการ์ด
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 100.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/product${index % 3 + 1}.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    ),
  );
}
