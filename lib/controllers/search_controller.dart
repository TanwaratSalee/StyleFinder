import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPageController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  var searchHistory = <String>[].obs;
  RxBool searchInProgress = false.obs;
  RxBool searchPerformed = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSearchHistory();
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
