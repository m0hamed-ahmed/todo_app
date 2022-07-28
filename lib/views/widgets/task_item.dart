import 'package:algoriza_internship_todo/app/methods.dart';
import 'package:algoriza_internship_todo/cubit/cubit.dart';
import 'package:algoriza_internship_todo/cubit/states.dart';
import 'package:algoriza_internship_todo/models/task_model.dart';
import 'package:algoriza_internship_todo/resources/color_manager.dart';
import 'package:algoriza_internship_todo/resources/enums.dart';
import 'package:algoriza_internship_todo/resources/routes_manager.dart';
import 'package:algoriza_internship_todo/resources/values_manager.dart';
import 'package:algoriza_internship_todo/views/widgets/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskItem extends StatelessWidget {
  final TaskModel taskModel;

  const TaskItem({Key? key, required this.taskModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return InkWell(
          onTap: () => Methods.showTaskItemModalBottomSheet(context: context, taskModel: taskModel),
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.p16),
            child: Row(
              children: [
                CustomCheckBox(id: taskModel.id, isChecked: taskModel.isComplected, color: Color(taskModel.color)),
                const SizedBox(width: AppSize.s20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        taskModel.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      if(taskModel.body != null) Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSize.s5),
                          Text(
                            taskModel.body!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: ColorManager.grey),
                          ),
                        ],
                      )
                    ],
                ),
                ),
                IconButton(
                  onPressed: () => cubit.updateIsFavorite(taskModel.id, !taskModel.isFavorite),
                  padding: const EdgeInsets.all(AppPadding.p0),
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  icon: Icon(taskModel.isFavorite ? Icons.favorite : Icons.favorite_border, color: ColorManager.green),
                ),
                IconButton(
                  onPressed: () => cubit.deleteData(taskModel.id),
                  padding: const EdgeInsets.all(AppPadding.p0),
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  icon: const Icon(Icons.delete, color: ColorManager.red),
                ),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, Routes.addEditTaskRoute, arguments: {'addEdit': AddEdit.edit, 'taskModel': taskModel}),
                  padding: const EdgeInsets.all(AppPadding.p0),
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  icon: const Icon(Icons.edit, color: ColorManager.green),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}