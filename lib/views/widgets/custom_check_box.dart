import 'package:algoriza_internship_todo/cubit/cubit.dart';
import 'package:algoriza_internship_todo/cubit/states.dart';
import 'package:algoriza_internship_todo/resources/color_manager.dart';
import 'package:algoriza_internship_todo/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomCheckBox extends StatelessWidget {
  final String id;
  final bool isChecked;
  final Color color;

  const CustomCheckBox({Key? key, required this.id, required this.isChecked, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return InkWell(
          onTap: () => cubit.updateIsComplected(id, !isChecked),
          borderRadius: BorderRadius.circular(AppSize.s8),
          child: Container(
            width: AppSize.s25,
            height: AppSize.s25,
            decoration: BoxDecoration(
              color: isChecked ? color : null,
              borderRadius: BorderRadius.circular(AppSize.s8),
              border: isChecked ? null : Border.all(color: color),
            ),
            child: isChecked ? const Icon(Icons.check, color: ColorManager.white, size: AppSize.s16) : null,
          ),
        );
      },
    );
  }
}