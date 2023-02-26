part of 'login_cubit.dart';

enum InputStatus { initial, valid, invalid }

class LoginState extends Equatable {
  const LoginState({
    this.user,
    this.username = '',
    this.password = '',
    this.usernameInputStatus = InputStatus.initial,
    this.passwordInputStatus = InputStatus.initial,
  });

  final User? user;
  final String username;
  final String password;
  final InputStatus usernameInputStatus;
  final InputStatus passwordInputStatus;

  LoginState copyWith({
    ValueGetter<User?>? user,
    String? username,
    String? password,
    InputStatus? usernameInputStatus,
    InputStatus? passwordInputStatus,
  }) {
    return LoginState(
      user: user != null ? user() : this.user,
      username: username ?? this.username,
      password: password ?? this.password,
      usernameInputStatus: usernameInputStatus ?? this.usernameInputStatus,
      passwordInputStatus: passwordInputStatus ?? this.passwordInputStatus,
    );
  }

  @override
  List<Object?> get props =>
      [user, username, password, usernameInputStatus, passwordInputStatus];

  bool formIsValid() {
    return usernameInputStatus == InputStatus.valid &&
        passwordInputStatus == InputStatus.valid;
  }
}
