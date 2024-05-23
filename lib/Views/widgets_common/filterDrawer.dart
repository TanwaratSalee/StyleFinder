import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/firebase_consts.dart';
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
    {'name': 'Green', 'color': const Color.fromARGB(255, 17, 82, 50)},
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Gender").text.fontFamily(regular).size(14).make(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  SizedBox(width: 8),
                  buildFilterChip("All", isSelectedAll, (isSelected) {
                    setState(() => isSelectedAll = isSelected);
                  }),
                  SizedBox(width: 8),
                  buildFilterChip("Men", isSelectedMen, (isSelected) {
                    setState(() => isSelectedMen = isSelected);
                  }),
                  SizedBox(width: 8),
                  buildFilterChip("Women", isSelectedWomen, (isSelected) {
                    setState(() => isSelectedWomen = isSelected);
                  }),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Official Store")
                  .text
                  .fontFamily(regular)
                  .size(14)
                  .make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Price").text.fontFamily(regular).size(14).make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: primaryApp,
                  inactiveTrackColor: greyLine,
                  thumbColor: greyDark,
                  overlayColor: Color.fromARGB(255, 81, 150, 175).withAlpha(32),
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
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Color").text.fontFamily(regular).size(14).make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                children: List.generate(
                  15,
                  (index) => Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.primaries[index % Colors.primaries.length],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Type of product")
                  .text
                  .fontFamily(regular)
                  .size(14)
                  .make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 10,
                children: [
                  FilterChip(
                    label: Text("Dress"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Outerwear & Coats"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("T-Shirts"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Suits"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Knitwear"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Activewear"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Blazers"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Pants"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Denim"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Skirts"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child:
                  Text("Collection").text.fontFamily(regular).size(14).make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 10,
                children: [
                  FilterChip(
                    label: Text("Summer"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Winter"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Autumn"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Dinner"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Everyday"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
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
    // backgroundColor: isSelected ? redColor : greyThin,
    side: BorderSide(color: isSelected ? primaryApp : greyLine),
    selectedColor: thinPrimaryApp,
  );
}
