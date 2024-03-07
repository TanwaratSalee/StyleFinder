import 'package:flutter_finalproject/consts/consts.dart';

Widget loadingIndcator() {
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(primaryApp),
  );
}