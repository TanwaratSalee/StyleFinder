import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:get/get.dart';

class MatchDetailScreen extends StatefulWidget {
  final String productName1;
  final String productName2;
  final String price1;
  final String price2;
  final String productImage1;
  final String productImage2;
  final String totalPrice;

  const MatchDetailScreen({
    this.productName1 = '',
    this.productName2 = '',
    this.price1 = '',
    this.price2 = '',
    this.productImage1 = '',
    this.productImage2 = '',
    this.totalPrice = '',
  });

  @override
  _MatchDetailScreenState createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  bool isFavorited = false;
  late final ProductController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductController());
    checkIsInWishlist();
  }

void checkIsInWishlist() async {
  FirebaseFirestore.instance
      .collection(productsCollection)
      .where('p_name', whereIn: [widget.productName1, widget.productName2])
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        List<dynamic> wishlist = doc['p_wishlist'] ?? [];
        if (wishlist.contains(currentUser!.uid)) {
          controller.isFav(true);
        } else {
          controller.isFav(false);
        }
      });
    }
  });
}


  void _updateIsFav(bool isFav) {
    setState(() {
      controller.isFav.value = isFav;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Match Detail'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        actions: <Widget>[
Obx(() => IconButton(
  onPressed: () {
    print("IconButton pressed");
    List<String> productNames = [widget.productName1, widget.productName2];
    bool isFav = !controller.isFav.value; // Toggle the isFav value
    productNames.forEach((productName) {
      if (isFav == true)  {
        controller.addToWishlistMixMatch(productName, _updateIsFav, context);
      }
      if (isFav == false) {
        controller.removeToWishlistMixMatch(productName, _updateIsFav, context);
      }
    });
    print("isFav after toggling: $isFav"); // Debug print
  },
  icon: Icon(
    controller.isFav.value
        ? Icons.favorite
        : Icons.favorite_outline,
    color: controller.isFav.value ? redColor : null,
  ),
  iconSize: 28,
)),

        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: blackColor),
                              ),
                              child: Center(
                                child: Image.network(
                                  widget.productImage1,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(widget.productName1,
                                style: const TextStyle(
                                    fontSize: 16, fontFamily: bold)),
                            Text('฿${widget.price1}',
                                style: const TextStyle(
                                    fontSize: 14, color: blackColor)),
                          ],
                        ),
                        const SizedBox(width: 10), // สร้างระยะห่าง
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 20, // ขนาดของวงกลม
                              height: 20, // ขนาดของวงกลม
                              decoration: BoxDecoration(
                                color: Colors.lightBlue[100], // สีฟ้าอ่อน
                                shape: BoxShape.circle, // ทำให้เป็นรูปวงกลม
                              ),
                            ),
                            const Text('+',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: bold,
                                    color: Colors.white)),
                          ],
                        ),
                        const SizedBox(width: 10),
                        // สร้างระยะห่าง
                        // สำหรับรูปภาพที่สองและข้อมูล
                        Column(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: blackColor),
                              ),
                              child: Center(
                                child: Image.network(
                                  widget.productImage2,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(widget.productName2,
                                style: const TextStyle(
                                    fontSize: 16, fontFamily: bold)),
                            Text('฿${widget.price2}',
                                style: const TextStyle(
                                    fontSize: 14, color: blackColor)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30), // เพิ่มระยะห่าง
                    Container(
                      height: 65,
                      margin: const EdgeInsets.only( bottom: 10), // ขยับ widget bar จากด้านบนลงมา
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[100],
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text('Dior',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Dior',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: bold)),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.yellow, size: 20),
                                  Icon(Icons.star,
                                      color: Colors.yellow, size: 20),
                                  Icon(Icons.star,
                                      color: Colors.yellow, size: 20),
                                  Icon(Icons.star,
                                      color: Colors.yellow, size: 20),
                                  Icon(Icons.star,
                                      color: Colors.yellow, size: 20),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          ElevatedButton(
                              onPressed: () {
                                // ทำสิ่งที่ต้องการเมื่อกดปุ่ม
                              },
                              child: const Text('See Store'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white!),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    const Size(0, 30)),
                              )),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 0.5),
                    // เพิ่มระยะห่าง

                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 250, 0),
                      child: Text(
                        'Opportunity for',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),

                    Row(children: [
                      ElevatedButton(
                        onPressed: () {
                          // ทำสิ่งที่ต้องการเมื่อกดปุ่ม
                        },
                        child: const Text(
                          'Everyday',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey[100]!),
                          minimumSize:
                              MaterialStateProperty.all<Size>(const Size(20, 20)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5), // ปรับระยะห่างภายในปุ่ม
                          ),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize:
                                  13, // ตั้งค่าขนาดตัวอักษรของข้อความภายในปุ่ม
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
                      ElevatedButton(
                        onPressed: () {
                          // ทำสิ่งที่ต้องการเมื่อกดปุ่ม
                        },
                        child: const Text(
                          'Dating',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey[100]!),
                          minimumSize:
                              MaterialStateProperty.all<Size>(const Size(20, 20)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5), // ปรับระยะห่างภายในปุ่ม
                          ),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize:
                                  13, // ตั้งค่าขนาดตัวอักษรของข้อความภายในปุ่ม
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
                      ElevatedButton(
                        onPressed: () {
                          // ทำสิ่งที่ต้องการเมื่อกดปุ่ม
                        },
                        child: const Text(
                          'Seminars ',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey[100]!),
                          minimumSize:
                              MaterialStateProperty.all<Size>(const Size(20, 20)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5), // ปรับระยะห่างภายในปุ่ม
                          ),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize:
                                  13, // ตั้งค่าขนาดตัวอักษรของข้อความภายในปุ่ม
                            ),
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: double.infinity, // ทำให้ container กว้างเต็มขอบ
                        height: 150, // กำหนดความสูง
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // ตั้งค่าสีพื้นหลัง
                          borderRadius: BorderRadius.circular(10), // มุมโค้ง
                        ),
                        child: const Align(
                          alignment:
                              Alignment.topLeft, // จัดตำแหน่งข้อความชิดซ้ายบน
                          child: Padding(
                            padding: EdgeInsets.all(
                                8.0), // เพิ่ม padding ให้ข้อความ
                            child: Text(
                              'HEllo ',
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
