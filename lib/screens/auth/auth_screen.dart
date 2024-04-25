import 'dart:io';

import 'package:auth_repo/authrepo/auth_repository.dart';
import 'package:fcc/screens/bloc/authentication/authentication_bloc.dart';
import 'package:fcc/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreen();
  }
}

class _AuthScreen extends State<AuthScreen> {
  var _isLogin = true;
  final _formValidator = GlobalKey<FormState>();
  var _enteredEmail = "shahroze@gmail.com";
  var _enteredPassword = "test123";
  File? _pickedImage;
  var isAuthenticating = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submitt() async {
    setState(() {
      isAuthenticating = true;
    });
    final isValid = _formValidator.currentState!.validate();
    if (!isValid || (_isLogin && _pickedImage != null)) {
      setState(() {
        isAuthenticating = false;
      });
      return;
    }
    _formValidator.currentState!.save();

    // try {
    if (_isLogin) {
      context
          .read<AuthenticationBloc>()
          .add(LoginUser(_enteredEmail, _enteredPassword));
    } else {
      context
          .read<AuthenticationBloc>()
          .add(SignUpUser(_enteredEmail, _enteredPassword, _pickedImage));
    }
  }

  Widget? content;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthenticationStatus.sign_up_completed:
            setState(() {
              isAuthenticating = false;
            });
            context.go("/DashBoardScreen");
            break;
          case AuthenticationStatus.sign_up_failed:
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Sign Up Failed!")));
            break;
          case AuthenticationStatus.authenticated:
            setState(() {
              isAuthenticating = false;
            });
            context.go("/DashBoardScreen");
            break;
          case AuthenticationStatus.unauthenticated:
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Authorization Failed!")));
          case AuthenticationStatus.unknown:
            break;
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 30, bottom: 20, right: 30, left: 20),
                child: SvgPicture.asset(
                  "icons/splash_logo.svg",
                  width: 200,
                  height: 200,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Card(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formValidator,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(onPickImage: (pickedImage) {
                              _pickedImage = pickedImage;
                            }),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Email Address",
                            ),
                            initialValue: _enteredEmail,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains("@")) {
                                return "Email is not valid!";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                              initialValue: _enteredPassword,
                              decoration: const InputDecoration(
                                labelText: "Password",
                              ),
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return "Password must be at least 6 characters.";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredPassword = value!;
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                          if (isAuthenticating)
                            Center(
                                child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ))
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: !_isLogin
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                          : Theme.of(context)
                                              .colorScheme
                                              .primaryContainer),
                                  onPressed: () {
                                    if (_isLogin) {
                                      _submitt();
                                      return;
                                    }
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: !_isLogin ? 0 : 45),
                                    child: Text(_isLogin
                                        ? "Sign In!"
                                        : "I already have an account."),
                                  ),
                                ),
                                const Text("or"),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: _isLogin
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                            : Theme.of(context)
                                                .colorScheme
                                                .primaryContainer),
                                    onPressed: () {
                                      if (!_isLogin) {
                                        _submitt();
                                        return;
                                      }
                                      setState(() {
                                        _isLogin = !_isLogin;
                                      });
                                    },
                                    child: Text("Sign Up!")),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
