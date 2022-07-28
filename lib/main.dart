import 'package:algoriza_internship_todo/app/bloc_observer.dart';
import 'package:algoriza_internship_todo/app/my_behavior.dart';
import 'package:algoriza_internship_todo/cubit/cubit.dart';
import 'package:algoriza_internship_todo/resources/routes_manager.dart';
import 'package:algoriza_internship_todo/resources/theme_manager.dart';
import 'package:algoriza_internship_todo/views/screens/add_edit_task/cubit/cubit.dart';
import 'package:algoriza_internship_todo/views/screens/schedule/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppCubit()..getData()),
        BlocProvider(create: (context) => AddEditTaskCubit()),
        BlocProvider(create: (context) => ScheduleCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Algoriza Todo App',
        theme: getApplicationThemeLight(),
        onGenerateRoute: (routeSettings) => onGenerateRoute(routeSettings),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          );
        },
      ),
    );
  }
}