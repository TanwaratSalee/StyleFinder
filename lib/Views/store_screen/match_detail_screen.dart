import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatchDetailScreen extends StatefulWidget {
  final String productName1;
  final String productName2;
  final String price1;
  final String price2;
  final String productImage1;
  final String productImage2;
  final String totalPrice;

  const MatchDetailScreen({
    this.productName1 = '',
    this.productName2 = '',
    this.price1 = '',
    this.price2 = '',
    this.productImage1 = '',
    this.productImage2 = '',
    this.totalPrice = '',
  });

  @override
  _MatchDetailScreenState createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Match Detail'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Icon(
                  Icons.favorite_border,
                  color: Colors.black,
                  size: 30,
                ),
                Positioned(
                  child: Icon(
                    Icons.favorite,
                    color: isFavorited ? Colors.red : Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
            onPressed: () {
              setState(() {
                isFavorited = !isFavorited;
              });
            },
          ),
        ],
      ),
      
      body: Column(
        children: <Widget>[
          Expanded(child:
          SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
              child: Column(
                
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                            ),
                            child: Center(
                              child: Image.network(
                                widget.productImage1,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(widget.productName1,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('฿${widget.price1}',
                              style: TextStyle(fontSize: 14, color: Colors.black)),
                        ],
                      ),
                      SizedBox(width: 10), // สร้างระยะห่าง
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 20, // ขนาดของวงกลม
                            height: 20, // ขนาดของวงกลม
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[100], // สีฟ้าอ่อน
                              shape: BoxShape.circle, // ทำให้เป็นรูปวงกลม
                            ),
                          ),
                          Text('+',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                      SizedBox(width: 10),
                       // สร้างระยะห่าง
                      // สำหรับรูปภาพที่สองและข้อมูล
                      Column(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                            ),
                            child: Center(
                              child: Image.network(
                              widget.productImage2,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(widget.productName2,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('฿${widget.price2}',
                              style: TextStyle(fontSize: 14, color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30), // เพิ่มระยะห่าง
                  Container(
                    height: 65,
                    margin: EdgeInsets.only(
                        bottom: 10), // ขยับ widget bar จากด้านบนลงมา
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue[100],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text('Dior',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Dior',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow, size: 20),
                                Icon(Icons.star, color: Colors.yellow, size: 20),
                                Icon(Icons.star, color: Colors.yellow, size: 20),
                                Icon(Icons.star, color: Colors.yellow, size: 20),
                                Icon(Icons.star, color: Colors.yellow, size: 20),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              // ทำสิ่งที่ต้องการเมื่อกดปุ่ม
                            },
                            child: Text('See Store'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white!),
                                  minimumSize: MaterialStateProperty.all<Size>(Size(0, 30)),
                            )),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(height: 0.5),
                   // เพิ่มระยะห่าง
                   
                  Padding(
                    padding: EdgeInsets.fromLTRB(0,0, 250, 0),
                    child: Text(
                      'Opportunity for',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12,),
                    ),
                  ),
                  
                  Row(children: [
                    ElevatedButton(
                      onPressed: () {
                        // ทำสิ่งที่ต้องการเมื่อกดปุ่ม
                      },
                      child: Text('Everyday',style: TextStyle(
      fontSize: 13, 
    ),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey[100]!),
                            minimumSize: MaterialStateProperty.all<Size>(Size(20, 20)),
                            padding: MaterialStateProperty.all<EdgeInsets>(
      EdgeInsets.symmetric(horizontal: 10, vertical: 5), // ปรับระยะห่างภายในปุ่ม
    ),
    textStyle: MaterialStateProperty.all<TextStyle>(
      TextStyle(
        fontSize: 13, // ตั้งค่าขนาดตัวอักษรของข้อความภายในปุ่ม
      ),
    ),
                      ),
                    ), SizedBox(width: 3),
                    ElevatedButton(
                      onPressed: () {
                        // ทำสิ่งที่ต้องการเมื่อกดปุ่ม
                      },
                      child: Text('Dating',style: TextStyle(
      fontSize: 13, 
    ),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey[100]!),
                            minimumSize: MaterialStateProperty.all<Size>(Size(20, 20)),
                             padding: MaterialStateProperty.all<EdgeInsets>(
      EdgeInsets.symmetric(horizontal: 10, vertical: 5), // ปรับระยะห่างภายในปุ่ม
    ),
    textStyle: MaterialStateProperty.all<TextStyle>(
      TextStyle(
        fontSize: 13, // ตั้งค่าขนาดตัวอักษรของข้อความภายในปุ่ม
      ),
    ),
                      ),
                    ), SizedBox(width: 3),
                    
                    ElevatedButton(
                      onPressed: () {
                        // ทำสิ่งที่ต้องการเมื่อกดปุ่ม
                      },
                      child: Text('Seminars ',style: TextStyle(
      fontSize: 13, 
    ),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey[100]!),
                            minimumSize: MaterialStateProperty.all<Size>(Size(20, 20)),
                             padding: MaterialStateProperty.all<EdgeInsets>(
      EdgeInsets.symmetric(horizontal: 10, vertical: 5), // ปรับระยะห่างภายในปุ่ม
    ),
    textStyle: MaterialStateProperty.all<TextStyle>(
      TextStyle(
        fontSize: 13, // ตั้งค่าขนาดตัวอักษรของข้อความภายในปุ่ม
      ),
    ),
                      ),
                    ), 

                   ]
                   ),SizedBox(height: 10,),
                   Padding(
  padding: const EdgeInsets.all(10),
  child: Container(
    width: double.infinity, // ทำให้ container กว้างเต็มขอบ
    height: 150, // กำหนดความสูง
    decoration: BoxDecoration(
      color: Colors.grey[200], // ตั้งค่าสีพื้นหลัง
      borderRadius: BorderRadius.circular(10), // มุมโค้ง
    ),
    child: Align(
      alignment: Alignment.topLeft, // จัดตำแหน่งข้อความชิดซ้ายบน
      child: Padding(
        padding: const EdgeInsets.all(8.0), // เพิ่ม padding ให้ข้อความ
        child: Text(
          'HEllo ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 11,
          ),
        ),
      ),
    ),
  ),
)
                ],
                
              ),
              
            ),
          ),
          ),
        ],
      ),
      
    );
    
  }
}
