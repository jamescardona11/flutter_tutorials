import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart_course/step1/step1.dart';

@immutable
abstract class SearchResult {
  SearchResult();
}

@immutable
class SearchResultLoading implements SearchResult {
  SearchResultLoading() : super();
}

@immutable
class SearchResultNoResult implements SearchResult {
  SearchResultNoResult() : super();
}

@immutable
class SearchResultHasError implements SearchResult {
  final Object error;
  SearchResultHasError(this.error) : super();
}

@immutable
class SearchResultWithResults implements SearchResult {
  final List<Thing> results;
  SearchResultWithResults(this.results) : super();
}
