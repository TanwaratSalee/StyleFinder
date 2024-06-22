// utils/firestore_utils.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUtils {
  static Future<String?> getVendorName(String vendorId) async {
    final doc = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .get();
    if (doc.exists) {
      final data = doc.data();
      return data?['name'];
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getProductDetails(String productId) async {
    final doc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }
}
