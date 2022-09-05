import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart_course/step1/step1.dart';

@immutable
class Person extends Thing {
  final int age;

  Person({
    required String name,
    required this.age,
  }) : super(name: name);

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        name: json['name'] as String,
        age: json['age'] as int,
      );

  @override
  String toString() => 'Person(name: $name, age: $age)';
}
