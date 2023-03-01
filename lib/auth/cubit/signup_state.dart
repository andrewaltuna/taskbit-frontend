part of 'signup_cubit.dart';

class SignupState extends Equatable {
  const SignupState({
    this.authToken,
    this.firstName = '',
    this.lastName = '',
    this.username = '',
    this.password = '',
    this.firstNameInputStatus = InputStatus.initial,
    this.lastNameInputStatus = InputStatus.initial,
    this.usernameInputStatus = InputStatus.initial,
    this.passwordInputStatus = InputStatus.initial,
  });

  final String? authToken;
  final String firstName;
  final String lastName;
  final String username;
  final String password;
  final InputStatus firstNameInputStatus;
  final InputStatus lastNameInputStatus;
  final InputStatus usernameInputStatus;
  final InputStatus passwordInputStatus;

  SignupState copyWith({
    String? authToken,
    ValueGetter<int?>? selectedAvatarIndex,
    String? firstName,
    String? lastName,
    String? username,
    String? password,
    InputStatus? firstNameInputStatus,
    InputStatus? lastNameInputStatus,
    InputStatus? usernameInputStatus,
    InputStatus? passwordInputStatus,
  }) {
    return SignupState(
      authToken: authToken ?? this.authToken,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      password: password ?? this.password,
      firstNameInputStatus: firstNameInputStatus ?? this.firstNameInputStatus,
      lastNameInputStatus: lastNameInputStatus ?? this.lastNameInputStatus,
      usernameInputStatus: usernameInputStatus ?? this.usernameInputStatus,
      passwordInputStatus: passwordInputStatus ?? this.passwordInputStatus,
    );
  }

  @override
  List<Object?> get props => [
        authToken,
        firstName,
        lastName,
        username,
        password,
        firstNameInputStatus,
        lastNameInputStatus,
        usernameInputStatus,
        passwordInputStatus,
      ];

  bool get formIsValid {
    return firstNameInputStatus == InputStatus.valid &&
        lastNameInputStatus == InputStatus.valid &&
        usernameInputStatus == InputStatus.valid &&
        passwordInputStatus == InputStatus.valid;
  }

  bool get isFirstNameInvalid => firstNameInputStatus == InputStatus.invalid;
  bool get isLastNameInvalid => lastNameInputStatus == InputStatus.invalid;
  bool get isUsernameInvalid => usernameInputStatus == InputStatus.invalid;
  bool get isPasswordInvalid => passwordInputStatus == InputStatus.invalid;
}
