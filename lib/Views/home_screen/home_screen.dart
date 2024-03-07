import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/images.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/home_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';

// โมเดลใน Product //
class Product {
  final String id;
  final List<String> imageUrls; // ต้องเก็บ URL รูปภาพเป็น List

  Product({required this.id, required this.imageUrls});

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    List<String> imageUrls = List<String>.from(data['p_imgs'] ?? []);
    return Product(
      id: doc.id,
      imageUrls: imageUrls,
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
  final HomeController controller = Get.put(HomeController());

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
            // ใช้ Swiper จาก flutter_card_swiper
            return CardSwiper(
              cardsCount: products.length,
              cardBuilder: (BuildContext context, int index) {
                Product product = products[index];
                return Image.network(
                  product.imageUrls.isNotEmpty
                      ? product.imageUrls[0]
                      : 'URL_ของรูปภาพ_placeholder',
                  fit: BoxFit.cover,
                );
              },
              pagination: SwiperPagination(),
              control: SwiperControl(),
            );
          },
        ),
      ),
    );
  }
}
