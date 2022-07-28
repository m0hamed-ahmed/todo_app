import 'package:algoriza_internship_todo/resources/color_manager.dart';
import 'package:algoriza_internship_todo/resources/values_manager.dart';
import 'package:algoriza_internship_todo/views/screens/add_edit_task/cubit/cubit.dart';
import 'package:algoriza_internship_todo/views/screens/add_edit_task/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildColorCircle extends StatelessWidget {
  final Color color;
  final bool isChecked;

  const BuildColorCircle({Key? key, required this.color, this.isChecked = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEditTaskCubit, AddEditTaskStates>(
      builder: (context, state) {
        AddEditTaskCubit cubit = AddEditTaskCubit.get(context);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p5),
          child: InkWell(
            onTap: () => cubit.changeSelectedColor(color),
            borderRadius: BorderRadius.circular(AppSize.s15),
            child: Container(
              width: AppSize.s25,
              height: AppSize.s25,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: isChecked ? const Icon(Icons.check, color: ColorManager.white, size: AppSize.s16) : null,
            ),
          ),
        );
      }
    );
  }
}