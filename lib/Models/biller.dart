import 'dart:convert';

Biller billerFromMap(String str) => Biller.fromMap(json.decode(str));

String billerToMap(Biller data) => json.encode(data.toMap());

class Biller {
    final String id;
    final String categoryId;
    final String logo;
    final String name;

    Biller({
        required this.id,
        required this.categoryId,
        required this.logo,
        required this.name,
    });

    factory Biller.fromMap(Map<String, dynamic> json) => Biller(
        id: json["id"],
        categoryId: json["categoryId"],
        logo: json["logo"],
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "categoryId": categoryId,
        "logo": logo,
        "name": name,
    };
}
