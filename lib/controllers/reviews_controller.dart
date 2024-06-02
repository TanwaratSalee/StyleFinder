import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class ReviewsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void submitReview(String productId, String productTitle, String productImg, double productPrice, String reviewText, double rating) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      DocumentReference reviewDocRef = _firestore.collection('products').doc(productId).collection('reviews').doc();

      await reviewDocRef.set({
        'product_id': productId,
        'product_title': productTitle,
        'product_img': productImg,
        'product_price': productPrice,
        'user_id': currentUser.uid,
        'review_text': reviewText,
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((value) {
        print('Review submitted successfully!');
        VxToast.show(Get.context!, msg: 'Review submitted successfully!');
      }).catchError((error) {
        print('Failed to submit review: $error');
        VxToast.show(Get.context!, msg: 'Failed to submit review: $error');
      });

      // Update the product document with the review info if needed
      DocumentSnapshot productSnapshot = await _firestore.collection('products').doc(productId).get();
      Map<String, dynamic> productData = productSnapshot.data() as Map<String, dynamic>;
      int reviewCount = (productData['review_count'] ?? 0) as int;
      double averageRating = (productData['average_rating'] ?? 0.0) as double;

      await _firestore.collection('products').doc(productId).update({
        'review_count': reviewCount + 1,
        'average_rating': ((averageRating * reviewCount) + rating) / (reviewCount + 1),
      }).then((value) {
        print('Product updated successfully!');
        VxToast.show(Get.context!, msg: 'Product updated successfully!');
      }).catchError((error) {
        print('Failed to update product: $error');
        VxToast.show(Get.context!, msg: 'Failed to update product: $error');
      });

      // Print the review details
      print('Review Details:');
      print('Product ID: $productId');
      print('Product Title: $productTitle');
      print('Product Image: $productImg');
      print('Product Price: $productPrice');
      print('User ID: ${currentUser.uid}');
      print('Review Text: $reviewText');
      print('Rating: $rating');
    } else {
      // Show an error notification
      print('Error: User not logged in.');
      VxToast.show(Get.context!, msg: 'Error: User not logged in.');
    }
  }
}
