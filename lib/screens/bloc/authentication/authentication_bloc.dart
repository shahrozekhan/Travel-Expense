import 'dart:async';
import 'dart:io';

import 'package:auth_repo/authrepo/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {

  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {

    on<_AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    on<LoginUser>((event, emit) {
      _submitLogin(event.username, event.password);
    });
    on<SignUpUser>((event, emit) {
      _submitForSignUp(event.username, event.password, event.pickedImage);
    });
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(_AuthenticationStatusChanged(status)),
    );

  }

  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  void checkAuthentication() {
    _authenticationRepository.isUserLoggedIn();
  }

  void _submitLogin(String username, String password) {
    _authenticationRepository.logIn(username: username, password: password);
  }

  void _submitForSignUp(String username, String password, File? file) {
    _authenticationRepository.signUp(
        email: username, password: password, pickedImage: file);
  }

  Future<void> _onAuthenticationStatusChanged(
    _AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.sign_up_completed:
        return emit(const AuthenticationState.signUpCompleted());
      case AuthenticationStatus.sign_up_failed:
        return emit(const AuthenticationState.signUpFailed());
      case AuthenticationStatus.authenticated:
        final user = FirebaseAuth.instance.currentUser;
        return emit(
          user != null
              ? AuthenticationState.authenticated(user)
              : const AuthenticationState.unauthenticated(),
        );
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
    }
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut();
  }
}
