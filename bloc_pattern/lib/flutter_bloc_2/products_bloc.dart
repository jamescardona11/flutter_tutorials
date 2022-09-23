import 'dart:async';

const Products = ['Mic', 'Cam', 'Keyboard'];

class ProductBloc {
  ProductBloc() {
    getProducts.listen((event) {
      _counterProducts.add(event.length);
    });
  }

  Stream<List<String>> get getProducts async* {
    final List<String> products = [];

    for (String prd in Products) {
      await Future.delayed(Duration(milliseconds: 1500));

      products.add(prd);

      yield products;
    }
  }

  StreamController<int> _counterProducts = StreamController<int>();

  Stream get counterStream => _counterProducts.stream;

  void close() {
    _counterProducts.close();
  }
}
