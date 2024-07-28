import 'package:flutter_finalproject/Views/widgets_common/infosituation.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FilterDrawerMatch extends StatefulWidget {
  @override
  _FilterDrawerMatchState createState() => _FilterDrawerMatchState();
}

class _FilterDrawerMatchState extends State<FilterDrawerMatch> {
  final ProductController controller = Get.find<ProductController>();

  double _currentSliderValue = 0;
  bool isSelectedAll = false;
  bool isSelectedMen = false;
  bool isSelectedWomen = false;

  bool isSelectedDress = false;
  bool isSelectedTShirts = false;
  bool isSelectedPants = false;
  bool isSelectedSuits = false;
  bool isSelectedJackets = false;
  bool isSelectedSkirts = false;

  bool isSelectedSummer = false;
  bool isSelectedWinter = false;
  bool isSelectedAutumn = false;
  bool isSelectedSpring = false;

  bool isSelectedFormal = false;
  bool isSelectedCasual = false;
  bool isSelectedSeasonal = false;
  bool isSelectedSemiFormal = false;
  bool isSelectedSpecialActivity = false;
  bool isSelectedWorkFromHome = false;

  bool isSelectedAllProduct = false;
  bool isSelectedFavorite = false;

  final selectedColorIndexes = <int>[].obs;

  final List<Map<String, dynamic>> allColors = [
    {'name': 'Black', 'color': blackColor, 'value': 0xFF000000},
    {'name': 'Grey', 'color': greyColor, 'value': 0xFF808080},
    {'name': 'White', 'color': whiteColor, 'value': 0xFFFFFFFF},
    {
      'name': 'Purple',
      'color': const Color.fromRGBO(98, 28, 141, 1),
      'value': 0xFF621C8D
    },
    {
      'name': 'Deep Purple',
      'color': const Color.fromRGBO(202, 147, 235, 1),
      'value': 0xFFCA93EB
    },
    {
      'name': 'Blue',
      'color': Color.fromRGBO(32, 47, 179, 1),
      'value': 0xFF202FB3
    },
    {
      'name': 'Light blue',
      'color': const Color.fromRGBO(48, 176, 232, 1),
      'value': 0xFF30B0E8
    },
    // {'name': 'Blue Grey','color': const Color.fromRGBO(83, 205, 191, 1),'value': 0xFF53CDBF},
    {
      'name': 'Green',
      'color': const Color.fromRGBO(23, 119, 15, 1),
      'value': 0xFF17770F
    },
    {
      'name': 'Lime Green',
      'color': Color.fromRGBO(98, 207, 47, 1),
      'value': 0xFF62CF2F
    },
    {'name': 'Yellow', 'color': Colors.yellow, 'value': 0xFFFFFF00},
    {'name': 'Orange', 'color': Colors.orange, 'value': 0xFFFFA500},
    {'name': 'Pink', 'color': Colors.pinkAccent, 'value': 0xFFFF4081},
    {'name': 'Red', 'color': redColor, 'value': 0xFFFF0000},
    {
      'name': 'Brown',
      'color': Color.fromARGB(255, 121, 58, 31),
      'value': 0xFF793A1F
    },
  ];

  void updateFilterTypes() {
    List<String> types = [];
    if (isSelectedTShirts) types.add('t-shirts');
    if (isSelectedSkirts) types.add('skirts');
    if (isSelectedDress) types.add('dresses');
    if (isSelectedPants) types.add('pants');
    if (isSelectedJackets) types.add('jackets');
    if (isSelectedSuits) types.add('suits');

    controller.updateFilters(types: types);
  }

  @override
  void initState() {
    super.initState();
    isSelectedAll = controller.selectedGender.value == '';
    isSelectedMen = controller.selectedGender.value == 'male';
    isSelectedWomen = controller.selectedGender.value == 'woman';
    _currentSliderValue = double.tryParse(controller.maxPrice.value) ?? 0.0;
    controller.fetchVendors();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.heightBox,
            ListTile(
              title: Center(
                child: Text(
                  "Please choose clothing that matches your needs",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            15.heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Price").text.fontFamily(regular).size(14).make(),
                      Text(
                        "${NumberFormat('#,###').format(_currentSliderValue.round())} Bath",
                        style: TextStyle(
                          fontFamily: regular,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: primaryApp,
                        inactiveTrackColor: greyLine,
                        thumbColor: greyDark,
                        overlayColor: thinPrimaryApp,
                        trackHeight: 4.0,
                      ),
                      child: Slider(
                        value: _currentSliderValue,
                        min: 0,
                        max: 999999,
                        divisions: 100,
                        label:
                            "${NumberFormat('#,###').format(_currentSliderValue.round())} Bath",
                        onChanged: (value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                          print(
                              "Selected price: ${NumberFormat('#,###').format(_currentSliderValue.round())} Bath");
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Show Products")
                            .text
                            .fontFamily(regular)
                            .size(14)
                            .make(),
                      ),
                    ],
                  ),
                  Center(
                    child: Wrap(
                      spacing: 15,
                      children: [
                        buildFilterChip("All Products", isSelectedAllProduct,
                            (isSelected) {
                          setState(() => isSelectedAllProduct = isSelected);
                        }),
                        buildFilterChip("Favorite", isSelectedFavorite,
                            (isSelected) {
                          setState(() => isSelectedFavorite = isSelected);
                        }),
                      ],
                    ),
                  ),
                  15.heightBox,
                  Row(
                    children: [
                      Expanded(
                        child: Text("Type of product")
                            .text
                            .fontFamily(regular)
                            .size(14)
                            .make(),
                      ),
                    ],
                  ),
                  Center(
                    child: Wrap(
                      spacing: 5,
                      children: [
                        buildFilterChipSmall("Dress", isSelectedDress,
                            (isSelected) {
                          setState(() {
                            isSelectedDress = isSelected;
                            updateFilterTypes();
                          });
                        }),
                        buildFilterChipSmall("T-Shirts", isSelectedTShirts,
                            (isSelected) {
                          setState(() {
                            isSelectedTShirts = isSelected;
                            updateFilterTypes();
                          });
                        }),
                        buildFilterChipSmall("Suits", isSelectedSuits,
                            (isSelected) {
                          setState(() {
                            isSelectedSuits = isSelected;
                            updateFilterTypes();
                          });
                        }),
                        buildFilterChipSmall("Jackets", isSelectedJackets,
                            (isSelected) {
                          setState(() {
                            isSelectedJackets = isSelected;
                            updateFilterTypes();
                          });
                        }),
                        buildFilterChipSmall("Pants", isSelectedPants,
                            (isSelected) {
                          setState(() {
                            isSelectedPants = isSelected;
                            updateFilterTypes();
                          });
                        }),
                        buildFilterChipSmall("Skirts", isSelectedSkirts,
                            (isSelected) {
                          setState(() {
                            isSelectedSkirts = isSelected;
                            updateFilterTypes();
                          });
                        }),
                      ],
                    ),
                  ),
                  15.heightBox,
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Color")
                          .text
                          .fontFamily(regular)
                          .size(14)
                          .make()),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Wrap(
                      spacing: 15,
                      runSpacing: 10,
                      children: List.generate(
                        allColors.length,
                        (index) {
                          final color = allColors[index];
                          final isSelected =
                              selectedColorIndexes.contains(color['value']);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedColorIndexes.remove(color['value']);
                                } else {
                                  selectedColorIndexes.add(color['value']);
                                }
                              });
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: color['color'],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isSelected ? primaryApp : greyThin,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  15.heightBox,
                  Row(
                    children: [
                      Text(
                        "Suitable for work and situations",
                        style: TextStyle(fontSize: 14, fontFamily: regular),
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
                  Center(
                    child: Wrap(
                      spacing: 15,
                      children: [
                        buildFilterChip("Formal Attire", isSelectedFormal,
                            (isSelected) {
                          setState(() => isSelectedFormal = isSelected);
                        }),
                        buildFilterChip("Casual Attire", isSelectedCasual,
                            (isSelected) {
                          setState(() => isSelectedCasual = isSelected);
                        }),
                        buildFilterChip("Seasonal Attire", isSelectedSeasonal,
                            (isSelected) {
                          setState(() => isSelectedSeasonal = isSelected);
                        }),
                        buildFilterChip(
                            "Semi-Formal Attire ", isSelectedSemiFormal,
                            (isSelected) {
                          setState(() => isSelectedSemiFormal = isSelected);
                        }),
                        buildFilterChip(
                            "Activity Attire ", isSelectedSpecialActivity,
                            (isSelected) {
                          setState(
                              () => isSelectedSpecialActivity = isSelected);
                        }),
                        buildFilterChip(
                            "Work from Home ", isSelectedWorkFromHome,
                            (isSelected) {
                          setState(() => isSelectedWorkFromHome = isSelected);
                        }),
                      ],
                    ),
                  ),
                  15.heightBox,
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(" Suitable for seasons")
                        .text
                        .fontFamily(regular)
                        .size(14)
                        .make(),
                  ),
                  Center(
                    child: Wrap(
                      spacing: 15,
                      children: [
                        buildFilterChip("Summer", isSelectedSummer,
                            (isSelected) {
                          setState(() => isSelectedSummer = isSelected);
                        }),
                        buildFilterChip("Winter", isSelectedWinter,
                            (isSelected) {
                          setState(() => isSelectedWinter = isSelected);
                        }),
                        buildFilterChip("Autumn", isSelectedAutumn,
                            (isSelected) {
                          setState(() => isSelectedAutumn = isSelected);
                        }),
                        buildFilterChip("Spring ", isSelectedSpring,
                            (isSelected) {
                          setState(() => isSelectedSpring = isSelected);
                        }),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
              child: tapButton(
                      onPress: () {
                        String selectedGender = '';
                        if (isSelectedMen) {
                          selectedGender = 'men';
                        } else if (isSelectedWomen) {
                          selectedGender = 'women';
                        }

                        List<String> selectedTypes = [
                          if (isSelectedDress) 'dresses',
                          if (isSelectedSkirts) 'skirts',
                          if (isSelectedTShirts) 't-shirts',
                          if (isSelectedPants) 'pants',
                          if (isSelectedJackets) 'jackets',
                          if (isSelectedSuits) 'suits',
                        ];

                        List<String> selectedCollections = [
                          if (isSelectedSummer) 'summer',
                          if (isSelectedWinter) 'winter',
                          if (isSelectedAutumn) 'autumn',
                          if (isSelectedSpring) 'spring',
                        ];

                        List<String> selectedSituations = [
                          if (isSelectedFormal) 'formal',
                          if (isSelectedCasual) 'casual',
                          if (isSelectedSeasonal) 'seasonal',
                          if (isSelectedSemiFormal) 'semi-formal',
                          if (isSelectedSpecialActivity) 'specialactivity',
                          if (isSelectedWorkFromHome) 'workfromhome',
                        ];

                        controller.updateFilters(
                          gender: selectedGender,
                          price: _currentSliderValue,
                          colors: selectedColorIndexes,
                          types: selectedTypes,
                          collections: selectedCollections,
                          situations: selectedSituations,
                          isFavorite: isSelectedFavorite,
                        );

                        final selectedVendor = controller.vendors.firstWhere(
                            (vendor) =>
                                vendor['vendor_id'] ==
                                controller.selectedVendorId.value,
                            orElse: () => {'vendor_name': 'Unknown'});

                        print('Saved Filters:');
                        print('Gender: $selectedGender');
                        print('Price: $_currentSliderValue');
                        print('Colors: $selectedColorIndexes');
                        print('Types: $selectedTypes');
                        print('Collections: $selectedCollections');
                        print('Favorite: $isSelectedFavorite');
                        print('Situations: $selectedSituations');
                        controller.fetchFilteredTopProducts();
                        controller.fetchFilteredLowerProducts();

                        Navigator.pop(context);
                      },
                      title: 'Save',
                      color: primaryApp,
                      textColor: whiteColor
                      // style: ElevatedButton.styleFrom(
                      //   backgroundColor: primaryApp,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(8),
                      //   ),
                      // ),
                      )
                  .box
                  .makeCentered(),
            )
          ],
        ).box.white.padding(EdgeInsets.symmetric(vertical: 12)).make(),
      ),
    );
  }

  Widget buildFilterChip(
      String label, bool isSelected, Function(bool) onSelected) {
    final BorderSide borderSide = BorderSide(
      color: isSelected ? primaryApp : greyLine,
      width: 1,
    );

    return SizedBox(
      width: 165,
      child: TextButton(
        onPressed: () => onSelected(!isSelected),
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? thinPrimaryApp : whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: borderSide,
          ),
          splashFactory: NoSplash.splashFactory,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: isSelected ? medium : regular,
            color: greyColor,
          ),
        ),
      ),
    );
  }
}

Widget buildFilterChipSmall(
    String label, bool isSelected, Function(bool) onSelected) {
  final BorderSide borderSide = BorderSide(
    color: isSelected ? primaryApp : greyLine,
    width: 1.0,
  );

  return SizedBox(
    width: 85,
    child: TextButton(
      onPressed: () => onSelected(!isSelected),
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? thinPrimaryApp : whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: borderSide,
        ),
        // padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        splashFactory: NoSplash.splashFactory,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: isSelected ? medium : regular,
          color: greyColor,
        ),
      ),
    ),
  );
}
