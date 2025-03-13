// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    String? name;
    String? image;
    String? email;
    String? phoneNumber;
    DateTime? dob;
    String? gender;
    dynamic passport;

    UserModel({
        this.name,
        this.image,
        this.email,
        this.phoneNumber,
        this.dob,
        this.gender,
        this.passport,
    });

    UserModel copyWith({
        String? name,
        String? image,
        String? email,
        String? phoneNumber,
        DateTime? dob,
        String? gender,
        dynamic passport,
    }) => 
        UserModel(
            name: name ?? this.name,
            image: image ?? this.image,
            email: email ?? this.email,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            dob: dob ?? this.dob,
            gender: gender ?? this.gender,
            passport: passport ?? this.passport,
        );

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        image: json["image"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        gender: json["gender"],
        passport: json["passport"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "email": email,
        "phoneNumber": phoneNumber,
        "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "passport": passport,
    };
}
