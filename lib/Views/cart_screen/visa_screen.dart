import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Visa Card Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: VisaCardScreen(),
    );
  }
}

class VisaCardScreen extends StatefulWidget {
  const VisaCardScreen({Key? key}) : super(key: key);

  @override
  _VisaCardScreenState createState() => _VisaCardScreenState();
}

class _VisaCardScreenState extends State<VisaCardScreen> {
  String cardHolderName = 'Card owner\'s name';
  String cardNumber = '1234 5678 9876 5432';

  void _updateCardHolderName(String newName) {
    setState(() {
      cardHolderName = newName.isNotEmpty
          ? newName[0].toUpperCase() + newName.substring(1)
          : newName;
    });
  }

  void _updateCardNumber(String newNumber) {
    setState(() {
      if (newNumber.length <= 4) {
        cardNumber = 'XXXX XXXX XXXX ' + newNumber.padLeft(4, 'X');
      } else {
        String masked = newNumber
            .substring(0, newNumber.length - 4)
            .replaceAll(RegExp(r'\d'), 'X');
        String visibleDigits = newNumber.substring(newNumber.length - 4);
        cardNumber = masked.padLeft(16, 'X') + visibleDigits;
      }

      cardNumber = cardNumber.replaceAllMapped(
          RegExp(r".{4}"), (match) => "${match.group(0)} ");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Visa Card",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Bold',
            color: Colors.grey[900],
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          _buildCardDetail(),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Name',
            onChanged: (newName) {
              setState(() {
                cardHolderName = newName;
              });
            },
          ),
          SizedBox(height: 8),
          _buildTextField(label: 'Card number'),
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: _buildTextField(label: 'Expiry date')),
              SizedBox(width: 8),
              Expanded(child: _buildTextField(label: 'VCC')),
            ],
          ),
          SizedBox(height: 24),
          ElevatedButton(
            child: Text('Confirm'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetail() {
    return Card(
      elevation: 4,
      child: Container(
        height: 200,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[300]!, Colors.purple[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('VISA',
                style: TextStyle(
                    color: Colors.white, fontSize: 24, fontFamily: 'Bold')),
            Text(cardNumber,
                style: TextStyle(color: Colors.white, fontSize: 21)),
            Text(cardHolderName,
                style: TextStyle(
                    color: Colors.white, fontSize: 18, fontFamily: 'Regular')),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, Function(String)? onChanged}) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
      onChanged: onChanged,
    );
  }
}
