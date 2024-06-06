import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReviewScreen extends StatefulWidget {
  final String productId;

  const ReviewScreen({Key? key, required this.productId}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late final ProductController controller;
  int reviewCount = 0;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductController());
    fetchReviewCount();
    controller.loadProductReviews(widget.productId);
  }

  void fetchReviewCount() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('product_id', isEqualTo: widget.productId)
          .get();

      setState(() {
        reviewCount = querySnapshot.docs.length; // Update the review count
      });
    } catch (e) {
      print("Error fetching review count: $e");
      setState(() {
        reviewCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Product rating')
                        .text
                        .fontFamily(medium)
                        .size(18)
                        .color(blackColor)
                        .make(),
                    Obx(() {
                      double rating = controller.averageRating.value;
                      return buildCustomRating(rating, 20);
                    }),
                    Text('Total Reviews: $reviewCount') // Display the count of reviews
                        .text
                        .fontFamily(medium)
                        .size(16)
                        .color(blackColor)
                        .make(),
                  ],
                ),
              ),
            ],
          ).box.padding(EdgeInsets.symmetric(vertical: 5)).make(),
          Divider(color: greyThin),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reviews')
                  .where('product_id', isEqualTo: widget.productId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var reviews = snapshot.data!.docs;
                if (reviews.isEmpty) {
                  return Center(
                    child: Text('The product has not been reviewed yet.')
                        .text
                        .size(16)
                        .color(Colors.grey)
                        .make(),
                  );
                }
                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    var review = reviews[index];
                    var timestamp = review['review_date'] as Timestamp;
                    var date = DateFormat('yyyy-MM-dd').format(timestamp.toDate());
                    var rating = review['rating'] is double
                        ? (review['rating'] as double).toInt()
                        : review['rating'] as int;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(review['user_img']),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        review['user_name'],
                                        style: TextStyle(
                                          fontFamily: semiBold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        date,
                                        style: TextStyle(
                                          color: greyColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  buildStars(rating),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review['review_text'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).box.padding(EdgeInsets.only(left: 55)).make(),
                      ],
                    ).box.padding(EdgeInsets.symmetric(vertical: 14, horizontal: 8)).make();
                  },
                );
              },
            ),
          ),
        ],
      ).box.padding(EdgeInsets.all(12)).margin(const EdgeInsets.symmetric(horizontal: 12, vertical: 7)).white.roundedSM.make(),
    );
  }

  Widget buildStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.yellow,
          size: 16,
        );
      }),
    );
  }

  Widget buildCustomRating(double rating, double size) {
    int filledStars = rating.floor();
    bool hasHalfStar = rating - filledStars > 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < filledStars) {
          return Icon(Icons.star, color: Colors.yellow, size: size);
        } else if (index == filledStars && hasHalfStar) {
          return Icon(Icons.star_half, color: Colors.yellow, size: size);
        } else {
          return Icon(Icons.star_border, color: Colors.yellow, size: size);
        }
      }),
    );
  }
}
