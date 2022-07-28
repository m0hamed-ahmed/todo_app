import 'package:algoriza_internship_todo/views/screens/add_edit_task/add_edit_task_screen.dart';
import 'package:algoriza_internship_todo/views/screens/board/board_screen.dart';
import 'package:algoriza_internship_todo/views/screens/schedule/schedule_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String boardRoute = '/BoardScreen';
  static const String addEditTaskRoute = '/AddEditTaskScreen';
  static const String scheduleRoute = '/ScheduleScreen';
}

PageRouteBuilder onGenerateRoute (routeSettings) {
  return PageRouteBuilder(
    settings: routeSettings,
    pageBuilder: (context, animation, secondaryAnimation) {
      switch (routeSettings.name) {
        case Routes.addEditTaskRoute: return AddEditTaskScreen(addEdit: routeSettings.arguments['addEdit'], taskModel: routeSettings.arguments['taskModel']);
        case Routes.scheduleRoute: return const ScheduleScreen();
        default: return const BoardScreen();
      }
    }
  );
}