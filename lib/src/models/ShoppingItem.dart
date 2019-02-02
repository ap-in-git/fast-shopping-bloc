// To parse this JSON data, do
//
//     final shoppingItem = shoppingItemFromJson(jsonString);

import 'dart:convert';

ShoppingItem shoppingItemFromJson(String str) {
  final jsonData = json.decode(str);
  return ShoppingItem.fromJson(jsonData);
}

String shoppingItemToJson(ShoppingItem data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class ShoppingItem {
  int id;
  String name;
  bool completed;

  ShoppingItem({
    this.id,
    this.name,
    this.completed,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => new ShoppingItem(
        id: json["id"],
        name: json["name"],
        completed: json["completed"] == 1 ? true : false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "completed": completed ? 1 : 0,
      };
}
