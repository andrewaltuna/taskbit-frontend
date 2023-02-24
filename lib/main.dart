import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:taskbit/app.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/auth/cubit/signup_cubit.dart';
import 'package:taskbit/tasks/cubit/task_create_cubit.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TasksCubit()),
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => SignupCubit()),
        BlocProvider(create: (_) => TaskCreateCubit()),
      ],
      child: const App(),
    ),
  );
}
