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