import 'package:flutter/material.dart';

/// is not working

class PageTransition1 extends StatelessWidget {
  const PageTransition1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Navigator.of(context).push(CustomPageRoute(page: Intro2Page()));

            Navigator.of(context).push(
              CustomPageRoute(
                page: _PageTransition1(),
              ),
            );
          },
          child: Text('Intro Screen'),
        ),
      ),
    );
  }
}

class _PageTransition1 extends StatelessWidget {
  const _PageTransition1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Text('New Page'),
        ),
      ),
    );
  }
}

class FlowPager extends StatefulWidget {
  @override
  _FlowPagerState createState() => _FlowPagerState();
}

class _FlowPagerState extends State<FlowPager> with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );

  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) => CustomPaint(
              size: size,
              painter: FlowPainter(
                animationValue: controller.value,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                if (controller.isAnimating) return;
                if (controller.isCompleted) {
                  controller.reverse();
                } else {
                  controller.forward();
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 200),
                child: ClipOval(
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget page;

  CustomPageRoute({required this.page})
      : super(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 1500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return CustomPaint(
                  painter: FlowPainter(animationValue: animation.value),
                  // child: child,
                );
              },
              child: child,
            );
          },
        );
}

class FlowPainter extends CustomPainter {
  final double animationValue;
  final Color originColor;
  final Color finalColor;

  FlowPainter({
    required this.animationValue,
    this.originColor = Colors.red,
    this.finalColor = const Color(0xffff9100),
  });

  final Paint buttonPaint = Paint();
  final Paint bgPaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width / 2, size.height * 0.8);
    const width = 0;
    const height = 0;
    final xScale = size.height * 8;
    final yScale = xScale / 2;

    final curvedVal = Curves.easeInOutCirc.transformInternal(animationValue);
    final double reverseVal = 1 - curvedVal;

    late Rect buttonRect;
    final Rect bgRect = Rect.fromLTWH(0, 0, size.width, size.height);

    if (animationValue <= 0.5) {
      bgPaint.color = originColor;
      buttonPaint.color = finalColor;

      buttonRect = Rect.fromLTRB(
        origin.dx - (xScale * curvedVal),
        origin.dy - (yScale * curvedVal),
        origin.dx + width * reverseVal,
        origin.dy + height + (yScale * curvedVal),
      );
    } else {
      bgPaint.color = originColor;
      buttonPaint.color = finalColor;
      buttonRect = Rect.fromLTRB(
        origin.dx + width * reverseVal,
        origin.dy - yScale * reverseVal,
        origin.dx + width + xScale * reverseVal,
        origin.dy + height + yScale * reverseVal,
      );
    }

    if (animationValue != 1) {
      // buttonPaint.color = Colors.transparent;
      canvas.drawRect(bgRect, bgPaint);
      canvas.drawRRect(
        RRect.fromRectAndRadius(buttonRect, Radius.circular(size.height)),
        buttonPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
