import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/auth/cubit/signup_cubit.dart';
import 'package:taskbit/cubit/avatar_select_cubit.dart';
import 'package:taskbit/cubit/navigation_cubit.dart';
import 'package:taskbit/widgets/avatar_select.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();

    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AvatarSelect(),
            Row(
              children: const [
                Expanded(child: _FirstNameField()),
                SizedBox(width: 15.0),
                Expanded(child: _LastNameField()),
              ],
            ),
            const _UsernameField(),
            _PasswordField(controller: passwordController),
            const SizedBox(height: 30.0),
            _SignupButton(passwordController: passwordController),
          ],
        );
      },
    );
  }
}

class _FirstNameField extends StatelessWidget {
  const _FirstNameField();

  @override
  Widget build(BuildContext context) {
    final signupCubit = BlocProvider.of<SignupCubit>(context);

    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return TextField(
          onChanged: signupCubit.firstNameChanged,
          decoration: InputDecoration(
            label: const Text('First name'),
            errorText:
                signupCubit.state.firstNameInputStatus == InputStatus.invalid
                    ? 'Invalid first name'
                    : null,
          ),
        );
      },
    );
  }
}

class _LastNameField extends StatelessWidget {
  const _LastNameField();

  @override
  Widget build(BuildContext context) {
    final signupCubit = BlocProvider.of<SignupCubit>(context);

    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return TextField(
          onChanged: signupCubit.lastNameChanged,
          decoration: InputDecoration(
            label: const Text('Last name'),
            errorText:
                signupCubit.state.lastNameInputStatus == InputStatus.invalid
                    ? 'Invalid last name'
                    : null,
          ),
        );
      },
    );
  }
}

class _UsernameField extends StatelessWidget {
  const _UsernameField();

  @override
  Widget build(BuildContext context) {
    final signupCubit = BlocProvider.of<SignupCubit>(context);

    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return TextField(
          onChanged: signupCubit.usernameChanged,
          decoration: InputDecoration(
            label: const Text('Username'),
            errorText:
                signupCubit.state.usernameInputStatus == InputStatus.invalid
                    ? 'Invalid username'
                    : null,
          ),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final signupCubit = BlocProvider.of<SignupCubit>(context);

    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return TextField(
          controller: controller,
          onChanged: signupCubit.passwordChanged,
          obscureText: true,
          decoration: InputDecoration(
            label: const Text('Password'),
            errorText:
                signupCubit.state.passwordInputStatus == InputStatus.invalid
                    ? 'Invalid password'
                    : null,
          ),
        );
      },
    );
  }
}

class _SignupButton extends StatelessWidget {
  const _SignupButton({required this.passwordController});

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final signupCubit = BlocProvider.of<SignupCubit>(context);
    final navigationCubit = BlocProvider.of<NavigationCubit>(context);

    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, signupState) {
        return BlocBuilder<AvatarSelectCubit, AvatarSelectState>(
          builder: (context, avatarSelectState) {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: signupState.formIsValid &&
                        avatarSelectState.selectedAvatar != null
                    ? () async {
                        if (await signupCubit.registerUser() == true) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Successfuly registered!')));
                          }
                          return navigationCubit.pageChanged(Pages.login);
                        }
                        passwordController.clear();
                      }
                    : null,
                child: const Text('Sign Up'),
              ),
            );
          },
        );
      },
    );
  }
}
