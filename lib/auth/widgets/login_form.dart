import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/auth/cubit/signup_cubit.dart';
import 'package:taskbit/cubit/navigation_cubit.dart';
import 'package:taskbit/widgets/logo.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});
  @override
  Widget build(BuildContext context) {
    final navigationCubit = BlocProvider.of<NavigationCubit>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Logo(),
        const SizedBox(height: 30.0),
        const _UsernameField(),
        const _PasswordField(),
        const SizedBox(height: 30.0),
        const _LoginButton(),
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
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    final loginCubit = BlocProvider.of<LoginCubit>(context);
    final signupCubit = BlocProvider.of<SignupCubit>(context);
    final navigationCubit = BlocProvider.of<NavigationCubit>(context);

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isFormValid
                ? () async {
                    if (await loginCubit.fetchUser()) {
                      signupCubit
                          .userLoggedIn(loginCubit.state.user!.accessToken);
                      navigationCubit.pageDeselected();
                    }
                  }
                : null,
            child: const Text('Login'),
          ),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    final loginCubit = BlocProvider.of<LoginCubit>(context);

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return TextField(
          onChanged: loginCubit.passwordChanged,
          obscureText: true,
          decoration: InputDecoration(
            label: const Text('Password'),
            errorText: state.passwordInputStatus == InputStatus.invalid
                ? 'Invalid password'
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
    final loginCubit = BlocProvider.of<LoginCubit>(context);
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return TextField(
          onChanged: loginCubit.usernameChanged,
          decoration: InputDecoration(
            label: const Text('Username'),
            errorText: state.usernameInputStatus == InputStatus.invalid
                ? 'Invalid username'
                : null,
          ),
        );
      },
    );
  }
}
