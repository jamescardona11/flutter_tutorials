import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageTransition2 extends StatefulWidget {
  const PageTransition2({
    Key? key,
  }) : super(key: key);

  @override
  State<PageTransition2> createState() => _PageTransition2State();
}

class _PageTransition2State extends State<PageTransition2> with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> startAnimation;
  late final Animation<double> endAnimation;
  late final Animation<double> horizontalAnimation;
  late final PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    animationController = AnimationController(duration: const Duration(milliseconds: 750), vsync: this);

    startAnimation = CurvedAnimation(
      parent: animationController,
      curve: Interval(0.000, 0.500, curve: Curves.easeInExpo),
    );

    endAnimation = CurvedAnimation(
      parent: animationController,
      curve: Interval(0.500, 1.000, curve: Curves.easeOutExpo),
    );

    horizontalAnimation = CurvedAnimation(
      parent: animationController,
      curve: Interval(0.750, 1.000, curve: Curves.easeInOutQuad),
    );

    animationController
      ..addStatusListener((status) {
        final model = Provider.of<HomeModel>(context, listen: false);
        if (status == AnimationStatus.completed) {
          model.swapColors();
          animationController.reset();
        }
      })
      ..addListener(() {
        final model = Provider.of<HomeModel>(context, listen: false);
        if (animationController.value > 0.5) {
          model.isHalfWay = true;
        } else {
          model.isHalfWay = false;
        }
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: model.isHalfWay ? model.foreGroundColor : model.backGroundColor,
      body: Stack(
        children: <Widget>[
          Container(
            color: model.isHalfWay ? model.foreGroundColor : model.backGroundColor,
            width: screenWidth / 2.0 - Global.radius / 2.0,
            height: double.infinity,
          ),
          Transform(
            transform: Matrix4.identity()
              ..translate(
                screenWidth / 2 - Global.radius / 2.0,
                screenHeight - Global.radius - Global.bottomPadding,
              ),
            child: GestureDetector(
              onTap: () {
                if (animationController.status != AnimationStatus.forward) {
                  model.isToggled = !model.isToggled;
                  model.index++;
                  if (model.index > 3) {
                    model.index = 0;
                  }
                  pageController.animateToPage(model.index, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuad);
                  animationController.forward();
                }
              },
              child: Stack(
                children: <Widget>[
                  AnimatedCircle(
                    animation: startAnimation,
                    color: model.foreGroundColor,
                    flip: 1.0,
                    tween: Tween<double>(begin: 1.0, end: Global.radius),
                  ),
                  AnimatedCircle(
                    animation: endAnimation,
                    color: model.backGroundColor,
                    flip: -1.0,
                    horizontalTween: Tween<double>(begin: 0, end: -Global.radius),
                    horizontalAnimation: horizontalAnimation,
                    tween: Tween<double>(begin: Global.radius, end: 1.0),
                  ),
                ],
              ),
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: PageView.builder(
              controller: pageController,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    'Page ${index + 1}',
                    style: TextStyle(
                      color: index % 2 == 0 ? Global.mediumBlue : Global.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }
}

class AnimatedCircle extends AnimatedWidget {
  final Tween<double> tween;
  final Tween<double>? horizontalTween;
  final Animation<double> animation;
  final Animation<double>? horizontalAnimation;
  final double flip;
  final Color color;

  AnimatedCircle({
    Key? key,
    required this.animation,
    this.horizontalTween,
    this.horizontalAnimation,
    required this.color,
    required this.flip,
    required this.tween,
  })  : assert(flip == 1 || flip == -1),
        super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeModel>(context);
    return Transform(
      alignment: FractionalOffset.centerLeft,
      transform: Matrix4.identity()
        ..scale(
          tween.evaluate(animation) * flip,
          tween.evaluate(animation),
        ),
      child: Transform(
        transform: Matrix4.identity()
          ..translate(
            horizontalTween != null ? horizontalTween?.evaluate(horizontalAnimation!) : 0.0,
          ),
        child: Container(
          width: Global.radius,
          height: Global.radius,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              Global.radius / 2.0 - tween.evaluate(animation) / (Global.radius / 2.0),
            ),
          ),
          child: Icon(
            flip == 1 ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left,
            color: model.index % 2 == 0 ? Global.white : Global.mediumBlue,
          ),
        ),
      ),
    );
  }
}

class HomeModel extends ChangeNotifier {
  int _index = 0;
  get index => _index;
  set index(value) {
    _index = value;
    notifyListeners();
  }

  bool _isHalfWay = false;
  get isHalfWay => _isHalfWay;
  set isHalfWay(value) {
    _isHalfWay = value;
    notifyListeners();
  }

  bool _isToggled = false;
  get isToggled => _isToggled;
  set isToggled(value) {
    _isToggled = value;
    notifyListeners();
  }

  void swapColors() {
    if (_isToggled) {
      _backGroundColor = Global.palette[1];
      _foreGroundColor = Global.palette[0];
    } else {
      _backGroundColor = Global.palette[0];
      _foreGroundColor = Global.palette[1];
    }
    notifyListeners();
  }

  Color _backGroundColor = Global.palette[0];
  get backGroundColor => _backGroundColor;
  set backGroundColor(value) {
    _backGroundColor = value;
    notifyListeners();
  }

  Color _foreGroundColor = Global.palette[1];
  get foreGroundColor => _foreGroundColor;
  set foreGroundColor(value) {
    _foreGroundColor = value;
    notifyListeners();
  }
}

class Global {
  static const Color white = const Color(0xffffffff);
  static const Color mediumBlue = const Color(0xff4A64FE);
  static const List<Color> palette = [white, mediumBlue];
  static const double scale = 1;
  static const double radius = 88.0;
  static const double bottomPadding = 75.0;
}
