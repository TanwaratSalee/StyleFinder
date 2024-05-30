import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/home_controller.dart';
import 'package:get/get.dart';

class PostMatchScreen extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final TextEditingController explanationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isSelectedAll = controller.selectedGender.value == '';
    bool isSelectedMen = controller.selectedGender.value == 'male';
    bool isSelectedWomen = controller.selectedGender.value == 'female';
    bool isSelectedSummer = controller.selectedCollections.contains('summer');
    bool isSelectedWinter = controller.selectedCollections.contains('winter');
    bool isSelectedAutumn = controller.selectedCollections.contains('autumn');
    bool isSelectedDinner = controller.selectedCollections.contains('dinner');
    bool isSelectedEveryday =
        controller.selectedCollections.contains('everydaylook');

    return Scaffold(
      appBar: AppBar(
        title: Text('Match Your Outfit'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 125,
                          height: 125,
                          color: Colors.grey[300],
                          child: Center(
                            child: Text('Image 1'),
                          ),
                        ),
                        SizedBox(
                            height: 5), // เพิ่มช่องว่างระหว่างรูปและข้อความ
                        Text(
                          'Top',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: regular,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 27,
                          height: 27,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryApp, // สีวงกลมด้านหลัง
                          ),
                        ),
                        Icon(
                          Icons.add,
                          size: 24,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 125,
                          height: 125,
                          color: Colors.grey[300],
                          child: Center(
                            child: Text('Image 2'),
                          ),
                        ),
                        SizedBox(
                            height: 5), // เพิ่มช่องว่างระหว่างรูปและข้อความ
                        Text(
                          'Lower',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: regular,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GenderSelector(
                  isSelectedAll: isSelectedAll,
                  isSelectedMen: isSelectedMen,
                  isSelectedWomen: isSelectedWomen,
                  onAllSelected: (isSelected) {
                    isSelectedAll = isSelected;
                    isSelectedMen = false;
                    isSelectedWomen = false;
                    controller.selectedGender.value = '';
                  },
                  onMenSelected: (isSelected) {
                    isSelectedMen = isSelected;
                    isSelectedAll = false;
                    isSelectedWomen = false;
                    controller.selectedGender.value = 'male';
                  },
                  onWomenSelected: (isSelected) {
                    isSelectedWomen = isSelected;
                    isSelectedAll = false;
                    isSelectedMen = false;
                    controller.selectedGender.value = 'female';
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CollectionSelector(
                  isSelectedSummer: isSelectedSummer,
                  isSelectedWinter: isSelectedWinter,
                  isSelectedAutumn: isSelectedAutumn,
                  isSelectedDinner: isSelectedDinner,
                  isSelectedEveryday: isSelectedEveryday,
                  onSummerSelected: (isSelected) {
                    isSelectedSummer = isSelected;
                    updateCollection('summer', isSelected);
                  },
                  onWinterSelected: (isSelected) {
                    isSelectedWinter = isSelected;
                    updateCollection('winter', isSelected);
                  },
                  onAutumnSelected: (isSelected) {
                    isSelectedAutumn = isSelected;
                    updateCollection('autumn', isSelected);
                  },
                  onDinnerSelected: (isSelected) {
                    isSelectedDinner = isSelected;
                    updateCollection('dinner', isSelected);
                  },
                  onEverydaySelected: (isSelected) {
                    isSelectedEveryday = isSelected;
                    updateCollection('everydaylook', isSelected);
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "Explain clothing matching",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: regular,
                      ),
                    ),
                    SizedBox(height: 0),
                    TextField(
                      controller: explanationController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 250, 248, 248),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Post",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryApp,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // ปรับมุมให้เป็น 8 พิกเซล
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateCollection(String collection, bool isSelected) {
    if (isSelected) {
      controller.selectedCollections.add(collection);
    } else {
      controller.selectedCollections.remove(collection);
    }
  }
}

class GenderSelector extends StatelessWidget {
  final bool isSelectedAll;
  final bool isSelectedMen;
  final bool isSelectedWomen;
  final Function(bool) onAllSelected;
  final Function(bool) onMenSelected;
  final Function(bool) onWomenSelected;

  GenderSelector({
    required this.isSelectedAll,
    required this.isSelectedMen,
    required this.isSelectedWomen,
    required this.onAllSelected,
    required this.onMenSelected,
    required this.onWomenSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          "Suitable for gender",
          style: TextStyle(fontSize: 16, fontFamily: regular),
        ),
        SizedBox(height: 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildFilterChip("All", isSelectedAll, onAllSelected),
            SizedBox(width: 5),
            buildFilterChip("Men", isSelectedMen, onMenSelected),
            SizedBox(width: 5),
            buildFilterChip("Women", isSelectedWomen, onWomenSelected),
          ],
        ),
      ],
    );
  }

  Widget buildFilterChip(
      String label, bool isSelected, Function(bool) onSelected) {
    return MaterialButton(
      onPressed: () => onSelected(!isSelected),
      child: Text(label),
      color: isSelected ? thinPrimaryApp : Color.fromARGB(255, 250, 248, 248),
      textColor: Colors.grey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? primaryApp : Color.fromARGB(255, 227, 221, 221),
        ),
      ),
      elevation: 0,
      minWidth: 100,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    );
  }
}

class CollectionSelector extends StatelessWidget {
  final bool isSelectedSummer;
  final bool isSelectedWinter;
  final bool isSelectedAutumn;
  final bool isSelectedDinner;
  final bool isSelectedEveryday;
  final Function(bool) onSummerSelected;
  final Function(bool) onWinterSelected;
  final Function(bool) onAutumnSelected;
  final Function(bool) onDinnerSelected;
  final Function(bool) onEverydaySelected;

  CollectionSelector({
    required this.isSelectedSummer,
    required this.isSelectedWinter,
    required this.isSelectedAutumn,
    required this.isSelectedDinner,
    required this.isSelectedEveryday,
    required this.onSummerSelected,
    required this.onWinterSelected,
    required this.onAutumnSelected,
    required this.onDinnerSelected,
    required this.onEverydaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          "Collection",
          style: TextStyle(fontSize: 16, fontFamily: regular),
        ),
        SizedBox(height: 0),
        Center(
          child: Wrap(
            spacing: 10, // horizontal space between chips
            runSpacing: 1, // vertical space between lines
            children: [
              buildFilterChip("Summer ", isSelectedSummer, onSummerSelected),
              buildFilterChip("Winter ", isSelectedWinter, onWinterSelected),
              buildFilterChip("Autumn ", isSelectedAutumn, onAutumnSelected),
              buildFilterChip("Dinner ", isSelectedDinner, onDinnerSelected),
              buildFilterChip(
                  "Everydaylook ", isSelectedEveryday, onEverydaySelected),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFilterChip(
      String label, bool isSelected, Function(bool) onSelected) {
    return MaterialButton(
      onPressed: () => onSelected(!isSelected),
      child: Text(label),
      color: isSelected ? thinPrimaryApp : Color.fromARGB(255, 250, 248, 248),
      textColor: greyColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? primaryApp : Color.fromARGB(255, 227, 221, 221),
        ),
      ),
      elevation: 0,
      minWidth: 150,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }
}
