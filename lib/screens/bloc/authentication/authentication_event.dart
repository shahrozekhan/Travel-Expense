part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class _AuthenticationStatusChanged extends AuthenticationEvent {
  const _AuthenticationStatusChanged(this.status);

  final AuthenticationStatus status;
}

final class AuthenticationLogoutRequested extends AuthenticationEvent {}

final class LoginUser extends AuthenticationEvent {
  const LoginUser(this.username, this.password);

  final String username;
  final String password;
}

final class SignUpUser extends AuthenticationEvent {
  const SignUpUser(this.username, this.password, this.pickedImage);
  final String username;
  final String password;
  final File? pickedImage;
}