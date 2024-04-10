import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/consts.dart';

class OrderDetailFont extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: "My Order"
                .text
                .color(fontGreyDark2)
                .fontFamily(medium)
                .size(24)
                .make(),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            bottom: const TabBar(
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
              const Center(
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
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(16.0),
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
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // โค้ดสำหรับฟังก์ชันการเขียนรีวิว
            },
            child: const Text('Write product review'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ),
        const SizedBox(height: 20),
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Quantity: $quantity',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                ),
                Text(
                  price,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
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
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(16.0),
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
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // Implement the review writing functionality here
            },
            child: const Text('Write product review'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
