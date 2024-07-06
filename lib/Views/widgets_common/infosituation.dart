import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/styles.dart';

class SituationsList extends StatelessWidget {
  final Map<String, String> situationNames = {
    'formal': 'Formal Attire',
    'semi-formal': 'Semi-Formal Attire',
    'casual': 'Casual Attire',
    'special-activity': 'Special Activity Attire',
    'seasonal': 'Seasonal Attire',
    'work-from-home': 'Work from Home',
  };

  final Map<String, List<String>> subSituations = {
    'formal': [
      '  Formal Events',
      '   - Weddings',
      '   - Business Meetings',
      '   - Job Interviews',
      '   - Formal Springs',
      '   - Graduations',
    ],
    'semi-formal': [
      ' Social Events',
      '   - Night Parties',
      '   - Date Nights',
      '   - Family Gatherings',
      '   - Festivals and Holidays',
    ],
    'casual': [
      '  Everyday and Outdoor Activities',
      '   - Everyday Attire',
      '   - Daily Attire',
      '   - Casual Fridays',
      '   - Outdoor Picnics',
      '   - Traveling',
    ],
    'special-activity': [
      '  Sports and Leisure Activities',
      '   - Gym and Fitness',
      '   - Beach Outings',
      '   - Concerts and Events',
    ],
    'seasonal': [
      '  Seasonal Wear',
      '   - Winter Attire',
      '   - Summer Attire',
    ],
    'work-from-home': [
      '  Remote Work',
      '   - Work from Home',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: situationNames.keys.length,
        itemBuilder: (BuildContext context, int index) {
          String key = situationNames.keys.elementAt(index);
          return Theme(
            data: Theme.of(context).copyWith(dividerColor: greyLine), 
            child: ExpansionTile(
              title: Text(
                situationNames[key]!,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: medium,
                ),
              ),
              children: subSituations.containsKey(key)
                  ? subSituations[key]!
                      .map((subItem) => ListTile(
                            title: Text(
                              subItem,
                              style: TextStyle(
                                fontFamily: regular,
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList()
                  : [],
            ),
          );
        },
      ),
    );
  }
}
