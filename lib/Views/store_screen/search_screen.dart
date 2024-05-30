import 'package:flutter_finalproject/Views/search_screen/recent_search_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';

Widget IconSearchScreen({required BuildContext context}) { 
  return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: IconButton(
        icon: Image.asset(
          icSearch,
          width: 23,
        ),
        onPressed: () {
          showGeneralDialog(
            barrierLabel: "Barrier",
            context: context,
            pageBuilder: (_, __, ___) {
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height ,
                  child: const SearchScreenPage(), 
                  decoration: const BoxDecoration(
                    color: whiteColor,
                  ),
                  padding: const EdgeInsets.all(20),
                ),
              );
            },
            
          );
        },
      ),
    );
  }
