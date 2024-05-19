// import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
// import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
// import 'package:flutter_finalproject/consts/consts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';

// class FirebaseService {
//   final CollectionReference usersCollection =
//       FirebaseFirestore.instance.collection('users');

//   Future<DocumentSnapshot> getCurrentUserAddress() async {
//     try {
//       String userId = currentUser!.uid;
//       DocumentSnapshot documentSnapshot =
//           await usersCollection.doc(userId).get();
//       return documentSnapshot;
//     } catch (error) {
//       throw error;
//     }
//   }

// Future<void> updateAddressForCurrentUser(String userId, String firstname, String surname, String address,
//     String city, String state, String postalCode, String phone) async {
//   try {
    
//     if (firstname.isNotEmpty &&
//     surname.isNotEmpty &&
//       address.isNotEmpty &&
//         city.isNotEmpty &&
//         state.isNotEmpty &&
//         postalCode.isNotEmpty &&
//         phone.isNotEmpty) {
      
//       DocumentSnapshot documentSnapshot =
//           await usersCollection.doc(currentUser!.uid).get();
//       if (documentSnapshot.exists) {
//         Map<String, dynamic>? userData =
//             documentSnapshot.data() as Map<String, dynamic>?;
//         if (userData != null) {
          
//           if (userData.containsKey('address')) {
            
//             List<dynamic>? addressList = List.from(userData['address']);
//             if (addressList == null) {
//               addressList = [];
//             }
            
//             addressList.add({
//               'firstname': firstname,
//               'surname': surname,
//               'address': address,
//               'city': city,
//               'state': state,
//               'postalCode': postalCode,
//               'phone': phone,
//             });
            
//             await usersCollection.doc(currentUser!.uid).update({
//               'address': addressList,
//             });
//           } else {
            
//             await usersCollection.doc(currentUser!.uid).update({
//               'address': [
//                 {
//                   'firstname': firstname,
//                   'surname': surname,
//                   'address': address,
//                   'city': city,
//                   'state': state,
//                   'postalCode': postalCode,
//                   'phone': phone,
//                 }
//               ],
//             });
//           }
//         }
//       }
//       print('Address updated successfully for user $userId');
//     } else {
//       print('One or more fields are empty. Failed to update address.');
//     }
//   } catch (error) {
//     print('Failed to update address: $error');
//   }
// }
// }
