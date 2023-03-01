import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:taskbit/app.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/auth/cubit/signup_cubit.dart';
import 'package:taskbit/cubit/avatar_select_cubit.dart';
import 'package:taskbit/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/cubit/task_cubit.dart';
import 'package:taskbit/core/cubit/user_data_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => AvatarSelectCubit()),
        BlocProvider(
          create: (context) => SignupCubit(
            avatarSelectCubit: BlocProvider.of<AvatarSelectCubit>(context),
          ),
        ),
        BlocProvider(
          create: (context) => UserDataCubit(
            loginCubit: BlocProvider.of<LoginCubit>(context),
            avatarSelectCubit: BlocProvider.of<AvatarSelectCubit>(context),
          ),
        ),
        BlocProvider(
          create: (context) => TaskCubit(
            loginCubit: BlocProvider.of<LoginCubit>(context),
          ),
        ),
      ],
      child: const App(),
    ),
  );
}
