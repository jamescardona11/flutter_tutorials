import 'package:flutter/material.dart';
import 'package:rxdart_course_youtube/step1/step1.dart';

class HomePage extends StatefulWidget {
  /// default constructor
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final SearchBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc(api: Api());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  hintText: 'Enter your search term here'),
              onChanged: _bloc.search.add,
            ),
            SizedBox(height: 10),
            SearchResultView(
              searchResult: _bloc.results,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
