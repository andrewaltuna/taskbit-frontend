part of 'signup_cubit.dart';

class SignupState extends Equatable {
  SignupState({
    this.selectedAvatarIndex,
    this.firstName = '',
    this.lastName = '',
    this.username = '',
    this.password = '',
    this.firstNameInputStatus = InputStatus.initial,
    this.lastNameInputStatus = InputStatus.initial,
    this.usernameInputStatus = InputStatus.initial,
    this.passwordInputStatus = InputStatus.initial,
  });

  final int? selectedAvatarIndex;
  final String firstName;
  final String lastName;
  final String username;
  final String password;
  final InputStatus firstNameInputStatus;
  final InputStatus lastNameInputStatus;
  final InputStatus usernameInputStatus;
  final InputStatus passwordInputStatus;

  final List<String> avatars = [
    'avatars/knight',
    'avatars/wizard',
    'avatars/barbarian',
  ];

  SignupState copyWith({
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
      selectedAvatarIndex: selectedAvatarIndex != null
          ? selectedAvatarIndex()
          : this.selectedAvatarIndex,
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
        selectedAvatarIndex,
        firstName,
        lastName,
        username,
        password,
        firstNameInputStatus,
        lastNameInputStatus,
        usernameInputStatus,
        passwordInputStatus,
      ];
}