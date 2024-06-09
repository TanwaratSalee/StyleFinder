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
                          color: whiteColor,
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
                child: buildGenderSelector(
                  isSelectedAll: isSelectedAll,
                  isSelectedMen: isSelectedMen,
                  isSelectedWomen: isSelectedWomen,
                  onAllSelected: (isSelected) {
                    setState(() {
                      isSelectedAll = isSelected;
                      isSelectedMen = false;
                      isSelectedWomen = false;
                      controller.selectedGender.value = 'all';
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
                    SizedBox(height: 8),
                    TextField(
                      controller: explanationController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: greyMessage,
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
                    controller.addToPostByUserMatch(
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
                    style: TextStyle(fontSize: 16, color: whiteColor),
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
          style: TextStyle(fontSize: 16, fontFamily: medium,),
        ),
        SizedBox(height: 8),
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
        SizedBox(height: 8),
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
          fontFamily: isSelected ? semiBold : regular,
          color: greyColor,
        ),
      ),
    );
  }
}
