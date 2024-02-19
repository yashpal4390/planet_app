// To parse this JSON data, do
//
//     final planet = planetFromJson(jsonString);

import 'dart:convert';

List<Planet> planetFromJson(String str) => List<Planet>.from(json.decode(str).map((x) => Planet.fromJson(x)));

String planetToJson(List<Planet> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Planet {
  String? position;
  String? name;
  String? type;
  String? radius;
  String? orbitalPeriod;
  String? gravity;
  String? velocity;
  String? distance;
  String? description;
  String? image;

  Planet({
    this.position,
    this.name,
    this.type,
    this.radius,
    this.orbitalPeriod,
    this.gravity,
    this.velocity,
    this.distance,
    this.description,
    this.image,
  });

  factory Planet.fromJson(Map<String, dynamic> json) => Planet(
    position: json["position"],
    name: json["name"],
    type: json["type"],
    radius: json["radius"],
    orbitalPeriod: json["orbital_period"],
    gravity: json["gravity"],
    velocity: json["velocity"],
    distance: json["distance"],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "position": position,
    "name": name,
    "type": type,
    "radius": radius,
    "orbital_period": orbitalPeriod,
    "gravity": gravity,
    "velocity": velocity,
    "distance": distance,
    "description": description,
    "image": image,
  };
}
