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
  bool isSelectedDinner = false;
  bool isSelectedEveryday = false;

  final selectedColorIndexes = <int>[].obs;
  final List<Map<String, dynamic>> allColors = [
    {'name': 'Black', 'color': Colors.black, 'value': 0xFF000000},
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
      'name': 'Blue',
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
      'name': 'Green',
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
            35.heightBox,
            ListTile(
              title: Text(
                "Filter products",
              ).text.size(24).makeCentered(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("Gender").text.fontFamily(regular).size(14).make(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
              child: Row(
                children: [
                  SizedBox(width: 5),
                  buildFilterChip("All", isSelectedAll, (isSelected) {
                    setState(() {
                      isSelectedAll = isSelected;
                      isSelectedMen = false;
                      isSelectedWomen = false;
                    });
                  }),
                  SizedBox(width: 5),
                  buildFilterChip("Men", isSelectedMen, (isSelected) {
                    setState(() {
                      isSelectedAll = false;
                      isSelectedMen = isSelected;
                      isSelectedWomen = false;
                    });
                  }),
                  SizedBox(width: 5),
                  buildFilterChip("Women", isSelectedWomen, (isSelected) {
                    setState(() {
                      isSelectedAll = false;
                      isSelectedMen = false;
                      isSelectedWomen = isSelected;
                    });
                  }),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5.0),
              child: Text("Official Store")
                  .text
                  .fontFamily(regular)
                  .size(14)
                  .make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                if (controller.vendors.isEmpty) {
                  return Center(child: Text('No vendors available'));
                }
                return Wrap(
                  spacing: 10,
                  children: controller.vendors.map((vendor) {
                    final isSelected = controller.selectedVendorId.value ==
                        vendor['vendor_id'];
                    return buildFilterChip(
                        vendor['name'] ?? 'Unknown', isSelected, (isSelected) {
                      setState(() {
                        if (isSelected) {
                          controller.updateFilters(
                              vendorId: vendor['vendor_id']);
                        } else {
                          controller.updateFilters(vendorId: '');
                        }
                      });
                    });
                  }).toList(),
                );
              }),
            ),
            5.heightBox,
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
            5.heightBox,
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
            5.heightBox,
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
              child: Text("Type of product")
                  .text
                  .fontFamily(regular)
                  .size(14)
                  .make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Center(
                child: Wrap(
                  spacing: 8,
                  children: [
                    buildFilterChip("Dress", isSelectedDress, (isSelected) {
                      setState(() => isSelectedDress = isSelected);
                    }),
                    buildFilterChip("T-Shirts", isSelectedTShirts,
                        (isSelected) {
                      setState(() => isSelectedTShirts = isSelected);
                    }),
                    buildFilterChip("Suits", isSelectedSuits, (isSelected) {
                      setState(() => isSelectedSuits = isSelected);
                    }),
                    buildFilterChip("Skirts", isSelectedSkirts, (isSelected) {
                      setState(() => isSelectedSkirts = isSelected);
                    }),
                    buildFilterChip("Pants", isSelectedPants, (isSelected) {
                      setState(() => isSelectedPants = isSelected);
                    }),
                    buildFilterChip("Jackets", isSelectedJackets, (isSelected) {
                      setState(() => isSelectedJackets = isSelected);
                    }),
                  ],
                ),
              ).paddingOnly(left: 13),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
              child:
                  Text("Collection").text.fontFamily(regular).size(14).make(),
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
                  buildFilterChip("Dinner", isSelectedDinner, (isSelected) {
                    setState(() => isSelectedDinner = isSelected);
                  }),
                  buildFilterChip("Everyday", isSelectedEveryday, (isSelected) {
                    setState(() => isSelectedEveryday = isSelected);
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
                    if (isSelectedDinner) 'dinner',
                    if (isSelectedEveryday) 'everydaylook',
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
