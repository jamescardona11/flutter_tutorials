import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart_course/step1/step1.dart';

enum AnimalType { dog, cat, rabbit, unknown }

extension AnimalTypeX on AnimalType {
  static AnimalType fromString(String type) =>
      {
        'dog': AnimalType.dog,
        'cat': AnimalType.cat,
        'rabbit': AnimalType.rabbit,
        'unknown': AnimalType.unknown,
      }[type.toLowerCase().trim()] ??
      AnimalType.unknown;
}

@immutable
class Animal extends Thing {
  final AnimalType type;

  Animal({
    required String name,
    required this.type,
  }) : super(name: name);

  factory Animal.fromJson(Map<String, dynamic> json) => Animal(
        name: json['name'] as String,
        type: AnimalTypeX.fromString(json['type'] as String),
      );

  @override
  String toString() => 'Animal(name: $name, type: $type)';
}
