// ignore_for_file: use_super_parameters, library_private_types_in_public_api, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PersonalDetailsScreenGoogle extends StatefulWidget {
  final String email;
  final String name;
  final String password;
  final UserCredential userCredential;

  const PersonalDetailsScreenGoogle({
    Key? key,
    required this.email,
    required this.name,
    required this.password,
    required this.userCredential,
  }) : super(key: key);

  @override
  _PersonalDetailsScreenGoogleState createState() =>
      _PersonalDetailsScreenGoogleState();
}

class _PersonalDetailsScreenGoogleState
    extends State<PersonalDetailsScreenGoogle> {
  var controller = Get.put(AuthController());
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  bool isSelectable = true;

  DateTime selectedDate = DateTime.now();

  String? selectedGender;
  Color? selectedSkinTone;
  bool canSelectSkin = true;

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: whiteColor,
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

  final List<Color> skinTones = [
    const Color(0xFFFFDBAC),
    const Color(0xFFE5A073),
    const Color(0xFFCD8C5C),
    const Color(0xFF5C3836),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
          title: const Text('Personal Details')
              .text
              .fontFamily(medium)
              .size(20)
              .make()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showDatePicker,
              child: AbsorbPointer(
                child: customTextField(
                  label: 'Birthday',
                  controller: TextEditingController(
                      text: DateFormat('EEEE, MMMM d, yyyy')
                          .format(selectedDate)),
                  isPass: false, 
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text('Gender')
                  .text
                  .size(14)
                  .fontFamily(regular)
                  .color(greyDark2)
                  .make(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <String>['Man', 'Woman', 'Other']
                  .asMap()
                  .entries
                  .map((entry) {
                int idx = entry.key;
                String gender = entry.value;

                // สร้าง Icon ตามเพศ
                IconData iconData;
                switch (gender) {
                  case 'Man':
                    iconData = Icons.male;
                    break;
                  case 'Woman':
                    iconData = Icons.female;
                    break;
                  default:
                    iconData = Icons.perm_identity;
                }

                return Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: idx != 0 ? 6.0 : 0, right: idx != 2 ? 6.0 : 0),
                    child: ElevatedButton(
                      onPressed: isSelectable
                          ? () {
                              setState(() {
                                selectedGender = gender;
                              });
                            }
                          : null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            iconData,
                            color: isSelectable && selectedGender == gender
                                ? primaryApp
                                : greyColor,
                            size: 24.0,
                          ),
                          Text(
                            gender,
                            style: TextStyle(
                              fontFamily: regular,
                              fontSize: 16,
                              color: isSelectable && selectedGender == gender
                                  ? primaryApp
                                  : greyColor,
                            ),
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            selectedGender == gender
                                ? thinPrimaryApp
                                : whiteColor),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            selectedGender == gender ? primaryApp : whiteColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: selectedGender == gender
                                    ? Colors.teal
                                    : whiteColor),
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 25.0),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: customTextField(
                      label: 'Height',
                      controller: heightController,
                      isPass: false, 
                      readOnly: false,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: customTextField(
                      label: 'Weight',
                      controller: weightController,
                      isPass: false, 
                      readOnly: false,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Skin',
              style: TextStyle(
                  fontSize: 16, color: blackColor, fontFamily: regular),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: skinTones.map((tone) {
                    return GestureDetector(
                      onTap: () {
                        if (canSelectSkin) {
                          setState(() {
                            selectedSkinTone = tone;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: tone,
                          border: Border.all(
                            color: selectedSkinTone == tone
                                ? primaryApp
                                : Colors.transparent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: 50,
                        height: 50,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // สมมติว่านี่คือส่วนของโค้ดที่ตั้งค่าปุ่ม "Done"
            ourButton(
              title: 'Done',
              onPress: () async {
                print("Selected is: $selectedDate");

                print("Selected is: $selectedGender");
                // print("Selected height is: ${heightController.text}");
                // print("Selected weight is: ${weightController.text}");
                // print("Selected is: $selectedSkinTone");

                await controller.saveUserDataGoogle(
                  currentUser: widget.userCredential,
                  name: widget.name,
                  birthday: selectedDate,
                  gender: selectedGender!,
                  uHeight: heightController.text,
                  uWeight: weightController.text,
                  skin: selectedSkinTone!,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
