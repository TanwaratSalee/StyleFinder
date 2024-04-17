import 'dart:convert'; // แก้ไขบรรทัดนี้
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // เพิ่มเข้ามาเพื่อใช้งาน Material widgets
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  var controller = Get.find<CartController>();
  String? _selectedBank;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> banks = [
      {'name': 'KBANK', 'icon': Icons.account_balance},
      {'name': 'SCB', 'icon': Icons.account_balance_wallet},
      // ต่อไปนี้เพิ่มข้อมูลธนาคารตามที่คุณมี
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Banking'),
        leading: BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: banks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(banks[index]['icon']),
                  title: Text(banks[index]['name']),
                  trailing: _selectedBank == banks[index]['name']
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedBank = banks[index]['name'];
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _selectedBank != null
                  ? () {
                      // ทำการดำเนินการยืนยันเมื่อมีธนาคารถูกเลือก
                    }
                  : null,
              child: Text('Confirm'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor, // สีของปุ่ม
                minimumSize: Size(double.infinity, 50), // ขนาดของปุ่ม
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // มุมโค้งของปุ่ม
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
