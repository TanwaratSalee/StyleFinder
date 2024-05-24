import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';

class FilterDrawer extends StatefulWidget {
  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
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
  var collectionsvalue = ''.obs;

  final selectedColorIndexes = <int>[].obs;
  final List<Map<String, dynamic>> allColors = [
    {'name': 'Black', 'color': Colors.black},
    {'name': 'Grey', 'color': greyColor},
    {'name': 'White', 'color': whiteColor},
    {'name': 'Purple', 'color': Colors.purple},
    {'name': 'Deep Purple', 'color': Colors.deepPurple},
    {'name': 'Blue', 'color': Colors.lightBlue},
    {'name': 'Blue', 'color': const Color.fromARGB(255, 36, 135, 216)},
    {'name': 'Blue Grey', 'color': const Color.fromARGB(255, 96, 139, 115)},
    {'name': 'Green', 'color': const Color.fromARGB(255, 17, 52, 50)},
    {'name': 'Green', 'color': Colors.green},
    {'name': 'Green Accent', 'color': Colors.greenAccent},
    {'name': 'Yellow', 'color': Colors.yellow},
    {'name': 'Orange', 'color': Colors.orange},
    {'name': 'Red', 'color': redColor},
    {'name': 'Red Accent', 'color': const Color.fromARGB(255, 237, 101, 146)},
  ];

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
                    setState(() => isSelectedAll = isSelected);
                  }),
                  SizedBox(width: 5),
                  buildFilterChip("Men", isSelectedMen, (isSelected) {
                    setState(() => isSelectedMen = isSelected);
                  }),
                  SizedBox(width: 5),
                  buildFilterChip("Women", isSelectedWomen, (isSelected) {
                    setState(() => isSelectedWomen = isSelected);
                  }),
                ],
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                children: List.generate(
                  6,
                  (index) => CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
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
                    final isSelected = selectedColorIndexes.contains(index);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedColorIndexes.remove(index);
                          } else {
                            selectedColorIndexes.add(index);
                          }
                        });
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: color['color'],
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(
                            color: isSelected ? primaryApp : greyThin,
                            width: isSelected ?  2 : 1,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            10.heightBox,
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
              child: Wrap(
                spacing: 10,
                children: [
                  buildFilterChip("Dress", isSelectedDress, (isSelected) {
                    setState(() => isSelectedDress = isSelected);
                  }),
                  buildFilterChip("Outerwear & Coats", isSelectedOuterwear,
                      (isSelected) {
                    setState(() => isSelectedOuterwear = isSelected);
                  }),
                  buildFilterChip("T-Shirts", isSelectedTShirts, (isSelected) {
                    setState(() => isSelectedTShirts = isSelected);
                  }),
                  buildFilterChip("Suits", isSelectedSuits, (isSelected) {
                    setState(() => isSelectedSuits = isSelected);
                  }),
                  buildFilterChip("Knitwear", isSelectedKnitwear, (isSelected) {
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
              child: Text("Collection").text.fontFamily(regular).size(14).make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
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
            ),
          ],
        ).box.white.padding(EdgeInsets.symmetric(vertical: 12)).make(),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> fetchProducts() async {
  return FirestoreServices.getFeaturedProducts();
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
  List<dynamic> wishlist = product['p_wishlist'];
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
