import 'package:flutter_finalproject/consts/consts.dart';

Widget loadingIndicator({double size = 50.0}) {
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(primaryApp),
  );
}

  // void showLoadingDialog() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(vertical: 20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               LoadingAnimationWidget.inkDrop(
  //                 color: primaryApp,
  //                 size: 50,
  //               ),
  //               const SizedBox(height: 20),
  //               const Text("Saving...", style: TextStyle(fontSize: 18)),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }