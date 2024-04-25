part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._(
      {this.status = AuthenticationStatus.unknown, this.user});

  const AuthenticationState.authenticated(User? user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.signUpCompleted()
      : this._(status: AuthenticationStatus.sign_up_completed);

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.unauthenticated()
      : this._(
          status: AuthenticationStatus.unauthenticated,
        );

  const AuthenticationState.signUpFailed()
      : this._(
          status: AuthenticationStatus.sign_up_failed,
        );

  final AuthenticationStatus status;
  final User? user;

  @override
  List<Object> get props => [status];
}
