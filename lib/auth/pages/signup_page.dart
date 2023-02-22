import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/auth/cubit/signup_cubit.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
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
    TasksCubit tasksCubit = context.read<TasksCubit>();
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            tasksCubit.pageChanged(Pages.login);
            signupCubit.resetState();
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Logo(),
                  // const Text(
                  //   'Sign Up',
                  //   style: TextStyle(
                  //     fontSize: 25,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                  const SizedBox(height: 20.0),
                  const _AvatarSelect(),
                  // const SizedBox(height: 30.0),
                  Row(
                    children: [
                      Expanded(child: _firstNameField(signupCubit)),
                      const SizedBox(width: 15.0),
                      Expanded(child: _lastNameField(signupCubit)),
                    ],
                  ),
                  _usernameField(signupCubit),
                  _passwordField(signupCubit),
                  const SizedBox(height: 30.0),
                  _submitButton(signupCubit, tasksCubit),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _firstNameField(SignupCubit signupCubit) {
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

  Widget _lastNameField(SignupCubit signupCubit) {
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

  Widget _usernameField(SignupCubit signupCubit) {
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

  Widget _passwordField(SignupCubit signupCubit) {
    return TextField(
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

  Widget _submitButton(SignupCubit signupCubit, TasksCubit tasksCubit) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !signupCubit.formIsValid()
            ? null
            : () {
                signupCubit.createUser();
                tasksCubit.pageChanged(Pages.home);
              },
        child: const Text('Sign Up'),
      ),
    );
  }
}

class _AvatarSelect extends StatelessWidget {
  const _AvatarSelect();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/stats_background.png'),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose your Avatar',
                style: GoogleFonts.pressStart2p(color: Colors.white),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 70,
                child: ListView.separated(
                  itemBuilder: ((context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Material(
                        color: index ==
                                context
                                    .read<SignupCubit>()
                                    .state
                                    .selectedAvatarIndex
                            ? Colors.black.withOpacity(0.5)
                            : Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.read<SignupCubit>().avatarSelected(index);
                          },
                          child: Sprite(
                            context.read<SignupCubit>().state.avatars[index],
                            height: 70,
                          ),
                        ),
                      ),
                    );
                  }),
                  separatorBuilder: ((context, index) =>
                      const SizedBox(width: 10.0)),
                  itemCount: 3,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
