import 'package:algoriza_internship_todo/cubit/cubit.dart';
import 'package:algoriza_internship_todo/cubit/states.dart';
import 'package:algoriza_internship_todo/models/task_model.dart';
import 'package:algoriza_internship_todo/resources/color_manager.dart';
import 'package:algoriza_internship_todo/resources/string_manager.dart';
import 'package:algoriza_internship_todo/resources/values_manager.dart';
import 'package:algoriza_internship_todo/views/screens/schedule/cubit/cubit.dart';
import 'package:algoriza_internship_todo/views/screens/schedule/cubit/states.dart';
import 'package:algoriza_internship_todo/views/widgets/task_item_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  ScrollController scrollController = ScrollController();
  DateTime now = DateTime.now();
  int calendarWidth = 55;
  int calendarSeparatedWidth = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ScheduleCubit scheduleCubit = context.read<ScheduleCubit>();

      DateTime now = DateTime.now();
      scheduleCubit.changeSelectedDateInMilliSeconds(DateTime(now.year, now.month, now.day).millisecondsSinceEpoch);

      await scheduleCubit.goToCurrentDay(
        context: context,
        scrollController: scrollController,
        calendarWidth: calendarWidth,
        calendarSeparatedWidth: calendarSeparatedWidth,
        year: now.year,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return BlocBuilder<ScheduleCubit, ScheduleStates>(
          builder: (context, state) {
            ScheduleCubit scheduleCubit = ScheduleCubit.get(context);
            List<TaskModel> selectedTasks = cubit.tasks.where((element) => element.dateInMilliseconds == scheduleCubit.selectedDateInMilliSeconds).toList();
            return WillPopScope(
              onWillPop: () {
                scheduleCubit.onBackPressed(context);
                return true as Future<bool>;
              },
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(StringManager.schedule),
                  leading: IconButton(
                    onPressed: () => scheduleCubit.onBackPressed(context),
                    icon: const Icon(Icons.arrow_back_ios_rounded, size: AppSize.s16),
                  ),
                  shape: const Border(
                    bottom: BorderSide(color: ColorManager.grey1, width: AppSize.s2),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: AppPadding.p16, left: AppPadding.p16, right: AppPadding.p16, bottom: AppPadding.p8),
                        child: SizedBox(
                          height: AppSize.s65,
                          child: ListView.separated(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: DateTime(scheduleCubit.selectedYear, 12, 31).difference(DateTime(scheduleCubit.selectedYear, 1, 1)).inDays+1,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () => scheduleCubit.changeSelectedDateInMilliSeconds(DateTime(DateTime(scheduleCubit.selectedYear, 1, 1).add(Duration(days: index)).year, DateTime(scheduleCubit.selectedYear, 1, 1).add(Duration(days: index)).month, DateTime(scheduleCubit.selectedYear, 1, 1).add(Duration(days: index)).day).millisecondsSinceEpoch),
                              child: Container(
                                width: calendarWidth.toDouble(),
                                height: AppSize.s65,
                                padding: const EdgeInsets.symmetric(vertical: AppPadding.p5),
                                decoration: BoxDecoration(
                                  color: scheduleCubit.isSameTime(index) ? ColorManager.green : ColorManager.grey1,
                                  borderRadius: BorderRadius.circular(AppSize.s10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(DateFormat('MMM').format(DateTime(scheduleCubit.selectedYear, 1, 1).add(Duration(days: index))), style: TextStyle(color: scheduleCubit.isSameTime(index) ? ColorManager.white : ColorManager.grey)),
                                    Text(DateFormat('d').format(DateTime(scheduleCubit.selectedYear, 1, 1).add(Duration(days: index))), style: TextStyle(color: scheduleCubit.isSameTime(index) ? ColorManager.white : ColorManager.grey, fontSize: 22, fontWeight: FontWeight.bold)),
                                    Text(DateFormat('E').format(DateTime(scheduleCubit.selectedYear, 1, 1).add(Duration(days: index))), style: TextStyle(color: scheduleCubit.isSameTime(index) ? ColorManager.white : ColorManager.grey)),
                                  ],
                                ),
                              ),
                            ),
                            separatorBuilder: (context, index) => SizedBox(width: calendarSeparatedWidth.toDouble()),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
                          margin: const EdgeInsets.only(bottom: AppMargin.m16),
                          child: InkWell(
                            onTap: () => scheduleCubit.showDatePicker(
                              context: context,
                              scrollController: scrollController,
                              calendarWidth: calendarWidth,
                              calendarSeparatedWidth: calendarSeparatedWidth,
                            ),
                            borderRadius: BorderRadius.circular(AppSize.s10),
                            child: Container(
                              padding: const EdgeInsets.all(AppPadding.p10),
                              decoration: BoxDecoration(
                                color: ColorManager.grey1,
                                borderRadius: BorderRadius.circular(AppSize.s10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.calendar_month, size: AppSize.s16, color: ColorManager.grey),
                                  const SizedBox(width: AppSize.s5),
                                  Text(scheduleCubit.selectedYear.toString(), style: const TextStyle(color: ColorManager.grey, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: AppSize.s2,
                        color: ColorManager.grey1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppPadding.p16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(DateFormat('EEEE').format(DateTime.fromMillisecondsSinceEpoch(scheduleCubit.selectedDateInMilliSeconds)), style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(DateFormat('d MMM, y').format(DateTime.fromMillisecondsSinceEpoch(scheduleCubit.selectedDateInMilliSeconds)), style: const TextStyle(fontWeight: FontWeight.w500)),
                              ],
                            ),
                            const SizedBox(height: AppSize.s20),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: selectedTasks.length,
                              itemBuilder: (context, index) => TaskItemSchedule(taskModel: selectedTasks[index]),
                              separatorBuilder: (context, index) => const SizedBox(height: AppSize.s10),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}