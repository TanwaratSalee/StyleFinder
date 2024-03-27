import 'package:flutter/material.dart';


class OrderDetailFont extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'My Order',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Delivery'),
                Tab(text: 'Done'),
                Tab(text: 'Order History'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              DeliveryContentPage(), // Placeholder for actual content
              DoneContentPage(), // Content for Done tab
              Center(
                  child: Text(
                      'Order History Content')), // Placeholder for actual content
            ],
          ),
        ),
      ),
    );
  }
}

class DeliveryContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ตัวอย่างรายการสินค้าสำหรับหน้า Delivery
    final deliveryItems = [
      {
        'title': 'Macrocanage Jacket',
        'price': '130,000.00 Bath',
        'quantity': 'x1',
        'image': 'assets/jacket.png',
      },
      {
        'title': 'Skort',
        'price': '67,000.00 Bath',
        'quantity': 'x1',
        'image': 'assets/skort.png',
      },
      {
        'title': 'Asymmetric Shirt',
        'price': '72,000.00 Bath',
        'quantity': 'x1',
        'image': 'assets/shirt.png',
      },
    ];

    return ListView(
      children: <Widget>[
        ...deliveryItems
            .map((item) => ItemTile(
                  title: item['title']!,
                  price: item['price']!,
                  quantity: item['quantity']!,
                  imageAssetPath: item['image']!,
                ))
            .toList(),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text(
                '269,000.00 Bath', // อัพเดทราคารวมตามข้อมูลจริงของคุณ
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // โค้ดสำหรับฟังก์ชันการเขียนรีวิว
            },
            child: Text('Write product review'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class ItemTile extends StatelessWidget {
  final String title;
  final String price;
  final String quantity;
  final String imageAssetPath;

  const ItemTile({
    Key? key,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageAssetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            imageAssetPath,
            width: 100,
            height: 100,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Quantity: $quantity',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                ),
                Text(
                  price,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DoneContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final doneItems = [
      {
        'title': 'Macrocanage Jacket',
        'price': '130,000.00 Bath',
        'quantity': 'x1',
        'image': 'assets/jacket.png',
      },
      {
        'title': 'Skort',
        'price': '67,000.00 Bath',
        'quantity': 'x1',
        'image': 'assets/skort.png',
      },
      {
        'title': 'Asymmetric Shirt',
        'price': '72,000.00 Bath',
        'quantity': 'x1',
        'image': 'assets/shirt.png',
      },
    ];

    return ListView(
      children: <Widget>[
        ...doneItems
            .map((item) => ItemTile(
                  title: item['title']!,
                  price: item['price']!,
                  quantity: item['quantity']!,
                  imageAssetPath: item['image']!,
                ))
            .toList(),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text(
                '269,000.00 Bath',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // Implement the review writing functionality here
            },
            child: Text('Write product review'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
