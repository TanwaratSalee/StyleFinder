// ignore_for_file: use_build_context_synchronously, use_super_parameters, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../widgets_common/edit_textfield.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;

  const EditProfileScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    controller.nameController.text = data['name'];
    controller.emailController.text = data['email'];
    controller.heightController.text = data['height'];
    controller.weightController.text = data['weight'];
    controller.birthdayController.text = data['birthday'];
    controller.sexController.text = data['sex'];

    DateTime selectedDate =
        DateFormat('EEEE, dd/MM/yyyy').parse(data['birthday']);

    String dateString = data['birthday'];
    List<String> dateParts = dateString.split(', ');
    String formattedDateString = dateParts[1];
    DateTime initialBirthday =
        DateFormat('dd/MM/yyyy').parse(formattedDateString);

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
                    selectedDate = val;
                    // Update the birthdayController with the new date
                    controller.birthdayController.text =
                        DateFormat('EEEE, dd/MM/yyyy').format(val);
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('OK'),
                onPressed: () {
                  // Force UI update if necessary
                  controller.birthdayController.text =
                      DateFormat('EEEE, dd/MM/yyyy').format(selectedDate);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    }

    void _showGenderPicker(BuildContext context) {
      final controller = Get.find<
          ProfileController>(); // Ensure you have access to the controller
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Obx(() => Wrap(
                  // Use Obx to rebuild when selectedGender changes
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.male,
                        color: controller.selectedGender.value == 'Man'
                            ? primaryApp
                            : fontGrey,
                      ),
                      title: Text(
                        'Man',
                        style: TextStyle(
                          color: controller.selectedGender.value == 'Man'
                              ? primaryApp
                              : fontGrey,
                          fontWeight: controller.selectedGender.value == 'Man'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        controller.selectGender('Man');
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.female,
                        color: controller.selectedGender.value == 'Woman'
                            ? primaryApp
                            : fontGrey,
                      ),
                      title: Text(
                        'Woman',
                        style: TextStyle(
                          color: controller.selectedGender.value == 'Woman'
                              ? primaryApp
                              : fontGrey,
                          fontWeight: controller.selectedGender.value == 'Woman'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        controller.selectGender('Woman');
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.perm_identity,
                        color: controller.selectedGender.value == 'Other'
                            ? primaryApp
                            : fontGrey,
                      ),
                      title: Text(
                        'Other',
                        style: TextStyle(
                          color: controller.selectedGender.value == 'Other'
                              ? primaryApp
                              : fontGrey,
                          fontWeight: controller.selectedGender.value == 'Other'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        controller.selectGender('Other');
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )),
          );
        },
      );
    }

    // controller.old Controller.text = data['pass'];

    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title:
            "Edit Profile".text.fontFamily(regular).color(fontGreyDark).make(),
        actions: [
          TextButton(
            onPressed: () async {
              if (!controller.isloading.isTrue) {
                controller.isloading(true);

                String? imgUrl;
                if (controller.profileImgPath.value.isNotEmpty) {
                  await controller.uploadProfileImage();
                  imgUrl = controller.profileImageLink;
                }

                // ตรวจสอบว่าคุณได้รวมวันเกิดในการเรียกเมธอด updateProfile
                await controller.updateProfile(
                  name: controller.nameController.text,
                  height: controller.heightController.text,
                  weight: controller.weightController.text,
                  imgUrl: imgUrl,
                  birthday: controller.birthdayController.text,
                  sex: controller.sexController.text,
                );

                controller.isloading(false);
                Navigator.pop(context);
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Profile Updated Successfully")),
                  );
                });
              }
            },
            child: "Save"
                .text
                .color(primaryApp)
                .fontFamily(regular)
                .size(18)
                .make(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //if data image url and contoller path is empty
              data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                  ? Image.asset(
                      imProfile,
                      width: 100,
                      fit: BoxFit.cover,
                    ).box.roundedFull.clip(Clip.antiAlias).make()
                  // if data is not empty but controller path is empty
                  : data['imageUrl'] != '' && controller.profileImgPath.isEmpty
                      ? Image.network(
                          data['imageUrl'],
                          width: 130,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make()
                      //if both are emtpy
                      : Image.file(
                          File(controller.profileImgPath.value),
                          width: 130,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
              // Image.asset(imProfile, width: 150,).box.roundedFull.clip(Clip.antiAlias).make(),

              10.heightBox,
              SizedBox(
                  width: context.screenWidth - 260,
                  height: context.screenWidth - 360,
                  child: ourButton(
                      color: whiteColor,
                      onPress: () {
                        controller.changeImage(context);
                      },
                      textColor: primaryApp,
                      title: "Edit Picture")),

              10.heightBox,

              20.heightBox,
              Align(
                alignment: Alignment.centerLeft,
                child: const Text('About account')
                    .text
                    .size(16)
                    .fontFamily(medium)
                    .color(fontBlack)
                    .make(),
              ),
              const Divider(
                color: fontLightGrey,
              ),
              5.heightBox,

              editTextField(
                controller: controller.nameController,
                label: fullname,
                isPass: false,
                readOnly: false,
              ),
              editTextField(
                  controller: controller.emailController,
                  label: email,
                  isPass: false,
                  readOnly: true),
              20.heightBox,

              Align(
                alignment: Alignment.centerLeft,
                child: const Text('About you')
                    .text
                    .size(16)
                    .fontFamily(medium)
                    .color(fontBlack)
                    .make(),
              ),
              const Divider(
                color: fontLightGrey,
              ),
              10.heightBox,

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Birthday',
                    style: TextStyle(
                      color: fontBlack,
                      fontSize: 14,
                      fontFamily: 'Regular',
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: controller.birthdayController,
                      onTap: _showDatePicker,
                      decoration: const InputDecoration(
                        hintText: 'Select birthday',
                        hintStyle: TextStyle(
                          color: fontGrey,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: whiteColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: greyColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Gender',
                    style: TextStyle(
                      color: fontBlack,
                      fontSize: 14,
                      fontFamily: 'Regular',
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => _showGenderPicker(context),
                      child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Obx(
                          () => Text(
                            controller.selectedGender.value.isEmpty
                                ? 'Select Gender'
                                : controller.selectedGender.value,
                            style: TextStyle(
                              color: controller.selectedGender.value.isEmpty
                                  ? fontBlack
                                  : fontGrey,
                              fontFamily: regular,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              editTextField(
                controller: controller.heightController,
                label: 'Height',
                isPass: false,
                readOnly: false,
              ),

              editTextField(
                  controller: controller.weightController,
                  label: 'Weight',
                  isPass: false,
                  readOnly: true),
            ],
          ).paddingAll(16),
        ),
      ),
    );
  }
}
