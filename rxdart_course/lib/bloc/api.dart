import 'dart:convert';
import 'dart:io';

import 'package:rxdart_course/models/animal.dart';
import 'package:rxdart_course/models/person.dart';
import 'package:rxdart_course/models/thing.dart';

typedef SearchTerm = String;

class Api {
  List<Animal>? _animals;
  List<Person>? _persons;

  Api();

  Future<List<Thing>> search(SearchTerm searchTerm) async {
    final term = searchTerm.trim().toLowerCase();

    final cachedResults = _extractThingUsingSearchTerm(term);
    if (cachedResults != null) {
      return cachedResults;
    }

    final persons =
        await _getJson('http://127.0.0.1:5500/apis/persons.json').then(
      (json) => json.map(
        (e) => Person.fromJson(e),
      ),
    );
    _persons = persons.toList();

    final animals =
        await _getJson('http://127.0.0.1:5500/apis/animals.json').then(
      (json) => json.map(
        (e) => Animal.fromJson(e),
      ),
    );

    _animals = animals.toList();

    return _extractThingUsingSearchTerm(term) ?? [];
  }

  List<Thing>? _extractThingUsingSearchTerm(SearchTerm term) {
    final cachedAnimals = _animals;
    final cachedPersons = _persons;

    if (cachedAnimals != null && cachedPersons != null) {
      List<Thing> result = [];
      for (var animal in cachedAnimals) {
        if (animal.name.trimmedContains(term) ||
            animal.type.name.trimmedContains(term)) {
          result.add(animal);
        }
      }

      for (var person in cachedPersons) {
        if (person.name.trimmedContains(term) ||
            person.age.toString().trimmedContains(term)) {
          result.add(person);
        }
      }

      return result;
    }

    return null;
  }

  Future<List<dynamic>> _getJson(String url) => HttpClient()
      .getUrl(Uri.parse(url))
      .then((req) => req.close())
      .then((res) => res.transform(utf8.decoder).join())
      .then((jsonString) => json.decode(jsonString) as List<dynamic>);
}

extension TrimmedCaseInsensitive on String {
  bool trimmedContains(String other) => trim().toLowerCase().contains(
        other.trim().toLowerCase(),
      );
}
