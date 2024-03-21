import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DetailUserScreen extends StatefulWidget {
  @override
  _DetailUserScreenState createState() => _DetailUserScreenState();
}

class _DetailUserScreenState extends State<DetailUserScreen> {
  var controller = Get.put(AuthController());

  var userHeightController = TextEditingController();
  var userWeightController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedSex = 'Man';

  final List<Color> skinTones = [
    Color.fromRGBO(233, 228, 222, 1), // Light skin tone
    Color.fromRGBO(251, 211, 159, 1), // Medium-light skin tone
    Color.fromRGBO(185, 135, 98, 1), // Medium skin tone
    Color.fromRGBO(116, 78, 60, 1), // Dark skin tone
  ];
  late Color selectedSkinTone; // Declare as late

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('en_US', null);
    selectedSkinTone = skinTones[0]; // Initialize here
  }

  void _showDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
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
                        }),
                  ),
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  )
                ],
              ),
            ));
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('EEEE, MMMM d, yyyy', 'en_US');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Create Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 25),
            Text(
              'Select your birthday',
              style: TextStyle(
                  fontSize: 16, color: Colors.black, fontFamily: regular),
            ),
            SizedBox(height: 5),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color:
                      bgGreylight, // Use the actual color code or variable here for light grey
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CupertinoButton(
                  onPressed: () => _showDatePicker(context),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          _formatDate(selectedDate),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        SizedBox(width: 70), // Space between the text and icon
                        Icon(
                          Icons.calendar_today,
                          size: 24.0,
                          color: fontGreyDark,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Sex',
              style: TextStyle(
                  fontSize: 16, color: Colors.black, fontFamily: regular),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize:
                  MainAxisSize.max, // Row takes up all the horizontal space
              children: <String>['Man', 'Woman', 'Other']
                  .asMap()
                  .entries
                  .map((entry) {
                int idx = entry.key;
                String sex = entry.value;

                return Flexible(
                  fit: FlexFit.tight, // Each child fills the available space
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: idx != 0 ? 6.0 : 0,
                        right: idx != 2
                            ? 6.0
                            : 0), // Add spacing on the left and right except for the first and last item
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedSex = sex;
                        });
                      },
                      child: Text(
                        sex,
                        style: TextStyle(
                          fontFamily: regular,
                          fontSize: 16,
                          color: selectedSex == sex ? primaryApp : Colors.grey,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            selectedSex == sex ? thinPrimaryApp : bgGreylight),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            selectedSex == sex ? primaryApp : whiteColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: selectedSex == sex
                                    ? Colors.teal
                                    : Colors.grey),
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 25.0),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Shape',
              style: TextStyle(
                  fontSize: 16, color: Colors.black, fontFamily: regular),
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 20),
                Expanded(
                  // Use Expanded to fill the available horizontal space
                  child: customTextField(
                    label: 'Height',
                    controller: userHeightController,
                    isPass: false,
                    readOnly: false,
                  ),
                ),
                SizedBox(
                    width: 20), // Add horizontal space between the text fields
                Expanded(
                  // Use another Expanded for the second text field
                  child: customTextField(
                    label: 'Weight',
                    controller: userWeightController,
                    isPass: false,
                    readOnly: false,
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),

            SizedBox(height: 20),
            Text(
                    'Skin',
                    style: TextStyle(
                  fontSize: 16, color: Colors.black, fontFamily: regular),
                  ),
                  Column(
              children: [
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: skinTones.map((tone) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSkinTone = tone;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: tone,
                          border: Border.all(
                            color: selectedSkinTone == tone
                                ? primaryApp
                                : Colors
                                    .transparent, // Highlight the selected tone
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: 50, // Width of the color choice
                        height: 50, // Height of the color choice
                      ),
                    );
                  }).toList(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
