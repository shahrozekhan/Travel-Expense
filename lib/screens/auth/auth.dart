import 'dart:io';

import 'package:fcc/common/screens_enum.dart';
import 'package:fcc/widgets/user_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../main.dart';

final _firebase = FirebaseAuth.instance;

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
  var _enteredEmail = "";
  var _enteredPassword = "";
  File? _pickedImage;
  var isAuthenticating = false;

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

    try {
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        // if(FirebaseAuth.instance.authStateChanges()
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.of(context).pop();
          screenSwitcher(ScreenName.Dashboard, context);
        }
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');
        storageRef.putFile(_pickedImage!);
        storageRef.getDownloadURL();
        _isLogin = !_isLogin;
      }
    } on FirebaseAuthException catch (exception) {
      String? message;
      if (exception == "email-already-in-use") {
        message = "Email is already in use.";
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? "Authorization Failed!")));
    }
    setState(() {
      isAuthenticating = false;
    });
  }

  Widget? content;

  @override
  Widget build(BuildContext context) {
    // if (isAuthenticating) {
    // } else {
    content = Center(
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
    );
    // }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      // appBar: ,
      body: content,
    );
  }
}
