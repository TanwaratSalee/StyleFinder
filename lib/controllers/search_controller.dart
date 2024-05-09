import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPageController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  var searchResults = <Map<String, dynamic>>[].obs;
  var searchHistory = <String>[].obs;
  RxBool searchInProgress = false.obs;
  RxBool searchPerformed = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSearchHistory();
  }

  Future<void> performSearch(String query) async {
    searchInProgress.value = true;
    try {
      final results = await FirebaseFirestore.instance
          .collection(productsCollection)
          .where('searchKeywords', arrayContains: query.toLowerCase())
          .get();

      searchResults.value = results.docs
          .map((doc) => doc.data())
          .toList();
      searchInProgress.value = false;
      if (searchResults.isNotEmpty) {
        searchPerformed.value = true;
      } else {
        searchPerformed.value = false;
      }
    } catch (e) {
      searchInProgress.value = false;
      searchPerformed.value = false;
      print("Error searching Firestore: $e");
    }
  }

  Future<void> loadSearchHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? history = prefs.getStringList('searchHistory');
    if (history != null) {
      searchHistory.value = history;
    }
  }

  Future<void> addToSearchHistory(String searchQuery) async {
    if (!searchHistory.contains(searchQuery)) {
      searchHistory.add(searchQuery);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('searchHistory', searchHistory);
    }
  }

  Future<void> clearSearchHistory() async {
    searchHistory.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('searchHistory');
  }
}