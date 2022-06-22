import 'package:flutter/material.dart';
import 'package:rxdart_course/bloc/search_result.dart';
import 'package:rxdart_course/models/animal.dart';
import 'package:rxdart_course/models/person.dart';

class SearchResultView extends StatelessWidget {
  /// default constructor
  const SearchResultView({
    Key? key,
    required this.searchResult,
  }) : super(key: key);

  final Stream<SearchResult?> searchResult;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SearchResult?>(
        stream: searchResult,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final result = snapshot.data;
            if (result is SearchResultHasError) {
              return const Text('Got error');
            } else if (result is SearchResultLoading) {
              return CircularProgressIndicator();
            } else if (result is SearchResultNoResult) {
              return Text('No result found');
            } else if (result is SearchResultWithResults) {
              final results = result.results;
              return Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (_, index) {
                    final item = results[index];
                    final String title;
                    if (item is Animal) {
                      title = 'Animal';
                    } else if (item is Person) {
                      title = 'Person';
                    } else {
                      title = 'Unknown';
                    }

                    return ListTile(
                      title: Text(title),
                      subtitle: Text(item.toString()),
                    );
                  },
                ),
              );
            } else {
              return const Text('Unknown state!');
            }
          }
          return const Text('Waiting');
        });
  }
}
