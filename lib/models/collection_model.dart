// To parse this JSON data, do
//
//     final collectionModel = collectionModelFromJson(jsonString);

import 'dart:convert';

CollectionModel collectionModelFromJson(String str) =>
    CollectionModel.fromJson(json.decode(str));

class CollectionModel {
  CollectionModel({
    required this.collections,
  });

  List<Collection> collections;

  factory CollectionModel.fromJson(Map<String, dynamic> json) =>
      CollectionModel(
        collections: List<Collection>.from(
            json["collections"].map((x) => Collection.fromJson(x))),
      );
}

class Collection {
  String name;
  List<String> subcollection;

  Collection({
    required this.name,
    required this.subcollection,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        name: json["name"],
        subcollection: List<String>.from(json["subcollection"].map((x) => x)),
      );
}
