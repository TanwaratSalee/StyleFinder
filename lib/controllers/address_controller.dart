import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AddressController extends GetxController {
  RxList<String>? addresses = <String>[].obs;
  RxList<String>? addressesDocumentIds = <String>[].obs;
  List<String> loadedAddressesDocumentIds = [];
  final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    loadAddresses(currentUserUid);
  }

  Future<void> loadAddresses(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      List<String> loadedAddresses = [];
      if (documentSnapshot.exists) {
        String documentId = documentSnapshot.id;
        loadedAddressesDocumentIds.add(documentId);
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null &&
            data.containsKey('address') &&
            data['address'] is List) {
          List<dynamic> addressesList = data['address'];
          addressesList.forEach((address) {
            if (address is Map<String, dynamic>) {
              String formattedAddress = '${address['firstname']},${address['surname']},${address['address']},${address['city']},${address['state']},${address['postalCode']},${address['phone']}';
              loadedAddresses.add(formattedAddress);
            }
          });
        }
      }

      addresses?.value = loadedAddresses;
      addressesDocumentIds?.value = loadedAddressesDocumentIds;
    } catch (error) {
      print('Failed to load addresses for user $uid: $error');
    }
  }

  Future<void> removeAddress(String uid, int index) async {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      DocumentSnapshot documentSnapshot = await docRef.get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null &&
            data.containsKey('address') &&
            data['address'] is List) {
          List<dynamic> addressesList = List.from(data['address']);

          addressesList.removeAt(index);

          await docRef.update({'address': addressesList});

          await loadAddresses(uid);
        }
      }
    } catch (error) {
      print("Error removing address: $error");
    }
  }
}
