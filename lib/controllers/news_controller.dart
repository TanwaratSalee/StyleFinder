import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';

class NewsController extends GetxController {
  @override
  void onInit() {
    getUsername();
    super.onInit();
  }

  var currentNavIndex = 0.obs;

  var username = '';

  var featuredList = [];

  var searchController = TextEditingController();

  getUsername() async {
    var n = await firestore
        .collection(usersCollection)
        .where('id', isEqualTo: currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        // ตรวจสอบว่าชื่อไม่เป็น null ก่อนการกำหนดค่า
        return value.docs.single['name'] ??
            ''; // ให้ค่าเริ่มต้นเป็นสตริงว่างหากชื่อเป็น null
      }
      return ''; // คืนค่าสตริงว่างหากไม่พบเอกสาร
    });

    username = n ?? ''; // ให้ค่าเริ่มต้นเป็นสตริงว่างหาก n เป็น null
  }
}
