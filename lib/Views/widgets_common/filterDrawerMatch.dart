import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/widgets_common/filterDrawer.dart';
import 'package:flutter_finalproject/Views/widgets_common/filterDrawerMatch.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
  bool isSelectedOuterwear = false;
  bool isSelectedTShirts = false;
  bool isSelectedSuits = false;
  bool isSelectedKnitwear = false;
  bool isSelectedActivewear = false;
  bool isSelectedBlazers = false;
  bool isSelectedPants = false;
  bool isSelectedDenim = false;
  bool isSelectedSkirts = false;
  bool isSelectedSummer = false;
  bool isSelectedWinter = false;
  bool isSelectedAutumn = false;
  bool isSelectedDinner = false;
  bool isSelectedEveryday = false;

  final selectedColorIndexes = <int>[].obs;
  final List<Map<String, dynamic>> allColors = [
    {'name': 'Black', 'color': blackColor, 'value': 0xFF000000},
    {'name': 'Grey', 'color': greyColor, 'value': 0xFF808080},
    {'name': 'White', 'color': whiteColor, 'value': 0xFFFFFFFF},
    {'name': 'Purple', 'color': Colors.purple, 'value': 0xFF800080},
    {'name': 'Deep Purple', 'color': Colors.deepPurple, 'value': 0xFF673AB7},
    {'name': 'Blue', 'color': Colors.lightBlue, 'value': 0xFF03A9F4},
    {
      'name': 'Blue',
      'color': const Color.fromARGB(255, 36, 135, 216),
      'value': 0xFF2487D8
    },
    {
      'name': 'Blue Grey',
      'color': const Color.fromARGB(255, 96, 139, 115),
      'value': 0xFF608B73
    },
    {
      'name': 'Green',
      'color': const Color.fromARGB(255, 17, 52, 50),
      'value': 0xFF113432
    },
    {'name': 'Green', 'color': Colors.green, 'value': 0xFF4CAF50},
    {'name': 'Green Accent', 'color': Colors.greenAccent, 'value': 0xFF69F0AE},
    {'name': 'Yellow', 'color': Colors.yellow, 'value': 0xFFFFEB3B},
    {'name': 'Orange', 'color': Colors.orange, 'value': 0xFFFF9800},
    {'name': 'Red', 'color': redColor, 'value': 0xFFFF0000},
    {
      'name': 'Red Accent',
      'color': const Color.fromARGB(255, 237, 101, 146),
      'value': 0xFFED6592
    },
  ];

  @override
  void initState() {
    super.initState();
    isSelectedAll = controller.selectedGender.value == '';
    isSelectedMen = controller.selectedGender.value == 'male';
    isSelectedWomen = controller.selectedGender.value == 'female';
    _currentSliderValue = controller.maxPrice.value;
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
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
                    final isSelected = controller.selectedVendorId.value == vendor['vendor_id'];
                    return buildFilterChip(vendor['vendor_name'] ?? 'Unknown', isSelected, (isSelected) {
                      setState(() {
                        if (isSelected) {
                          controller.updateFilters(vendorId: vendor['vendor_id']);
                        } else {
                          controller.updateFilters(vendorId: '');
                        }
                      });
                    });
                  }).toList(),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
              child: Text("Price").text.fontFamily(regular).size(14).make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: primaryApp,
                  inactiveTrackColor: greyLine,
                  thumbColor: greyDark,
                  overlayColor: Color.fromARGB(255, 51, 150, 175).withAlpha(32),
                  trackHeight: 4.0,
                ),
                child: Slider(
                  value: _currentSliderValue,
                  min: 0,
                  max: 999999,
                  divisions: 100,
                  label: "${_currentSliderValue.round()} Bath",
                  onChanged: (value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
              child: Text("Color").text.fontFamily(regular).size(14).make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 20,
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
                        width: 30,
                        height: 30,
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
            SizedBox(
              height: 20,
            ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Wrap(
                  spacing: 5,
                  children: [
                    buildFilterChip("Dress", isSelectedDress, (isSelected) {
                      setState(() => isSelectedDress = isSelected);
                    }),
                    buildFilterChip("Outerwear & Coats", isSelectedOuterwear,
                        (isSelected) {
                      setState(() => isSelectedOuterwear = isSelected);
                    }),
                    buildFilterChip("T-Shirts", isSelectedTShirts,
                        (isSelected) {
                      setState(() => isSelectedTShirts = isSelected);
                    }),
                    buildFilterChip("Suits", isSelectedSuits, (isSelected) {
                      setState(() => isSelectedSuits = isSelected);
                    }),
                    buildFilterChip("Knitwear", isSelectedKnitwear,
                        (isSelected) {
                      setState(() => isSelectedKnitwear = isSelected);
                    }),
                    buildFilterChip("Activewear", isSelectedActivewear,
                        (isSelected) {
                      setState(() => isSelectedActivewear = isSelected);
                    }),
                    buildFilterChip("Blazers", isSelectedBlazers, (isSelected) {
                      setState(() => isSelectedBlazers = isSelected);
                    }),
                    buildFilterChip("Pants", isSelectedPants, (isSelected) {
                      setState(() => isSelectedPants = isSelected);
                    }),
                    buildFilterChip("Denim", isSelectedDenim, (isSelected) {
                      setState(() => isSelectedDenim = isSelected);
                    }),
                    buildFilterChip("Skirts", isSelectedSkirts, (isSelected) {
                      setState(() => isSelectedSkirts = isSelected);
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
              child:
                  Text("Collection").text.fontFamily(regular).size(14).make(),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    buildFilterChip("Everyday", isSelectedEveryday,
                        (isSelected) {
                      setState(() => isSelectedEveryday = isSelected);
                    }),
                  ],
                ),
              ),
            ),


          ElevatedButton(
            onPressed: () {
              String selectedGender = '';
              if (isSelectedMen) {
                selectedGender = 'male';
              } else if (isSelectedWomen) {
                selectedGender = 'female';
              }

                controller.updateFilters(
                  gender: selectedGender,
                  price: _currentSliderValue,
                  colors: selectedColorIndexes,
                  types: [
                    if (isSelectedDress) 'dresses',
                    if (isSelectedOuterwear) 'outerwear & Costs',
                    if (isSelectedSkirts) 'skirts',
                    if (isSelectedTShirts) 't-shirts',
                    if (isSelectedSuits) 'suits',
                    if (isSelectedKnitwear) 'knitwear',
                    if (isSelectedActivewear) 'activewear',
                    if (isSelectedBlazers) 'blazers',
                    if (isSelectedDenim) 'denim',
                  ],
                  collections: [
                    if (isSelectedSummer) 'summer',
                    if (isSelectedWinter) 'winter',
                    if (isSelectedAutumn) 'autumn',
                    if (isSelectedDinner) 'dinner',
                    if (isSelectedEveryday) 'everydaylook',
                  ],
                );
                
              // Print the selected vendor name before fetching filtered products
              final selectedVendor = controller.vendors.firstWhere(
                (vendor) => vendor['vendor_id'] == controller.selectedVendorId.value,
                orElse: () => {'vendor_name': 'Unknown'}
              );
              print("Selected vendor name: ${selectedVendor['vendor_name']}");
              print("Selected Vendor ID: ${controller.selectedVendorId.value}");

              controller.fetchFilteredTopProducts();
              controller.fetchFilteredLowerProducts();

              Navigator.pop(context);
            },
            child: Text('Apply Filters'),
          ),
          ],
        ).box.white.padding(EdgeInsets.symmetric(vertical: 12)).make(),
      ),
    );
  }


  Widget buildFilterChip(String label, bool isSelected, Function(bool) onSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      showCheckmark: false,
      side: BorderSide(color: isSelected ? primaryApp : greyLine),
      selectedColor: thinPrimaryApp,
    );
  }
}