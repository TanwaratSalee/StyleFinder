import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:get/get.dart';

class MatchPostProduct extends StatefulWidget {
  final Map<String, dynamic> topProduct;
  final Map<String, dynamic> lowerProduct;

  MatchPostProduct({required this.topProduct, required this.lowerProduct});

  @override
  _MatchPostProductState createState() => _MatchPostProductState();
}

class _MatchPostProductState extends State<MatchPostProduct> {
  final ProductController controller = Get.find<ProductController>();
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
                          color: greyColor,
                          child: Center(
                            child: Image.network(widget.topProduct['p_imgs'][0]),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Top',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: regular,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 27,
                          height: 27,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryApp,
                          ),
                        ),
                        Icon(
                          Icons.add,
                          size: 24,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Container(
                          width: 125,
                          height: 125,
                          color: Colors.grey[300],
                          child: Center(
                            child: Image.network(widget.lowerProduct['p_imgs'][0]),
                          ),
                        ),
                        SizedBox(height: 5),
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
                    setState(() {
                      isSelectedAll = isSelected;
                      isSelectedMen = false;
                      isSelectedWomen = false;
                      controller.selectedGender.value = '';
                    });
                  },
                  onMenSelected: (isSelected) {
                    setState(() {
                      isSelectedMen = isSelected;
                      isSelectedAll = false;
                      isSelectedWomen = false;
                      controller.selectedGender.value = 'male';
                    });
                  },
                  onWomenSelected: (isSelected) {
                    setState(() {
                      isSelectedWomen = isSelected;
                      isSelectedAll = false;
                      isSelectedMen = false;
                      controller.selectedGender.value = 'female';
                    });
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
                    setState(() {
                      isSelectedSummer = isSelected;
                      updateCollection('summer', isSelected);
                    });
                  },
                  onWinterSelected: (isSelected) {
                    setState(() {
                      isSelectedWinter = isSelected;
                      updateCollection('winter', isSelected);
                    });
                  },
                  onAutumnSelected: (isSelected) {
                    setState(() {
                      isSelectedAutumn = isSelected;
                      updateCollection('autumn', isSelected);
                    });
                  },
                  onDinnerSelected: (isSelected) {
                    setState(() {
                      isSelectedDinner = isSelected;
                      updateCollection('dinner', isSelected);
                    });
                  },
                  onEverydaySelected: (isSelected) {
                    setState(() {
                      isSelectedEveryday = isSelected;
                      updateCollection('everydaylook', isSelected);
                    });
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
                  onPressed: () {
                    controller.addToWishlistPostUserMatch(
                      widget.topProduct['p_name'],
                      widget.lowerProduct['p_name'],
                      context,
                      controller.selectedGender.value,
                      controller.selectedCollections,
                      explanationController.text,
                    );
                  },
                  child: Text(
                    "Post",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryApp,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
      color: isSelected ? thinPrimaryApp : greyThin,
      textColor: greyColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? primaryApp : greyLine,
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
            spacing: 10,
            runSpacing: 1,
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
      color: isSelected ? thinPrimaryApp : greyThin,
      textColor: greyColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? primaryApp : greyColor,
        ),
      ),
      elevation: 0,
      minWidth: 150,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }
}
