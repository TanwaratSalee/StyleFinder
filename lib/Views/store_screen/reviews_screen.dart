import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:intl/intl.dart';

class ReviewScreen extends StatefulWidget {
  final String productId;

  const ReviewScreen({Key? key, required this.productId}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reviews')
            .where('product_id', isEqualTo: widget.productId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var reviews = snapshot.data!.docs;
          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              var review = reviews[index];
              var timestamp = review['review_date'] as Timestamp;
              var date = DateFormat('yyyy-MM-dd').format(timestamp.toDate());
              var rating = review['rating'] is double
                  ? (review['rating'] as double).toInt()
                  : review['rating'] as int;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
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
                    Text(
                      review['review_text'],
                      style: TextStyle(fontSize: 14),
                    ),
                    Divider(),
                  ],
                ),
              );
            },
          );
        },
      ),
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
}
