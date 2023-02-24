import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/navigation/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/widgets/logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page page() {
    return const MaterialPage<void>(child: LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: _LoginForm(
        loginCubit: context.read<LoginCubit>(),
        navigationCubit: context.read<NavigationCubit>(),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.loginCubit,
    required this.navigationCubit,
  });

  final LoginCubit loginCubit;
  final NavigationCubit navigationCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Logo(),
            const SizedBox(height: 30.0),
            _usernameField(),
            _passwordField(),
            const SizedBox(height: 30.0),
            _submitButton(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No account yet?'),
                TextButton(
                  onPressed: () => navigationCubit.pageChanged(Pages.signUp),
                  child: const Text('Sign Up'),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _usernameField() {
    return TextField(
      onChanged: loginCubit.usernameChanged,
      decoration: InputDecoration(
        label: const Text('Username'),
        errorText: loginCubit.state.usernameInputStatus == InputStatus.invalid
            ? 'Invalid username'
            : null,
      ),
    );
  }

  Widget _passwordField() {
    return TextField(
      onChanged: loginCubit.passwordChanged,
      obscureText: true,
      decoration: InputDecoration(
        label: const Text('Password'),
        errorText: loginCubit.state.passwordInputStatus == InputStatus.invalid
            ? 'Invalid password'
            : null,
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !loginCubit.formIsValid()
            ? null
            : () async {
                if (await loginCubit.fetchUser() == true) {
                  navigationCubit.pageChanged(Pages.home);
                }
              },
        child: const Text('Login'),
      ),
    );
  }
}
