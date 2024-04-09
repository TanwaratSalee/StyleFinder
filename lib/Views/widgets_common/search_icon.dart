import 'package:flutter_finalproject/Views/search_screen/search_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';

Widget IconSearch({context}) {
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
            barrierDismissible: true,
            barrierColor: Colors.black.withOpacity(0.5),
            transitionDuration: const Duration(milliseconds: 300),
            context: context,
            pageBuilder: (_, __, ___) {
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: const SearchScreenPage(), // Make sure this is your actual search screen widget
                  decoration: const BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                ),
              );
            },
            transitionBuilder: (context, anim1, anim2, child) {
              return SlideTransition(
                position: Tween(
                  begin: const Offset(0, -1),
                  end: const Offset(0, 0),
                ).animate(anim1),
                child: child,
              );
            },
          );
        },
      ),
    );
  }
