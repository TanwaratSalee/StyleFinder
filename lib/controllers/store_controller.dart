import 'package:get/get.dart';

class StoreController extends GetxController {
  var tabIndex = 0.obs;
  var selectedSegment = 'Product'.obs;

  void changeSelectedSegment(String segment) {
    selectedSegment.value = segment;
  }
}
