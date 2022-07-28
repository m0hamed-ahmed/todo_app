import 'package:algoriza_internship_todo/app/methods.dart';
import 'package:algoriza_internship_todo/cubit/cubit.dart';
import 'package:algoriza_internship_todo/cubit/states.dart';
import 'package:algoriza_internship_todo/models/task_model.dart';
import 'package:algoriza_internship_todo/resources/color_manager.dart';
import 'package:algoriza_internship_todo/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskItemSchedule extends StatelessWidget {
  final TaskModel taskModel;

  const TaskItemSchedule({Key? key, required this.taskModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return InkWell(
          onTap: () => Methods.showTaskItemModalBottomSheet(context: context, taskModel: taskModel),
          borderRadius: BorderRadius.circular(AppSize.s10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSize.s15),
            decoration: BoxDecoration(
              color: Color(taskModel.color),
              borderRadius: BorderRadius.circular(AppSize.s10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${Methods.showTime(taskModel.startTime)} - ${Methods.showTime(taskModel.endTime)}', style: const TextStyle(color: ColorManager.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSize.s10),
                    Text(taskModel.title, style: const TextStyle(color: ColorManager.white, fontSize: AppSize.s16, fontWeight: FontWeight.bold)),
                  ],
                ),
                InkWell(
                  onTap: () => cubit.updateIsComplected(taskModel.id, !taskModel.isComplected),
                  child: Container(
                    width: AppSize.s20,
                    height: AppSize.s20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorManager.white),
                    ),
                    child: taskModel.isComplected ? const Icon(Icons.check, color: ColorManager.white, size: AppSize.s14) : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}