import 'dart:convert';

Category categoryFromMap(String str) => Category.fromMap(json.decode(str));

String categoryToMap(Category data) => json.encode(data.toMap());

class Category {
    final String id;
    final String name;
    final String logo;

    Category({
        required this.id,
        required this.name,
        required this.logo,
    });

    factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        logo: json["logo"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "logo": logo,
    };
}