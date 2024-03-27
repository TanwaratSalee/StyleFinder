import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_finalproject/Views/home_screen/navigationBar.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:intl/intl.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final String email;
  final String name;
  final String password;

  const PersonalDetailsScreen({
    Key? key,
    required this.email,
    required this.name,
    required this.password,
  }) : super(key: key);

  @override
  _PersonalDetailsScreenState createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedSex;
  Color? selectedSkinTone;

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 200,
              child: CupertinoDatePicker(
                initialDateTime: selectedDate,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (val) {
                  setState(() {
                    selectedDate = val;
                  });
                },
              ),
            ),
            CupertinoButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  // Provide the actual colors for your skin tones.
  final List<Color> skinTones = [
    Color(0xFFFFDBAC),
    Color(0xFFEDB98A),
    Color(0xFFE5A073),
    Color(0xFFCD8C5C),
    Color(0xFFAD6452),
    Color(0xFF5C3836),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // Birthday picker
            GestureDetector(
              onTap: _showDatePicker,
              child: AbsorbPointer(
                child: customTextField(
                  label: 'Birthday',
                  controller: TextEditingController(
                      text: DateFormat('EEEE, MMMM d, yyyy').format(selectedDate)),
                  isPass: false,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Sex selection
            // ... Your sex selection widget here ...
            SizedBox(height: 20),
            // Shape input fields (Height & Weight)
            // ... Your height & weight input fields here ...
            SizedBox(height: 20),
            // Skin tone selection
            // ... Your skin tone selection widget here ...
            SizedBox(height: 20),
            ourButton(
              title: 'Done',
              onPress: () {
                // Implement your signup logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}
