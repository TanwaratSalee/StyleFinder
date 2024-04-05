import 'package:flutter_finalproject/consts/consts.dart';

Widget loadingIndicator() {
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(primaryApp),
  );
}
