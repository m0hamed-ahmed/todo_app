import 'package:algoriza_internship_todo/models/task_model.dart';
import 'package:algoriza_internship_todo/resources/assets_manager.dart';
import 'package:algoriza_internship_todo/resources/values_manager.dart';
import 'package:algoriza_internship_todo/views/widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class CompletedTasksPage extends StatelessWidget {
  List<TaskModel> tasks = [];

  CompletedTasksPage({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(tasks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppPadding.p32),
        child: SvgPicture.asset(ImageAssets.completeTask),
      );
    }
    return ListView.separated(
      itemCount: tasks.length,
      itemBuilder: (context, index) => TaskItem(taskModel: tasks[index]),
      separatorBuilder: (context, index) => const Divider(height: AppSize.s0),
    );
  }
}