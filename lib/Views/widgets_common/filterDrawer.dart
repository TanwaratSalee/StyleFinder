import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FilterDrawer extends StatefulWidget {
  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  final HomeController controller = Get.find<HomeController>();
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

  var collectionsvalue = ''.obs;
  var vendors = <Map<String, dynamic>>[];
  var selectedVendorIds = <String>[].obs;

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
    _currentSliderValue = controller.maxPrice.value.clamp(10, 99999).toDouble();
    isSelectedAll = controller.selectedGender.value == '';
    isSelectedMen = controller.selectedGender.value == 'man';
    isSelectedWomen = controller.selectedGender.value == 'woman';

    fetchVendors().then((data) {
      setState(() {
        vendors = data;
      });
    });

    selectedVendorIds.addAll(controller.selectedVendorIds);
    selectedColorIndexes.addAll(controller.selectedColors);

    isSelectedSkirts = controller.selectedTypes.contains('dresses');
    isSelectedTShirts = controller.selectedTypes.contains('t-shirts');
    isSelectedPants = controller.selectedTypes.contains('pants');
    isSelectedJackets = controller.selectedTypes.contains('jackets');
    isSelectedSkirts = controller.selectedTypes.contains('skirts');
    isSelectedSuits = controller.selectedTypes.contains('suits');

    isSelectedSummer = controller.selectedCollections.contains('summer');
    isSelectedWinter = controller.selectedCollections.contains('winter');
    isSelectedAutumn = controller.selectedCollections.contains('autumn');
    isSelectedDinner = controller.selectedCollections.contains('dinner');
    isSelectedEveryday =
        controller.selectedCollections.contains('everydaylook');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            40.heightBox,
            ListTile(
              title: Text(
                "Filter products",
              ).text.size(24).fontFamily(medium).makeCentered(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("Gender").text.fontFamily(regular).size(14).make(),
            ),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
                child: Row(
                  children: [
                    SizedBox(width: 5),
                    buildFilterChip("All", isSelectedAll, (isSelected) {
                      setState(() {
                        isSelectedAll = isSelected;
                        if (isSelected) {
                          isSelectedMen = false;
                          isSelectedWomen = false;
                        }
                      });
                    }),
                    SizedBox(width: 5),
                    buildFilterChip("Men", isSelectedMen, (isSelected) {
                      setState(() {
                        isSelectedMen = isSelected;
                        if (isSelected) {
                          isSelectedAll = false;
                          isSelectedWomen = false;
                        }
                      });
                    }),
                    SizedBox(width: 5),
                    buildFilterChip("Women", isSelectedWomen, (isSelected) {
                      setState(() {
                        isSelectedWomen = isSelected;
                        if (isSelected) {
                          isSelectedAll = false;
                          isSelectedMen = false;
                        }
                      });
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
              child: Text("Official Store")
                  .text
                  .fontFamily(regular)
                  .size(14)
                  .make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 10,
                children: vendors.map((vendor) {
                  final isSelected =
                      selectedVendorIds.contains(vendor['vendor_id']);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedVendorIds.remove(vendor['vendor_id']);
                        } else {
                          selectedVendorIds.add(vendor['vendor_id']);
                        }
                        controller.updateFilters(vendorIds: selectedVendorIds);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? primaryApp : greyLine,
                        ),
                        color: isSelected ? thinPrimaryApp : Colors.transparent,
                      ),
                      child: Text(
                        vendor['name'] ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? blackColor : blackColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            5.heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: primaryApp,
                inactiveTrackColor: greyLine,
                thumbColor: greyDark,
                overlayColor: thinPrimaryApp,
                trackHeight: 4.0,
              ),
              child: Slider(
                value: _currentSliderValue,
                min: 10,
                max: 99999,
                divisions: 150,
                label:
                    "${NumberFormat('#,###').format(_currentSliderValue.round())} Bath",
                onChanged: (value) {
                  setState(() {
                    _currentSliderValue = value.clamp(10, 99999);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("Color").text.fontFamily(regular).size(14).make(),
            ),
            5.heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Wrap(
                spacing: 12,
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
                          controller.updateFilters(
                              colors: selectedColorIndexes);
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
                            width: isSelected ? 3 : 2,
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
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Center(
                child: Wrap(
                  spacing: 8,
                  children: [
                    buildFilterChip("Dress", isSelectedDress, (isSelected) {
                      setState(() {
                        isSelectedDress = isSelected;
                        updateFilterTypes();
                      });
                    }),
                    buildFilterChip("T-Shirts", isSelectedTShirts,
                        (isSelected) {
                      setState(() {
                        isSelectedTShirts = isSelected;
                        updateFilterTypes();
                      });
                    }),
                    buildFilterChip("Suits", isSelectedSuits, (isSelected) {
                      setState(() {
                        isSelectedSuits = isSelected;
                        updateFilterTypes();
                      });
                    }),
                    buildFilterChip("Jackets", isSelectedJackets, (isSelected) {
                      setState(() {
                        isSelectedJackets = isSelected;
                        updateFilterTypes();
                      });
                    }),
                    buildFilterChip("Pants", isSelectedPants, (isSelected) {
                      setState(() {
                        isSelectedPants = isSelected;
                        updateFilterTypes();
                      });
                    }),
                    buildFilterChip("Skirts", isSelectedSkirts, (isSelected) {
                      setState(() {
                        isSelectedSkirts = isSelected;
                        updateFilterTypes();
                      });
                    }),
                  ],
                ),
              ),
            ),
            5.heightBox,
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
              child:
                  Text("Collection").text.fontFamily(regular).size(14).make(),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Wrap(
                  spacing: 6,
                  children: [
                    buildFilterChip("Summer", isSelectedSummer, (isSelected) {
                      setState(() {
                        isSelectedSummer = isSelected;
                        updateFilterCollections();
                      });
                    }),
                    buildFilterChip("Winter", isSelectedWinter, (isSelected) {
                      setState(() {
                        isSelectedWinter = isSelected;
                        updateFilterCollections();
                      });
                    }),
                    buildFilterChip("Autumn", isSelectedAutumn, (isSelected) {
                      setState(() {
                        isSelectedAutumn = isSelected;
                        updateFilterCollections();
                      });
                    }),
                    buildFilterChip("Dinner", isSelectedDinner, (isSelected) {
                      setState(() {
                        isSelectedDinner = isSelected;
                        updateFilterCollections();
                      });
                    }),
                    buildFilterChip("Everyday", isSelectedEveryday,
                        (isSelected) {
                      setState(() {
                        isSelectedEveryday = isSelected;
                        updateFilterCollections();
                      });
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      Get.find<HomeController>().updateFilters(
                        gender: isSelectedMen
                            ? 'men'
                            : isSelectedWomen
                                ? 'women'
                                : '',
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
                        vendorIds: selectedVendorIds,
                      );
                      Navigator.pop(context);
                    },
                    child: Text(
                      ' SAVE ',
                      style: TextStyle(color: whiteColor),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryApp,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ))),
              ),
            ),
          ],
        ).box.white.padding(EdgeInsets.symmetric(vertical: 8)).make(),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchVendors() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('vendors').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching vendors: $e");
      return [];
    }
  }

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

  void updateFilterCollections() {
    List<String> collections = [];
    if (isSelectedSummer) collections.add('summer');
    if (isSelectedWinter) collections.add('winter');
    if (isSelectedAutumn) collections.add('autumn');
    if (isSelectedDinner) collections.add('dinner');
    if (isSelectedEveryday) collections.add('everydaylook');

    controller.updateFilters(collections: collections);
  }
}

Future<List<Map<String, dynamic>>> fetchProducts({
  String? gender,
  double? maxPrice,
  List<int>? selectedColors,
  List<String>? selectedTypes,
  List<String>? selectedCollections,
  List<String>? vendorIds,
}) async {
  Query<Map<String, dynamic>> query =
      FirebaseFirestore.instance.collection(productsCollection);

  if (gender != null && gender.isNotEmpty) {
    query = query.where('gender', isEqualTo: gender);
  }

  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
    List<Map<String, dynamic>> products =
        snapshot.docs.map((doc) => doc.data()).toList();

    // Convert price to numeric and filter
    if (maxPrice != null) {
      products = products.where((product) {
        double productPrice = double.tryParse(product['price'] ?? '0') ?? 0;
        return productPrice <= maxPrice;
      }).toList();
    }

    // Filter by colors
    if (selectedColors != null && selectedColors.isNotEmpty) {
      products = products.where((product) {
        List<dynamic> productColors = product['colors'];
        return selectedColors.any((color) => productColors.contains(color));
      }).toList();
    }

    // Filter by types
    if (selectedTypes != null && selectedTypes.isNotEmpty) {
      products = products.where((product) {
        String productType = product['subcollection'];
        return selectedTypes.contains(productType);
      }).toList();
    }

    if (vendorIds != null && vendorIds.isNotEmpty) {
      products = products.where((product) {
        return vendorIds.contains(product['vendor_id']);
      }).toList();
    }

    // Filter by collections
    if (selectedCollections != null && selectedCollections.isNotEmpty) {
      products = products.where((product) {
        List<dynamic> productCollections = product['collection'];
        return selectedCollections
            .any((collection) => productCollections.contains(collection));
      }).toList();
    }

    return products;
  } catch (e) {
    print("Error fetching products: $e");
    return [];
  }
}

class FirestoreServices {
  static Future<List<Map<String, dynamic>>> getFeaturedProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection(productsCollection).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching featured products: $e");
      return [];
    }
  }
}

bool isInWishlist(Map<String, dynamic> product, String currentUid) {
  List<dynamic> wishlist = product['favorite_uid'];
  return wishlist.contains(currentUid);
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
  );
}
