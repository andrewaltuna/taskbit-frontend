part of 'signup_cubit.dart';

class SignupState extends Equatable {
  const SignupState({
    this.authToken,
    this.firstName = '',
    this.lastName = '',
    this.username = '',
    this.password = '',
    this.passwordConfirmation = '',
    this.firstNameInputStatus = InputStatus.initial,
    this.lastNameInputStatus = InputStatus.initial,
    this.usernameInputStatus = InputStatus.initial,
    this.passwordInputStatus = InputStatus.initial,
    this.passwordConfirmationInputStatus = InputStatus.initial,
  });

  final String? authToken;
  final String firstName;
  final String lastName;
  final String username;
  final String password;
  final String passwordConfirmation;
  final InputStatus firstNameInputStatus;
  final InputStatus lastNameInputStatus;
  final InputStatus usernameInputStatus;
  final InputStatus passwordInputStatus;
  final InputStatus passwordConfirmationInputStatus;

  SignupState copyWith({
    String? authToken,
    ValueGetter<int?>? selectedAvatarIndex,
    String? firstName,
    String? lastName,
    String? username,
    String? password,
    String? passwordConfirmation,
    InputStatus? firstNameInputStatus,
    InputStatus? lastNameInputStatus,
    InputStatus? usernameInputStatus,
    InputStatus? passwordInputStatus,
    InputStatus? passwordConfirmationInputStatus,
  }) {
    return SignupState(
      authToken: authToken ?? this.authToken,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      firstNameInputStatus: firstNameInputStatus ?? this.firstNameInputStatus,
      lastNameInputStatus: lastNameInputStatus ?? this.lastNameInputStatus,
      usernameInputStatus: usernameInputStatus ?? this.usernameInputStatus,
      passwordInputStatus: passwordInputStatus ?? this.passwordInputStatus,
      passwordConfirmationInputStatus: passwordConfirmationInputStatus ??
          this.passwordConfirmationInputStatus,
    );
  }

  @override
  List<Object?> get props => [
        authToken,
        firstName,
        lastName,
        username,
        password,
        passwordConfirmation,
        firstNameInputStatus,
        lastNameInputStatus,
        usernameInputStatus,
        passwordInputStatus,
        passwordConfirmationInputStatus
      ];

  bool get isFormValid {
    return firstNameInputStatus == InputStatus.valid &&
        lastNameInputStatus == InputStatus.valid &&
        usernameInputStatus == InputStatus.valid &&
        passwordInputStatus == InputStatus.valid &&
        passwordConfirmationInputStatus == InputStatus.valid;
  }

  bool get isFirstNameInvalid => firstNameInputStatus == InputStatus.invalid;
  bool get isLastNameInvalid => lastNameInputStatus == InputStatus.invalid;
  bool get isUsernameInvalid => usernameInputStatus == InputStatus.invalid;
  bool get isPasswordInvalid => passwordInputStatus == InputStatus.invalid;
  bool get isPasswordConfirmationInvalid =>
      passwordConfirmationInputStatus == InputStatus.invalid;
}
