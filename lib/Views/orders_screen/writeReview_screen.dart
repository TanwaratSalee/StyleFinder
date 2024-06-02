import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WriteReviewScreen extends StatefulWidget {
  final List<dynamic> products;

  const WriteReviewScreen({Key? key, required this.products}) : super(key: key);

  @override
  _WriteReviewScreenState createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final List<TextEditingController> _reviewControllers = [];
  final List<double> _ratings = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.products.length; i++) {
      _reviewControllers.add(TextEditingController());
      _ratings.add(0.0);
    }
  }

  @override
  void dispose() {
    for (var controller in _reviewControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> submitReview(Map<String, dynamic> reviewData) async {
    await FirebaseFirestore.instance.collection('reviews').add(reviewData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write Review').text.fontFamily('semiBold').size(24).make(),
      ),
      body: ListView.builder(
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          var product = widget.products[index];
          return Card(
  margin: EdgeInsets.all(10),
  child: Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.network(product['img'], width: 70, height: 70),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                product['title'],
                style: TextStyle(fontFamily: medium, fontSize: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _ratings[index] = rating;
            });
          },
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _reviewControllers[index],
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Write your review here',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            var currentUser = FirebaseAuth.instance.currentUser;

            if (currentUser != null) {
              var reviewData = {
                'product_id': product['product_id'],  // Ensure product_id is not null
                'product_title': product['title'],
                'product_img': product['img'],
                'rating': _ratings[index],
                'review': _reviewControllers[index].text,
                'review_date': DateTime.now(),
                'user_id': currentUser.uid,
                'user_name': currentUser.displayName ?? 'Anonymous',
                'user_img': currentUser.photoURL ?? 'default_user_image_url',
              };

              await submitReview(reviewData);

              Get.snackbar('Review Submitted', 'Thank you for your feedback!',
                  snackPosition: SnackPosition.BOTTOM);

              setState(() {
                _ratings[index] = 0.0;
                _reviewControllers[index].clear();
              });
            } else {
              Get.snackbar('Error', 'You need to be logged in to submit a review',
                  snackPosition: SnackPosition.BOTTOM);
            }
          },
          child: Text('Submit Review'),
        ),
      ],
    ),
  ),
);
},
      ),
    );
  }
}
