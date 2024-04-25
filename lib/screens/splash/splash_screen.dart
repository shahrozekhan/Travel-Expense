import 'package:auth_repo/authrepo/auth_repository.dart';
import 'package:fcc/screens/bloc/authentication/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

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
  var animationComplete = false;

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
        context.read<AuthenticationBloc>().checkAuthentication();
      }
    });
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (ctx, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          context.go("/DashBoardScreen");
        } else if (state.status == AuthenticationStatus.unauthenticated) {
          context.go("/AuthScreen");
        }
      },
      child: Scaffold(
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
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
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
      ),
    );
  }
}
