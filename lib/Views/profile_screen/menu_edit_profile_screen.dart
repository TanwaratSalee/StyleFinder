import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
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
    controller.genderController.text = data['gender'];

    if (data['gender'] != null) {
      controller.selectGender(data['gender']);
      controller.genderController.text = data['gender'];
    } else {
      controller.selectGender('');
    }

    DateTime selectedDate =
        DateFormat('EEEE, dd/MM/yyyy').parse(data['birthday']);

    String dateString = data['birthday'];
    List<String> dateParts = dateString.split(', ');
    String formattedDateString = dateParts[1];
    DateTime initialBirthday =
        DateFormat('dd/MM/yyyy').parse(formattedDateString);

    void showDatePicker() {
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
                    selectedDate = val;
                    controller.birthdayController.text =
                        DateFormat('EEEE, dd/MM/yyyy', 'en').format(val);
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('OK')
                    .text
                    .color(primaryApp)
                    .fontFamily(medium)
                    .make(),
                onPressed: () {
                  controller.birthdayController.text =
                      DateFormat('EEEE, dd/MM/yyyy', 'en').format(selectedDate);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    }

    void showGenderPicker(BuildContext context) {
      final controller = Get.find<ProfileController>();
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Obx(() => Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.male,
                        color: controller.selectedGender.value == 'Man'
                            ? primaryApp
                            : greyDark,
                      ),
                      title: Text(
                        'Man',
                        style: TextStyle(
                          color: controller.selectedGender.value == 'Man'
                              ? primaryApp
                              : greyDark,
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
                            : greyDark,
                      ),
                      title: Text(
                        'Woman',
                        style: TextStyle(
                          color: controller.selectedGender.value == 'Woman'
                              ? primaryApp
                              : greyDark,
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
                            : greyDark,
                      ),
                      title: Text(
                        'Other',
                        style: TextStyle(
                          color: controller.selectedGender.value == 'Other'
                              ? primaryApp
                              : greyDark,
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

    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: "Edit Profile"
            .text
            .size(24)
            .fontFamily(medium)
            .color(greyDark)
            .make(),
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

                await controller.updateProfile(
                  name: controller.nameController.text,
                  height: controller.heightController.text,
                  weight: controller.weightController.text,
                  imgUrl: imgUrl,
                  birthday: controller.birthdayController.text,
                  gender: controller.genderController.text,
                );

                controller.isloading(false);
                Navigator.pop(context);
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  VxToast.show(
                    context,
                    msg: 'Profile Updated Successfully',
                  );
                });
              }
            },
            child:
                "Save".text.color(greyDark).fontFamily(medium).size(16).make(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    child: data['imageUrl'] == '' &&
                            controller.profileImgPath.isEmpty
                        ? Image.asset(
                            'assets/profile.png',
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make()
                        : data['imageUrl'] != '' &&
                                controller.profileImgPath.isEmpty
                            ? Image.network(
                                data['imageUrl'],
                                width: 130,
                                height: 130,
                                fit: BoxFit.cover,
                              ).box.roundedFull.clip(Clip.antiAlias).make()
                            : Image.file(
                                File(controller.profileImgPath.value),
                                width: 130,
                                height: 130,
                                fit: BoxFit.cover,
                              ).box.roundedFull.clip(Clip.antiAlias).make(),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        controller.changeImage(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryApp,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.edit,
                          color: whiteColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              20.heightBox,
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(aboutaccount)
                    .text
                    .size(16)
                    .fontFamily(medium)
                    .color(blackColor)
                    .make(),
              ),
              const Divider(
                color: greyThin,
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
                child: const Text(aboutyou)
                    .text
                    .size(16)
                    .fontFamily(medium)
                    .color(blackColor)
                    .make(),
              ),
              const Divider(
                color: greyThin,
              ),
              10.heightBox,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Birthday',
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 14,
                      fontFamily: regular,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: controller.birthdayController,
                      onTap: showDatePicker,
                      decoration: const InputDecoration(
                        hintText: 'Select birthday',
                        hintStyle: TextStyle(
                          color: greyDark,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Gender',
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 14,
                      fontFamily: regular,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => showGenderPicker(context),
                      child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Obx(
                          () => Text(
                            controller.selectedGender.value,
                            style: TextStyle(
                              color: greyDark,
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
