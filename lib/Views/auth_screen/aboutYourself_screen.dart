import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';

class AboutYourselScreen extends StatefulWidget {
  const AboutYourselScreen({Key? key}) : super(key: key);

  @override
  _AboutYourselScreenState createState() => _AboutYourselScreenState();
}

class _AboutYourselScreenState extends State<AboutYourselScreen> {
  DateTime dateTime = DateTime.now();
  TextEditingController _birthdateController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _bodyShapeController = TextEditingController();
  List<String> skinColors = ['Light', 'Fair', 'Medium', 'Olive', 'Brown', 'Dark', 'Black'];
  List<String> bodyShapes = ['Slim', 'Athletic', 'Curvy'];
  String? selectedSkinColor;
  String? selectedBodyShape;
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _birthdateController,
              decoration: InputDecoration(
                labelText: 'Birthday',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(
                labelText: 'Gender',
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (String value) {
                    _genderController.text = value;
                    selectedGender = value;
                  },
                  itemBuilder: (BuildContext context) {
                    return ['Male', 'Female', 'Other'].map<PopupMenuItem<String>>((String value) {
                      return PopupMenuItem(child: Text(value), value: value);
                    }).toList();
                  },
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _bodyShapeController,
              decoration: InputDecoration(
                labelText: 'Body Shape',
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (String value) {
                    _bodyShapeController.text = value;
                    selectedBodyShape = value;
                  },
                  itemBuilder: (BuildContext context) {
                    return bodyShapes.map<PopupMenuItem<String>>((String value) {
                      return PopupMenuItem(child: Text(value), value: value);
                    }).toList();
                  },
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skinColors.map((color) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSkinColor = color;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: getColor(color),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedSkinColor == color ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: selectedSkinColor == color ? Icon(
                    Icons.check,
                    color: Colors.white,
                  ) : null,
                ),
              )).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
  onPressed: () {
    _saveUserData();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  },
  child: Text('Done'),
),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != dateTime) {
      setState(() {
        dateTime = picked;
        _birthdateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _saveUserData() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null && selectedGender != null && selectedBodyShape != null && selectedSkinColor != null) {
    DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await userDoc.set({
      'birthday': dateTime,
      'gender': selectedGender,
      'bodyShape': selectedBodyShape,
      'skinColor': selectedSkinColor,
    }, SetOptions(merge: true)).then((_) {
      // ใช้ Navigator.pushReplacementNamed เพื่อนำทางไปยัง LoginScreen
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }).catchError((error) {
      print("Failed to save user data: $error");
    });
  } else {
    print("Incomplete data");
  }
}

  Color getColor(String colorName) {
    switch (colorName) {
      case 'Light':
        return Color(0xFFFFF3E0);
      case 'Fair':
        return Color(0xFFFFE0B2);
      case 'Medium':
        return Color(0xFFFFCC80);
      case 'Olive':
        return Color(0xFFFFB74D);
      case 'Brown':
        return Color(0xFFFFA726);
      case 'Dark':
        return Color(0xFFFF8A65);
      case 'Black':
        return Colors.black;
      default:
        return Colors.grey; // Default color for unmatched cases
    }
  }
}
