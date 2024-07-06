import 'package:flutter_finalproject/Views/widgets_common/infosituation.dart';
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
    {
      'name': 'Blue Grey',
      'color': const Color.fromRGBO(83, 205, 191, 1),
      'value': 0xFF53CDBF
    },
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
    {'name': 'Red', 'color': Colors.red, 'value': 0xFFFF0000},
    {
      'name': 'Brown',
      'color': Color.fromARGB(255, 121, 58, 31),
      'value': 0xFF793A1F
    },
  ];

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
                  "Choose clothes that are appropriate for your situation.",
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
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
            15.heightBox,
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
              child: Text("Color").text.fontFamily(regular).size(14).make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 5,
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
                        width: 32,
                        height: 32,
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
              child: Row(
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
            ),
            Center(
              child: Wrap(
                spacing: 5,
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
                  buildFilterChip("Semi-Formal Attire ", isSelectedSemiFormal,
                      (isSelected) {
                    setState(() => isSelectedSemiFormal = isSelected);
                  }),
                  buildFilterChip(
                      "Special Activity Attire ", isSelectedSpecialActivity,
                      (isSelected) {
                    setState(() => isSelectedSpecialActivity = isSelected);
                  }),
                  buildFilterChip("Work from Home ", isSelectedWorkFromHome,
                      (isSelected) {
                    setState(() => isSelectedWorkFromHome = isSelected);
                  }),
                ],
              ),
            ).paddingOnly(left: 6),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
              child: Text(" Suitable for seasons")
                  .text
                  .fontFamily(regular)
                  .size(14)
                  .make(),
            ),
            Center(
              child: Wrap(
                spacing: 5,
                children: [
                  buildFilterChip("Summer", isSelectedSummer, (isSelected) {
                    setState(() => isSelectedSummer = isSelected);
                  }),
                  buildFilterChip("Winter", isSelectedWinter, (isSelected) {
                    setState(() => isSelectedWinter = isSelected);
                  }),
                  buildFilterChip("Autumn", isSelectedAutumn, (isSelected) {
                    setState(() => isSelectedAutumn = isSelected);
                  }),
                  buildFilterChip("Spring ", isSelectedSpring, (isSelected) {
                    setState(() => isSelectedSpring = isSelected);
                  }),
                ],
              ),
            ).paddingOnly(left: 6),
            ElevatedButton(
              onPressed: () {
                String selectedGender = '';
                if (isSelectedMen) {
                  selectedGender = 'men';
                } else if (isSelectedWomen) {
                  selectedGender = 'women';
                }

                controller.updateFilters(
                  gender: selectedGender,
                  price: _currentSliderValue,
                  colors: selectedColorIndexes,
                  types: [
                    if (isSelectedDress) 'dresses',
                    if (isSelectedSkirts) 'skirts',
                    if (isSelectedTShirts) 't-shirts',
                    if (isSelectedPants) 'pants',
                    if (isSelectedJackets) 'jackets',
                    if (isSelectedSuits) 'suits',
                  ],
                  collections: [
                    if (isSelectedSummer) 'summer',
                    if (isSelectedWinter) 'winter',
                    if (isSelectedAutumn) 'autumn',
                    if (isSelectedSpring) 'spring',
                  ],
                  situations: [
                    if (isSelectedFormal) 'formal',
                    if (isSelectedCasual) 'casual',
                    if (isSelectedSeasonal) 'seasonal',
                    if (isSelectedSemiFormal) 'semi-formal',
                    if (isSelectedSpecialActivity) 'specialactivity',
                    if (isSelectedWorkFromHome) 'workfromhome',
                  ],
                );

                final selectedVendor = controller.vendors.firstWhere(
                    (vendor) =>
                        vendor['vendor_id'] ==
                        controller.selectedVendorId.value,
                    orElse: () => {'vendor_name': 'Unknown'});
                print("Selected vendor name: ${selectedVendor['vendor_name']}");
                print(
                    "Selected Vendor ID: ${controller.selectedVendorId.value}");

                controller.fetchFilteredTopProducts();
                controller.fetchFilteredLowerProducts();

                Navigator.pop(context);
              },
              child: Text('Save').text.white.make(),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryApp,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ).box.makeCentered()
          ],
        ).box.white.padding(EdgeInsets.symmetric(vertical: 12)).make(),
      ),
    );
  }

  Widget buildFilterChip(
      String label, bool isSelected, Function(bool) onSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      showCheckmark: false,
      side: BorderSide(color: isSelected ? primaryApp : greyLine),
      selectedColor: thinPrimaryApp,
      padding: EdgeInsets.symmetric(horizontal: 3),
    );
  }
}
