import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/auth/cubit/signup_cubit.dart';
import 'package:taskbit/navigation/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/widgets/avatar_select.dart';
import 'package:taskbit/widgets/logo.dart';
import 'package:taskbit/widgets/sprite.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  static Page page() {
    return const MaterialPage<void>(child: SignupPage());
  }

  @override
  Widget build(BuildContext context) {
    SignupCubit signupCubit = context.read<SignupCubit>();
    NavigationCubit navigationCubit = context.read<NavigationCubit>();
    return WillPopScope(
      onWillPop: () async {
        navigationCubit.pageChanged(Pages.login);
        signupCubit.resetState();
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _SignupForm(
            signupCubit: signupCubit, navigationCubit: navigationCubit),
      ),
    );
  }
}

class _SignupForm extends StatelessWidget {
  const _SignupForm({
    required this.signupCubit,
    required this.navigationCubit,
  });

  final SignupCubit signupCubit;
  final NavigationCubit navigationCubit;

  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();

    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Logo(),
              const SizedBox(height: 20.0),
              const AvatarSelect(),
              Row(
                children: [
                  Expanded(child: _firstNameField()),
                  const SizedBox(width: 15.0),
                  Expanded(child: _lastNameField()),
                ],
              ),
              _usernameField(),
              _passwordField(passwordController),
              const SizedBox(height: 30.0),
              _submitButton(context, passwordController),
            ],
          ),
        );
      },
    );
  }

  Widget _firstNameField() {
    return TextField(
      onChanged: signupCubit.firstNameChanged,
      decoration: InputDecoration(
        label: const Text('First name'),
        errorText: signupCubit.state.firstNameInputStatus == InputStatus.invalid
            ? 'Invalid first name'
            : null,
      ),
    );
  }

  Widget _lastNameField() {
    return TextField(
      onChanged: signupCubit.lastNameChanged,
      decoration: InputDecoration(
        label: const Text('Last name'),
        errorText: signupCubit.state.lastNameInputStatus == InputStatus.invalid
            ? 'Invalid last name'
            : null,
      ),
    );
  }

  Widget _usernameField() {
    return TextField(
      onChanged: signupCubit.usernameChanged,
      decoration: InputDecoration(
        label: const Text('Username'),
        errorText: signupCubit.state.usernameInputStatus == InputStatus.invalid
            ? 'Invalid username'
            : null,
      ),
    );
  }

  Widget _passwordField(TextEditingController passwordController) {
    return TextField(
      controller: passwordController,
      onChanged: signupCubit.passwordChanged,
      obscureText: true,
      decoration: InputDecoration(
        label: const Text('Password'),
        errorText: signupCubit.state.passwordInputStatus == InputStatus.invalid
            ? 'Invalid password'
            : null,
      ),
    );
  }

  Widget _submitButton(
      BuildContext context, TextEditingController passwordController) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !signupCubit.formIsValid()
            ? null
            : () async {
                if (await signupCubit.registerUser() == true) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(successSnackBar());
                  }
                  return navigationCubit.pageChanged(Pages.login);
                }
                passwordController.clear();
              },
        child: const Text('Sign Up'),
      ),
    );
  }

  SnackBar successSnackBar() {
    return const SnackBar(content: Text('Successfuly registered!'));
  }
}
