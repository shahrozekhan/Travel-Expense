import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/FirebaseAuthenticationManager.dart';
import '../common/screens_enum.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> with TickerProviderStateMixin {
  var _animate = false;
  var _textAnimate = false;
  final String assetName = 'icons/splash_logo.svg';
  late AnimationController _controller;
  late Animation<double> _animationScale;
  late Animation<double> _animationRotation;

  late AnimationController _textController;
  late Animation<double> _textAnimationScale;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _textAnimationScale = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _animationScale = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(curvedAnimation);

    _animationRotation = Tween<double>(
      begin: 0,
      end: 2 * 3.1416, // full rotation in radians (360 degrees)
    ).animate(curvedAnimation);

    _controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _controller.forward(from: 0.0);
      _textController.forward(from: 0.0);
    });
    _controller.addStatusListener((animationStatus) {
      if (animationStatus == AnimationStatus.completed) {
        Navigator.pop(context);
        //TODO check if the user is authenticated.
        if (isUserLoggedIn()) {
          screenSwitcher(ScreenName.Dashboard, context);
        } else {
          screenSwitcher(ScreenName.Authentication, context);
        }
      }
    });
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: _animationScale.value,
                  child: Transform.rotate(
                    angle: _animationRotation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      child: SvgPicture.asset(
                        assetName,
                        height: 200,
                        width: 200,
                        key: ValueKey(_animate),
                      ),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _textController,
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: _textAnimationScale.value,
                  child: Text(
                    "Travel Expense",
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.bold),
                    key: ValueKey(_textAnimate),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
