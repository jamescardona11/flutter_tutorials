// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: DojoProvider<ExampleDojoRoom, StateToTest>(
        dojo: ExampleDojoRoom(StateToTest()),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  /// default constructor
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DojoBuilder<ExampleDojoRoom, StateToTest>(
                    builder: (context, state) {
                      print('BUILDER READ');
                      return Text('HomePages ${state.count}');
                    },
                  ),
                  Builder(
                    builder: (context) {
                      print('BUILDER NormalWith S');
                      final count = Dojo.select<StateToTest, int>(
                          context, (state) => state.count);
                      return Text('HomePage ${count} as');
                    },
                  ),
                  DojoSelect<ExampleDojoRoom, StateToTest, String>(
                    builder: (context, state) {
                      print('BUILDER Select');
                      return Text('Select ${state}');
                    },
                    selector: (state) => state.flag,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            /// The action is executed in the [ApplicationContext].
            onPressed: () {
              // final dojo = Dojo.read<ExampleDojoRoom, StateToTest>(context);
              // dojo.increment();
              Dojo.dispatch<ExampleDojoRoom, StateToTest>(
                context,
                ActionTest1(),
              );
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(width: 5),
          FloatingActionButton(
            /// The action is executed in the [ApplicationContext].
            onPressed: () {
              final dojo = Dojo.read<ExampleDojoRoom, StateToTest>(context);
              dojo.flag();
            },
            tooltip: 'Flag',
            child: Icon(Icons.flag),
          ),
        ],
      ),
    );
  }
}

class ActionTest extends Action {}

class ActionTest1 extends ActionTest {}

class ActionTest2 extends ActionTest {}

class StateToTest {
  final int count;
  final String flag;

  StateToTest({
    this.count = 0,
    this.flag = '',
  });

  StateToTest copyWith({
    int? count,
    String? flag,
  }) {
    return StateToTest(
      count: count ?? this.count,
      flag: flag ?? this.flag,
    );
  }

  @override
  bool operator ==(covariant StateToTest other) {
    if (identical(this, other)) return true;

    return other.count == count && other.flag == flag;
  }

  @override
  int get hashCode => count.hashCode ^ flag.hashCode;
}

class ExampleDojoRoom extends DojoRoom<StateToTest> {
  ExampleDojoRoom(super.initialState);

  void increment() {
    print('INCREMENT');
    dispatch(
      state.copyWith(
        count: state.count + 1,
      ),
    );
  }

  void flag() {
    print('Flag');
    dispatch(
      state.copyWith(
        flag: '${state.count}',
      ),
    );
  }

  @override
  Future<void> onDojoAction(Action action) async {
    if (action is ActionTest1) {
      increment();
    } else {
      flag();
    }
  }
}

// ---------------------------DOJO

typedef DBuilder<DState> = Widget Function(BuildContext context, DState state);

class DojoBuilder<DRoom extends DojoRoom<DState>, DState>
    extends StatelessWidget {
  /// default constructor
  const DojoBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final DBuilder<DState> builder;

  @override
  Widget build(BuildContext context) {
    final dojo = Dojo.read<DRoom, DState>(context);
    return builder.call(context, dojo.state);
  }
}

typedef SBuilder<SelectedState> = Widget Function(
  BuildContext context,
  SelectedState data,
);

class DojoSelect<DRoom extends DojoRoom<DState>, DState, SelectedState>
    extends StatelessWidget {
  /// default constructor
  const DojoSelect({
    Key? key,
    required this.builder,
    required this.selector,
  }) : super(key: key);

  final SBuilder<SelectedState> builder;
  final Selector<DState, SelectedState> selector;

  @override
  Widget build(BuildContext context) {
    final dojo = Dojo.read<DRoom, DState>(context);
    return builder.call(context, selector(dojo.state));
  }
}

//event
abstract class Action<DState> {
  const Action();
}

class GenericStateChangeAction<DState> extends Action<DState> {
  final DState newState;
  const GenericStateChangeAction(this.newState);
}

/// inherited widget
class DojoGym<DRoom extends DojoRoom<DState>, DState> extends InheritedWidget {
  const DojoGym({
    super.key,
    required super.child,
    required this.dojoRoom,
  });

  final DRoom dojoRoom;

  static DojoRoom of<DRoom extends DojoRoom<DState>, DState>(
      BuildContext context) {
    final gym =
        context.dependOnInheritedWidgetOfExactType<DojoGym<DRoom, DState>>();

    if (gym == null) {
      //todo THROW
    }

    return gym!.dojoRoom;
  }

  @override
  bool updateShouldNotify(DojoGym oldWidget) {
    return true;
  }
}

/// inherited model
class DojoSelector<DState> extends InheritedModel<Selector> {
  const DojoSelector({
    super.key,
    required this.state,
    required super.child,
  });

  final DState state;

  @override
  bool updateShouldNotify(covariant DojoSelector<DState> oldWidget) {
    return state != oldWidget.state;
  }

  @override
  bool updateShouldNotifyDependent(
      covariant DojoSelector<DState> oldWidget, Set<Selector> dependencies) {
    return dependencies.any(
      (selector) => selector(oldWidget.state) != selector(state),
    );
  }
}

class DojoProvider<DRoom extends DojoRoom<DState>, DState>
    extends StatefulWidget {
  const DojoProvider({
    super.key,
    required this.dojo,
    required this.child,
  });

  final DRoom dojo;
  final Widget child;

  @override
  State<DojoProvider<DRoom, DState>> createState() =>
      _DojoProviderState<DRoom, DState>();
}

class _DojoProviderState<DRoom extends DojoRoom<DState>, DState>
    extends State<DojoProvider<DRoom, DState>> {
  late DState _lastState;
  late DRoom _dojo;

  @override
  void initState() {
    _dojo = widget.dojo;
    _lastState = _dojo.state;
    _dojo.addListener(_onStateUpdate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DojoGym<DRoom, DState>(
      dojoRoom: _dojo,
      child: DojoSelector<DState>(
        state: _dojo.state,
        child: widget.child,
      ),
    );
  }

  void _onStateUpdate() {
    if (_lastState != _dojo.state) {
      _lastState = _dojo.state;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _dojo.removeListener(_onStateUpdate);
    super.dispose();
  }
}

// class MultiDojoProvider<DState> extends StatefulWidget {
//   const MultiDojoProvider({
//     super.key,
//     required this.initState,
//     required this.dojo,
//     required this.child,
//   });

//   final ProviderState initState;
//   final Dojo<State> dojo;
//   final Widget child;

//   @override
//   State<MultiDojoProvider<DState>> createState() =>
//       _MultiDojoProviderState<DState>();
// }

// class _MultiDojoProviderState<DState> extends State<MultiDojoProvider<DState>> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

/// emitir nuevos estados
abstract class DojoRoom<DState> extends ChangeNotifier {
  DState _state;
  // DState _lastState;

  DojoRoom(DState initialState) : _state = initialState;

  void dispatch(DState newState) async {
    _dispatchAction(GenericStateChangeAction(newState));
  }

  void _dispatchAction(GenericStateChangeAction event) {
    state = event.newState;
  }

  @protected
  set state(DState state) {
    if (_state != state) {
      _state = state;
      notifyListeners();
    }
  }

  Future<void> onDojoAction(Action action) async {}

  DState get state => _state;
}

/// read, watch, dispatch, etc, etc
typedef Selector<DState, S> = S Function(DState state);

class Dojo {
  static S select<DState, S>(
    BuildContext context,
    Selector<DState, S> selector,
  ) {
    final Selector untypedSelector = (state) => selector(state);
    final provider = InheritedModel.inheritFrom<DojoSelector<DState>>(
      context,
      aspect: untypedSelector,
    );
    return selector(provider!.state);
  }

  static R read<R extends DojoRoom<DState>, DState>(BuildContext context) {
    return DojoGym.of<R, DState>(context) as R;
  }

  static R watch<R extends DojoRoom<DState>, DState>(BuildContext context) {
    return DojoGym.of<R, DState>(context) as R;
  }

  static Future<void> dispatch<R extends DojoRoom<DState>, DState>(
      BuildContext context, Action action) {
    print('msg');
    return DojoGym.of<R, DState>(context).onDojoAction(action);
  }

  // static listen<DRoom extends DojoRoom>() {}
}
