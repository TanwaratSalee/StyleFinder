// // Controller
// class VendorController extends GetxController {
//   var vendorImageUrl = ''.obs;
//   var vendorName = ''.obs;

//   Future<void> fetchVendorInfo(String vendorId) async {
//     try {
//       DocumentSnapshot vendorSnapshot = await firestore.collection(vendersCollection).doc(vendorId).get();
//       if (vendorSnapshot.exists) {
//         var vendorData = vendorSnapshot.data() as Map<String, dynamic>;
//         vendorImageUrl.value = vendorData['imageUrl'] ?? '';
//         vendorName.value = vendorData['vendor_name'] ?? '';
//       }
//     } catch (e) {
//       print("Failed to fetch vendor info: $e");
//     }
//   }
// }

// // UI Widget
// class VendorInfoRow extends StatelessWidget {
//   final VendorController controller = Get.put(VendorController());
//   final String vendorId;

//   VendorInfoRow({required this.vendorId}) {
//     controller.fetchVendorInfo(vendorId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Row(
//             children: [
//               5.widthBox,
//               Obx(() {
//                 String imageUrl = controller.vendorImageUrl.value;
//                 return imageUrl.isNotEmpty
//                     ? ClipOval(
//                         child: Image.network(
//                           imageUrl,
//                           width: 45,
//                           height: 45,
//                           fit: BoxFit.cover,
//                         ),
//                       )
//                         .box
//                         .border(color: greyLine)
//                         .roundedFull
//                         .make()
//                     : Icon(
//                         Icons.person,
//                         color: whiteColor,
//                         size: 22,
//                       );
//               }),
//               10.widthBox,
//               Expanded(
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Obx(() {
//                     return controller.vendorName.isNotEmpty
//                         ? controller.vendorName.value
//                             .toUpperCase()
//                             .text
//                             .fontFamily(medium)
//                             .color(blackColor)
//                             .size(18)
//                             .make()
//                         : Container();
//                   }),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
