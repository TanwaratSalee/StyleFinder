import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/consts/firebase_consts.dart';
import 'package:get/get.dart';

class ReviewsController extends GetxController {
  void saveReview(Map<String, dynamic> product, String reviewText, double rating) {
    final reviewData = {
      'product_id': product['id'],
      'product_title': product['title'],
      'product_img': product['img'],
      'product_price': product['price'],
      'user_id': currentUser!.uid,
      'review': reviewText,
      'rating': rating,
      'timestamp': FieldValue.serverTimestamp(),
    };

    FirebaseFirestore.instance.collection('reviews').add(reviewData).then((_) {
      Get.snackbar(
        "Success",
        "Review submitted successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    }).catchError((error) {
      Get.snackbar(
        "Error",
        "Failed to submit review: $error",
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }
}
