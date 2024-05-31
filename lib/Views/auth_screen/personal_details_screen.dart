import 'package:flutter/cupertino.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:get/get.dart';
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
  var controller = Get.put(AuthController());
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  bool isSelectable = true;

  DateTime selectedDate = DateTime.now();

  String? selectedGender;
  Color? selectedSkinTone;
  bool canSelectSkin = true;

  void showDatePicker() {
  showCupertinoModalPopup(
    context: context,
    builder: (_) => Container(
      height: 390, 
      color: whiteColor,
      child: Column(
        children: [
          Container(
            height: 300, 
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
            child: const Text('OK')
                .text
                .color(primaryApp)
                .fontFamily(medium)
                .size(20)
                .make(),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ),
  );
}


  final List<Color> skinTones = [
    Color.fromRGBO(255, 231, 218, 1),
    Color.fromRGBO(229, 202, 176, 1),
    Color.fromRGBO(185, 135, 98, 1),
    Color.fromRGBO(116, 78, 60, 1),
  ];

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: whiteColor,
    appBar: AppBar(),
    bottomNavigationBar: SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
        child: tapButton(
          color: selectedDate != null &&
                  selectedGender != null &&
                  heightController.text.isNotEmpty &&
                  weightController.text.isNotEmpty &&
                  selectedSkinTone != null
              ? primaryApp
              : greyThin,
          title: 'Done',
          textColor: selectedDate != null &&
                  selectedGender != null &&
                  heightController.text.isNotEmpty &&
                  weightController.text.isNotEmpty &&
                  selectedSkinTone != null
              ? whiteColor
              : greyDark,
          onPress: () async {
            if (selectedDate == null) {
              VxToast.show(context, msg: 'Please select your birthday');
            } else if (selectedGender == null) {
              VxToast.show(context, msg: 'Please select your gender');
            } else if (heightController.text.isEmpty ||
                weightController.text.isEmpty) {
              VxToast.show(context, msg: 'Please tap your height and weight');
            } else if (selectedSkinTone == null) {
              VxToast.show(context, msg: 'Please select your skin color');
            } else {
              await controller.saveUserData(
                name: widget.name,
                email: widget.email,
                password: widget.password,
                birthday: selectedDate,
                gender: selectedGender!,
                uHeight: heightController.text,
                uWeight: weightController.text,
                skin: selectedSkinTone!,
              );
            }
          },
        ),
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text('Let\'s create your information!')
              .text
              .fontFamily(bold)
              .size(32)
              .make(),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.topLeft,
            child: const Text('Birthday')
                .text
                .size(16)
                .fontFamily(regular)
                .color(greyDark)
                .make(),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: showDatePicker,
            child: AbsorbPointer(
              child: customTextField(
                controller: TextEditingController(
                    text: DateFormat('EEEE, MMMM d, yyyy')
                        .format(selectedDate)),
                isPass: false,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.topLeft,
            child: const Text('Gender')
                .text
                .size(16)
                .fontFamily(regular)
                .color(greyDark)
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
                      left: idx != 0 ? 13 : 0, right: idx != 2 ? 6 : 0),
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
                          size: 24,
                        ),
                        Text(
                          gender,
                          style: TextStyle(
                            fontFamily: regular,
                            fontSize: 14,
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
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: selectedGender == gender
                                  ? primaryApp
                                  : greyLine),
                        ),
                      ),
                      elevation: MaterialStateProperty.all<double>(0),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            vertical: 10),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.topLeft,
            child: const Text('Shape')
                .text
                .size(16)
                .fontFamily(regular)
                .color(greyDark)
                .make(),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: customTextField(
                    label: 'Height',
                    controller: heightController,
                    isPass: false,
                    readOnly: false,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: customTextField(
                    label: 'Weight',
                    controller: weightController,
                    isPass: false,
                    readOnly: false,
                  ),
                ),
              ),
              const SizedBox(width: 90),
            ],
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.topLeft,
            child: const Text('Skin')
                .text
                .size(16)
                .fontFamily(regular)
                .color(greyDark)
                .make(),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start, 
                children: skinTones.map((tone) {
                  return Row(
                    children: [
                      GestureDetector(
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
                          width: 47,
                          height: 47,
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}