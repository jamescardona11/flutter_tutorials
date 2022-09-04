import 'nautilus_page.dart';

class Stack {
  List<ElevenNavPage> _list = <ElevenNavPage>[];
  // final _list2 = Queue<ElevenNavPage>();

  void push(ElevenNavPage value) => _list.add(value);

  void pop() => _list.removeLast();

  void clear() => _list.clear();

  void removeUntil(String name, {Function? orElse}) {
    final index = _list.indexWhere((element) => element.name == name);
    if (index == -1) {
      orElse?.call();
      return;
    }

    _list = _list.sublist(0, index);
  }

  void removeToFirst() {
    _list = _list.take(1).toList();
  }

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  String toString() => _list.toString();
}
