import 'dart:math';
import 'package:algoriza_internship_todo/app/extensions.dart';
import 'package:algoriza_internship_todo/cubit/cubit.dart';
import 'package:algoriza_internship_todo/models/task_model.dart';
import 'package:algoriza_internship_todo/resources/color_manager.dart';
import 'package:algoriza_internship_todo/resources/enums.dart';
import 'package:algoriza_internship_todo/resources/routes_manager.dart';
import 'package:algoriza_internship_todo/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Methods {
  static String getRandomId() {
    List<String> characters = [
      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
      'a','b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
      'A','B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    ];
    String id = '';
    for(int i=0; i<20; i++) {
      id+= characters[Random().nextInt(characters.length)];
    }
    return id;
  }

  static showToast(String message, {Color toastColor = ColorManager.green}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(msg: message, backgroundColor: toastColor, fontSize: AppSize.s18);
  }

  static String showTime(String time) {
    String hour = time.split('-')[0].convertHourToFormat12().addZeroFormat();
    String minute = time.split('-')[1].addZeroFormat();

    String period;
    if(int.parse(time.split('-')[0]) > 12) {period = 'PM';}
    else if(int.parse(time.split('-')[0]) == 0) {period = 'AM';}
    else {period = 'AM';}

    return '$hour:$minute $period';
  }

  static showTaskItemModalBottomSheet({required BuildContext context, required TaskModel taskModel}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(taskModel.color),
      constraints: const BoxConstraints(minWidth: double.infinity, minHeight: AppSize.s200),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSize.s30), topRight: Radius.circular(AppSize.s30))),
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p30, vertical: AppPadding.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: AppSize.s14, color: ColorManager.white),
                      const SizedBox(width: AppSize.s5),
                      Text('${showTime(taskModel.startTime)} - ${showTime(taskModel.endTime)}', style: const TextStyle(color: ColorManager.white)),
                      const SizedBox(width: AppSize.s10),
                      Text(DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(taskModel.dateInMilliseconds)), style: const TextStyle(color: ColorManager.white)),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: ColorManager.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.read<AppCubit>().deleteData(taskModel.id);
                          },
                          padding: const EdgeInsets.all(AppPadding.p0),
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          icon: const Icon(Icons.delete, color: ColorManager.red),
                        ),
                      ),
                      const SizedBox(width: AppSize.s10),
                      Container(
                        decoration: const BoxDecoration(
                          color: ColorManager.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, Routes.addEditTaskRoute, arguments: {'addEdit': AddEdit.edit, 'taskModel': taskModel});
                          },
                          padding: const EdgeInsets.all(AppPadding.p0),
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          icon: const Icon(Icons.edit, color: ColorManager.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSize.s10),
              Text(taskModel.title, style: const TextStyle(color: ColorManager.white, fontSize: AppSize.s20, fontWeight: FontWeight.bold)),
              if(taskModel.body != null) Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSize.s5),
                  Text(taskModel.body!, style: const TextStyle(color: ColorManager.white)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}