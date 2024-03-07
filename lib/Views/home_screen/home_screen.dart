import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/images.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/home_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_finalproject/models/collection_model.dart';
import 'package:flutter/services.dart';

// โมเดลใน Product //
class Product {
  final String id;
  final String name;
  final String price;
  final List<String> imageUrls;
  final dynamic wishlist;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.imageUrls,
      required this.wishlist});

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    List<String> imageUrls = List<String>.from(data['p_imgs'] ?? []);
    return Product(
      id: doc.id,
      name: data['p_name'] ?? '',
      price: data['p_price'] ?? '',
      imageUrls: imageUrls,
      wishlist: data['p_wishlist'] ?? false,
    );
  }
}

// ดึงข้อมูลจาก Firebase //
Future<List<Product>> fetchProducts() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('products').get();

  return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: FutureBuilder<List<Product>>(
          future: fetchProducts(), // ตรวจสอบว่าได้เรียกใช้ฟังก์ชันที่ถูกต้อง
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.error != null) {
              // แสดงข้อความข้อผิดพลาด
              return Center(
                  child: Text('An error occurred: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            }

            List<Product> products = snapshot.data!;
            return CardSwiper(
              scale: 0.5,
              isLoop: true,
              cardsCount: products.length,
              cardBuilder: (BuildContext context, int index,
                  int percentThresholdX, int percentThresholdY) {
                Product product = products[index];
                return Container(
                  width: 390,
                  height: 586,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white, // กำหนดสีขอบเป็นสีขาว
                      width: 30, // ความกว้างขอบ
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // สีเงา
                        spreadRadius: 5, // รัศมีการกระจาย
                        blurRadius: 7, // รัศมีการเบลอ
                        offset: Offset(0, 3), // ตำแหน่งเงา
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10), // ใส่รัศมีกรอบ
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        product.imageUrls.isNotEmpty
                            ? product.imageUrls[0]
                            : 'URL_ของรูปภาพ_placeholder',
                        height: 486, // กำหนดความสูงของรูปภาพเป็นค่าคงที่ 200
                        width: 369, // กำหนดความกว้างของรูปภาพเป็นค่าคงที่ 200
                        fit: BoxFit
                            .cover, // กำหนดให้รูปภาพปรับขนาดให้เต็มพื้นที่และตัวอักษรไม่ถูกตัดออก
                      ),
                      Positioned(
                        left: 10, // ตำแหน่งซ้ายของ Container
                        bottom: 10, // ตำแหน่งด้านล่างของ Container
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name, // ชื่อสินค้า
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Price: \$${product.price}', // แสดงราคาพร้อมกับเครื่องหมายดอลลาร์และทศนิยม 2 ตำแหน่ง
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
