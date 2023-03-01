import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/auth/cubit/signup_cubit.dart';
import 'package:taskbit/auth/widgets/signup_form.dart';
import 'package:taskbit/cubit/avatar_select_cubit.dart';
import 'package:taskbit/cubit/navigation_cubit.dart';
import 'package:taskbit/widgets/logo.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  static Page page() {
    return const MaterialPage<void>(child: SignupPage());
  }

  @override
  Widget build(BuildContext context) {
    final signupCubit = BlocProvider.of<SignupCubit>(context);
    final avatarSelectCubit = BlocProvider.of<AvatarSelectCubit>(context);
    final navigationCubit = BlocProvider.of<NavigationCubit>(context);
    return WillPopScope(
      onWillPop: () async {
        signupCubit.resetState();
        avatarSelectCubit.resetState();
        navigationCubit.pageChanged(Pages.login);
        return true;
      },
      child: SingleChildScrollView(
        child: Column(
          children: const [
            Logo(),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: SignupForm(),
            ),
          ],
        ),
      ),
    );
  }
}
