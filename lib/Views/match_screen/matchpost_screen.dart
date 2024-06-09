import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
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
    bool isSelectedAll = controller.selectedGender.value == 'all';
    bool isSelectedMen = controller.selectedGender.value == 'male';
    bool isSelectedWomen = controller.selectedGender.value == 'female';
    bool isSelectedSummer = controller.selectedCollections.contains('summer');
    bool isSelectedWinter = controller.selectedCollections.contains('winter');
    bool isSelectedAutumn = controller.selectedCollections.contains('autumn');
    bool isSelectedDinner = controller.selectedCollections.contains('dinner');
    bool isSelectedEveryday = controller.selectedCollections.contains('everydaylook');

    return WillPopScope(
      onWillPop: () async {
        resetSelections();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Match Your Outfit'),
        ),
        bottomNavigationBar: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
            child: tapButton(
              color: primaryApp,
              title: 'Post',
              textColor: whiteColor,
              onPress: () {
                controller.addToPostByUserMatch(
                  widget.topProduct['p_name'],
                  widget.lowerProduct['p_name'],
                  context,
                  controller.selectedGender.value,
                  List.from(controller.selectedCollections), // Ensure a copy is passed
                  explanationController.text,
                );
                resetSelections();
              },
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
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
                              width: 160,
                              height: 150,
                              color: whiteColor,
                              child: Center(
                                child: Image.network(widget.topProduct['p_imgs'][0]),
                              ).box.border(color: greyLine).rounded.make(),
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
                        SizedBox(width: 15),
                        Column(
                          children: [
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
                                  color: whiteColor,
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                        SizedBox(width: 15),
                        Column(
                          children: [
                            Container(
                              width: 160,
                              height: 150,
                              color: whiteColor,
                              child: Center(
                                child: Image.network(widget.lowerProduct['p_imgs'][0]),
                              ).box.border(color: greyLine).rounded.make(),
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
                    child: buildGenderSelector(
                      isSelectedAll: isSelectedAll,
                      isSelectedMen: isSelectedMen,
                      isSelectedWomen: isSelectedWomen,
                      onAllSelected: (isSelected) {
                        setState(() {
                          isSelectedAll = isSelected;
                          if (isSelected) {
                            isSelectedMen = false;
                            isSelectedWomen = false;
                            controller.selectedGender.value = 'all';
                          } else if (!isSelectedMen && !isSelectedWomen) {
                            controller.selectedGender.value = '';
                          }
                        });
                      },
                      onMenSelected: (isSelected) {
                        setState(() {
                          isSelectedMen = isSelected;
                          if (isSelected) {
                            isSelectedAll = false;
                            isSelectedWomen = false;
                            controller.selectedGender.value = 'male';
                          } else if (!isSelectedAll && !isSelectedWomen) {
                            controller.selectedGender.value = '';
                          }
                        });
                      },
                      onWomenSelected: (isSelected) {
                        setState(() {
                          isSelectedWomen = isSelected;
                          if (isSelected) {
                            isSelectedAll = false;
                            isSelectedMen = false;
                            controller.selectedGender.value = 'female';
                          } else if (!isSelectedAll && !isSelectedMen) {
                            controller.selectedGender.value = '';
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: buildCollectionSelector(
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
                            fontFamily: medium,
                          ),
                        ),
                        8.heightBox,
                        TextField(
                          controller: explanationController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(240, 240, 240, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void resetSelections() {
    setState(() {
      controller.selectedGender.value = '';
      controller.selectedCollections.clear();
      explanationController.clear();
    });
  }

  void updateCollection(String collection, bool isSelected) {
    setState(() {
      if (isSelected) {
        controller.selectedCollections.add(collection);
      } else {
        controller.selectedCollections.remove(collection);
      }
    });
  }

  Widget buildGenderSelector({
    required bool isSelectedAll,
    required bool isSelectedMen,
    required bool isSelectedWomen,
    required Function(bool) onAllSelected,
    required Function(bool) onMenSelected,
    required Function(bool) onWomenSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          "Suitable for gender",
          style: TextStyle(
            fontSize: 16,
            fontFamily: medium,
          ),
        ),
        8.heightBox,
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

  Widget buildCollectionSelector({
    required bool isSelectedSummer,
    required bool isSelectedWinter,
    required bool isSelectedAutumn,
    required bool isSelectedDinner,
    required bool isSelectedEveryday,
    required Function(bool) onSummerSelected,
    required Function(bool) onWinterSelected,
    required Function(bool) onAutumnSelected,
    required Function(bool) onDinnerSelected,
    required Function(bool) onEverydaySelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          "Collection",
          style: TextStyle(fontSize: 16, fontFamily: medium),
        ),
        8.heightBox,
        Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 1,
            children: [
              buildFilterChip("Summer ", isSelectedSummer, onSummerSelected),
              buildFilterChip("Winter ", isSelectedWinter, onWinterSelected),
              buildFilterChip("Autumn ", isSelectedAutumn, onAutumnSelected),
              buildFilterChip("Dinner ", isSelectedDinner, onDinnerSelected),
              buildFilterChip("Everydaylook ", isSelectedEveryday, onEverydaySelected),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFilterChip(String label, bool isSelected, Function(bool) onSelected) {
    final BorderSide borderSide = BorderSide(
      color: isSelected ? primaryApp : greyLine,
      width: 2.0,
    );

    return TextButton(
      onPressed: () => onSelected(!isSelected),
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? thinPrimaryApp : whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: borderSide,
        ),
        minimumSize: Size(120, 40),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        splashFactory: NoSplash.splashFactory,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: isSelected ? medium : regular,
          color: greyColor,
        ),
      ),
    );
  }
}
