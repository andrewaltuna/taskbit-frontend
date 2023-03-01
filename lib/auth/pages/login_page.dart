import 'package:flutter/material.dart';
import 'package:taskbit/auth/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page page() {
    return const MaterialPage<void>(child: LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: LoginForm(),
    );
  }
}
