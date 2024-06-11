import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/consts.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;
  final String postedName;
  final String postedImg;

  const UserProfileScreen({
    required this.userId,
    required this.postedName,
    required this.postedImg,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(postedName),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      postedImg.isNotEmpty
                          ? Image.network(
                              postedImg,
                              height: 150,
                              width: 165,
                              fit: BoxFit.cover,
                            )
                          : SizedBox(height: 150, width: 165, child: Icon(Icons.person, size: 100)),
                      const SizedBox(height: 10),
                      Text(
                        postedName,
                        style: const TextStyle(
                          fontSize: 20,
                          color: blackColor,
                          fontFamily: medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
