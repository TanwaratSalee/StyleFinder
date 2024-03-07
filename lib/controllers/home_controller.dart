import 'package:flutter_finalproject/consts/lists.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var cards = <String>[].obs; 

  @override
  void onInit() {
    super.onInit();
    cards.addAll(cardsImages); 
  }

  void removeCard(String card) {
    cards.remove(card);
  }
}
