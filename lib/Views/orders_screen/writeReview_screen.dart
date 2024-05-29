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
    return Scaffold(
      appBar: AppBar(
        title: Text("Write Review").text
            .size(28)
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
              if (_rating == 0.0) {
                VxToast.show(context, msg: "Please provide a rating", position: VxToastPosition.bottom);
              } else {
                reviewsController.saveReview(
                  product,
                  _reviewController.text,
                  _rating,
                );
                VxToast.show(context, msg: "Review submitted successfully", position: VxToastPosition.bottom);
                _reviewController.clear();
                Future.delayed(Duration(seconds: 2), () {
                  Get.back(); // Navigate back to the previous screen
                });
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
              product['title'],
              style: TextStyle(fontFamily: medium, fontSize: 18),
            ),
            SizedBox(height: 10),
            Image.network(product['img'], width: 100, height: 100, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(
              '${product['price']} Bath',
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
