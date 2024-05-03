import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MarqueeWidget extends StatelessWidget {
  final Widget child;

  MarqueeWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
              child: child,
            ),
          ),
          SizedBox(width: 16), // Adjust as needed
        ],
      ),
    );
  }
}
