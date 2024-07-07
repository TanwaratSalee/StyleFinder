import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/match_screen/matchpost_details.dart';
import 'package:flutter_finalproject/Views/widgets_common/infosituation.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditMatchProduct extends StatefulWidget {
  final MatchPostsDetails document;

  const EditMatchProduct({Key? key, required this.document}) : super(key: key);

  @override
  _EditMatchProductState createState() => _EditMatchProductState();
}

class _EditMatchProductState extends State<EditMatchProduct> {
  final TextEditingController explanationController = TextEditingController();
  List<String> selectedCollections = [];
  List<String> selectedSituations = [];
  String selectedGender = '';
  late DocumentSnapshot document;
  Map<String, dynamic> ItemsDetails = {};
  String pIdTop = '';
  String pIdLower = '';
  String topProductImg = '';
  String lowerProductImg = '';
  String topProductName = '';
  String lowerProductName = '';
  double topProductPrice = 0.0;
  double lowerProductPrice = 0.0;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.document.gender;
    selectedCollections = List<String>.from(widget.document.collection);
    selectedSituations = List<String>.from(widget.document.situations);
    explanationController.text = widget.document.description;
    pIdTop = widget.document.docId; // Adjust this if needed
    pIdLower = widget.document.docId; // Adjust this if needed
    fetchItemsDetails(widget.document.docId);
  }

  Map<String, String> situationNames = {
    'formal': 'Formal Attire',
    'semi-formal': 'Semi-Formal Attire',
    'casual': 'Casual Attire',
    'special-activity': 'Activity Attire',
    'seasonal': 'Seasonal Attire',
    'work-from-home': 'Work from Home',
  };

  Future<void> fetchItemsDetails(String docId) async {
    try {
      var docSnapshot = await FirebaseFirestore.instance
          .collection('usermixandmatch')
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        var docData = docSnapshot.data() as Map<String, dynamic>;
        var productIdTop = docData['product_id_top'];
        var productIdLower = docData['product_id_lower'];

        var topSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(productIdTop)
            .get();
        var lowerSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(productIdLower)
            .get();

        if (topSnapshot.exists) {
          setState(() {
            topProductImg = topSnapshot.data()!['imgs'][0];
            topProductName = topSnapshot.data()!['name'];
            topProductPrice =
                double.tryParse(topSnapshot.data()!['price'].toString()) ?? 0.0;
          });
        }

        if (lowerSnapshot.exists) {
          setState(() {
            lowerProductImg = lowerSnapshot.data()!['imgs'][0];
            lowerProductName = lowerSnapshot.data()!['name'];
            lowerProductPrice =
                double.tryParse(lowerSnapshot.data()!['price'].toString()) ??
                    0.0;
          });
        }
      }
    } catch (e) {
      print('Error fetching items details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Match Product')
            .text
            .size(24)
            .fontFamily(medium)
            .make(),
        // actions: <Widget>[
        //   TextButton(
        //     onPressed: () async {
        //       await onSaveButtonPressed(context);
        //       Get.back();
        //     },
        //     child: const Text('Save', style: TextStyle(color: primaryApp)),
        //   ),
        // ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24,10,24,22),
        child: tapButton(
          onPress: () async {
                await onSaveButtonPressed(context);
                Get.back();
              },
              color: primaryApp,
              title: 'Save',
              textColor: whiteColor
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      if (topProductImg.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                          child: Image.network(
                            topProductImg,
                            width: 160,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(
                        width: 130,
                        child: Text(
                          topProductName,
                          style: TextStyle(fontSize: 14, color: blackColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("${NumberFormat('#,##0').format(topProductPrice)} Bath")
                          .text
                          .size(14)
                          .color(greyColor)
                          .make(),
                    ],
                  ).box.border(color: greyLine).rounded.make(),
                  const SizedBox(width: 5),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        color: whiteColor,
                      )
                          .box
                          .color(primaryApp)
                          .roundedFull
                          .padding(EdgeInsets.all(4))
                          .make(),
                    ],
                  ),
                  const SizedBox(width: 5),
                  Column(
                    children: [
                      if (lowerProductImg.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                          child: Image.network(
                            lowerProductImg,
                            width: 160,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(
                        width: 130,
                        child: Text(
                          lowerProductName,
                          style: TextStyle(fontSize: 14, color: blackColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("${NumberFormat('#,##0').format(lowerProductPrice)} Bath")
                          .text
                          .size(14)
                          .color(greyColor)
                          .make(),
                    ],
                  ).box.border(color: greyLine).rounded.make()
                ],
              ),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  15.heightBox,
                  const Text("Suitable for gender")
                      .text
                      .size(16)
                      .color(blackColor)
                      .fontFamily(medium)
                      .make(),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['all', 'man', 'woman'].map((gender) {
                      bool isSelected = selectedGender == gender;
                      return Container(
                        width: 105,
                        child: ChoiceChip(
                          showCheckmark: false,
                          label: Container(
                            alignment: Alignment.center,
                            child: Text(
                              capitalize(gender),
                              style: TextStyle(
                                color: isSelected ? primaryApp : greyColor,
                                fontFamily: isSelected ? semiBold : regular,
                              ),
                            ).text.size(14).make(),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                selectedGender = gender;
                              });
                            }
                          },
                          selectedColor: thinPrimaryApp,
                          backgroundColor: whiteColor,
                          side: isSelected
                              ? const BorderSide(color: primaryApp, width: 2)
                              : const BorderSide(color: greyLine),
                        ),
                      );
                    }).toList(),
                  ).box.makeCentered(),
                  15.heightBox,
                 Row(
                          children: [
                            Text(
                              "Suitable for work and situations",
                              style:
                                  TextStyle(fontSize: 16, fontFamily: medium),
                            ),
                            10.widthBox,
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SituationsList();
                                  },
                                );
                              },
                              child: Image.asset(
                                icInfo,
                                width: 15,
                              ),
                            ),
                          ],
                        ),
                        
                  Wrap(
                    spacing: 8,
                    runSpacing: 1,
                    children: [
                      'formal',
                      'semi-formal',
                      'casual',
                      'special-activity',
                      'seasonal',
                      'work-from-home'
                    ].map((situation) {
                      bool isSelected = selectedSituations.contains(situation);
                      return ChoiceChip(
                        showCheckmark: false,
                        label: Container(
                          width: 130,
                          alignment: Alignment.center,
                          child: Text(
                            capitalize(situationNames[situation] ?? ''),
                            style: TextStyle(
                              color: isSelected ? primaryApp : greyColor,
                              fontFamily: isSelected ? semiBold : regular,
                            ),
                          ).text.size(14).make(),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (isSelected) {
                              selectedSituations.remove(situation);
                            } else {
                              selectedSituations.add(situation);
                            }
                          });
                        },
                        selectedColor: thinPrimaryApp,
                        backgroundColor: whiteColor,
                        side: isSelected
                            ? const BorderSide(color: primaryApp, width: 2)
                            : const BorderSide(color: greyLine, width: 1.3),
                      );
                    }).toList(),
                  ).box.makeCentered(),
                  15.heightBox,
                  const Text("Suitable for seasons")
                      .text
                      .size(16)
                      .color(blackColor)
                      .fontFamily(medium)
                      .make(),
                  Wrap(
                    spacing: 8,
                    runSpacing: 1,
                    children: [
                      'summer',
                      'winter',
                      'autumn',
                      'spring ',
                    ].map((collection) {
                      bool isSelected =
                          selectedCollections.contains(collection);
                      return ChoiceChip(
                        showCheckmark: false,
                        label: Container(
                          width: 130,
                          alignment: Alignment.center,
                          child: Text(
                            capitalize(collection),
                            style: TextStyle(
                              color: isSelected ? primaryApp : greyColor,
                              fontFamily: isSelected ? semiBold : regular,
                            ),
                          ).text.size(14).make(),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (isSelected) {
                              selectedCollections.remove(collection);
                            } else {
                              selectedCollections.add(collection);
                            }
                          });
                        },
                        selectedColor: thinPrimaryApp,
                        backgroundColor: whiteColor,
                        side: isSelected
                            ? const BorderSide(color: primaryApp, width: 2)
                            : const BorderSide(color: greyLine, width: 1.3),
                      );
                    }).toList(),
                  ).box.makeCentered(),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Text(
                          "Explain clothing matching",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: medium,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: explanationController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Enter your explanation here',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(240, 240, 240, 1),
                          ),
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: regular,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 12),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSaveButtonPressed(BuildContext context) async {
    String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (currentUserUID.isEmpty) {
      VxToast.show(context, msg: "User is not logged in.");
      print('Error: User is not logged in.');
      return;
    }

    Map<String, dynamic> userData = {
      'collection': selectedCollections,
      'situations': selectedSituations,
      'gender': selectedGender,
      'description': explanationController.text,
    };

    await FirebaseFirestore.instance
        .collection('usermixandmatch')
        .doc(widget.document.docId)
        .update(userData)
        .then((_) {
      VxToast.show(context, msg: "Match updated successfully.");
      print('Match updated successfully.');
    }).catchError((error) {
      print('Error updating match: $error');
      VxToast.show(context, msg: "Error updating match.");
    });
  }
}
