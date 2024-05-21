import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/consts.dart';

class WriteReviewScreen extends StatelessWidget {
  final List<dynamic> products;

  const WriteReviewScreen({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Write Review").text.color(whiteColor).make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Review your products",
              style: TextStyle(fontFamily: medium, fontSize: 18),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];
                  return Column(
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
                      SizedBox(height: 20),
                      // Add your review writing widgets here
                      // For example:
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Write your review',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
