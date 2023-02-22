import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/widgets/logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page page() {
    return const MaterialPage<void>(child: LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = context.read<LoginCubit>();
    TasksCubit tasksCubit = context.read<TasksCubit>();
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Logo(),
              const SizedBox(height: 30.0),
              _usernameField(loginCubit),
              _passwordField(loginCubit),
              const SizedBox(height: 30.0),
              _submitButton(loginCubit, tasksCubit),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No account yet?'),
                  TextButton(
                    onPressed: () => tasksCubit.pageChanged(-2),
                    child: const Text('Sign Up'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _usernameField(LoginCubit loginCubit) {
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

  Widget _passwordField(LoginCubit loginCubit) {
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

  Widget _submitButton(LoginCubit loginCubit, TasksCubit tasksCubit) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !loginCubit.formIsValid()
            ? null
            : () {
                tasksCubit.pageChanged(0);
              },
        child: const Text('Login'),
      ),
    );
  }
}
