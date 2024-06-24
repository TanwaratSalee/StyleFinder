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

  Future<Map<String, String>> getUserDetails(String userId) async {
    if (userId.isEmpty) {
      debugPrint('Error: userId is empty.');
      return {'name': 'Unknown User', 'id': userId, 'imageUrl': ''};
    }

    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>?;
        debugPrint('User data: $userData'); // Debug log
        return {
          'name': userData?['name'] ?? 'Unknown User',
          'id': userId,
          'imageUrl': userData?['imageUrl'] ?? ''
        };
      } else {
        debugPrint('User not found for ID: $userId'); // Debug log
        return {'name': 'Unknown User', 'id': userId, 'imageUrl': ''};
      }
    } catch (e) {
      debugPrint('Error getting user details: $e');
      return {'name': 'Unknown User', 'id': userId, 'imageUrl': ''};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews").text.size(24).fontFamily(semiBold).make(),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Product rating')
                        .text
                        .fontFamily(medium)
                        .size(18)
                        .color(blackColor)
                        .make(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Obx(() {
                          double rating = controller.averageRating.value;
                          return Row(
                            children: [
                              buildCustomRating(rating, 22),
                              5.widthBox,
                              Text('${rating.toStringAsFixed(1)}/5.0')
                            ],
                          );
                        }),
                        Text('($reviewCount reviews)') // Display the count of reviews
                            .text
                            .fontFamily(medium)
                            .size(14)
                            .color(blackColor)
                            .make(),
                      ],
                    )
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
                        .color(greyColor)
                        .make(),
                  );
                }
                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    var review = reviews[index];
                    var reviewData = review.data() as Map<String, dynamic>;
                    var timestamp = reviewData['created_at'] as Timestamp;
                    var date =
                        DateFormat('yyyy-MM-dd').format(timestamp.toDate());
                    var rating = reviewData['rating'] is double
                        ? (reviewData['rating'] as double).toInt()
                        : reviewData['rating'] as int;

                    return FutureBuilder<Map<String, String>>(
                      future: getUserDetails(reviewData['user_id']),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        var userDetails = userSnapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    userDetails['imageUrl'] ??
                                        'https://via.placeholder.com/150', // Placeholder image
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            userDetails['name'] ?? 'Not Found',
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
                                      Row(
                                        children: [
                                          buildStars(rating),
                                          5.widthBox,
                                          Text('${rating.toString()}/5.0')
                                        ],
                                      ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reviewData['review_text'],
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ).box.padding(EdgeInsets.only(left: 55)).make(),
                          ],
                        )
                            .box
                            .padding(EdgeInsets.symmetric(
                                vertical: 14, horizontal: 8))
                            .make();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      )
          .box
          .padding(EdgeInsets.all(12))
          .margin(const EdgeInsets.symmetric(horizontal: 12, vertical: 7))
          .white
          .roundedSM
          .make(),
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
