import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_finalproject/controllers/reviews_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class WriteReviewScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  WriteReviewScreen({Key? key, required this.product}) : super(key: key);

  final TextEditingController _reviewController = TextEditingController();
  final ReviewsController reviewsController = Get.put(ReviewsController());
  double _rating = 0.0; // Default rating

  @override
  Widget build(BuildContext context) {
    // Print product details for debugging
    print('Product Details:');
    product.forEach((key, value) {
      print('$key: $value');
    });

    // Ensure non-null values for required fields
    final String productId = product['id'] ?? '';
    final String productTitle = product['title'] ?? '';
    final String productImg = product['img'] ?? '';
    final double productPrice = (product['price'] ?? 0).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text("Write Review")
            .text
            .size(26)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 85,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
          child: tapButton(
            color: primaryApp,
            onPress: () {
              String reviewText = _reviewController.text;
              print('Review Text: $reviewText'); // Debugging print
              print('Rating: $_rating'); // Debugging print

              if (reviewText.isNotEmpty && _rating > 0 && productId.isNotEmpty) {
                reviewsController.submitReview(
                  productId,
                  productTitle,
                  productImg,
                  productPrice,
                  reviewText,
                  _rating,
                );
              } else {
                // Determine the missing information
                String errorMessage = 'Please provide the following information:\n';
                if (reviewText.isEmpty) errorMessage += '- Write a review\n';
                if (_rating <= 0) errorMessage += '- Provide a rating\n';
                if (productId.isEmpty) errorMessage += '- Product ID\n';

                // Print missing information for debugging
                print(errorMessage);

                // แสดงข้อความแจ้งเตือนเมื่อกรอกข้อมูลไม่ครบ
                Get.snackbar(
                  'Error',
                  errorMessage,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            textColor: whiteColor,
            title: "Submit Review",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productTitle,
              style: TextStyle(fontFamily: medium, fontSize: 18),
            ),
            SizedBox(height: 10),
            Image.network(productImg, width: 100, height: 100, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(
              '${productPrice} Bath',
              style: TextStyle(color: greyDark),
            ),
            SizedBox(height: 10),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _rating = rating;
                print('Rating Updated: $_rating'); // Debugging print
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                labelText: 'Write your review',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
