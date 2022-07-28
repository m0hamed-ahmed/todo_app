import 'package:algoriza_internship_todo/resources/color_manager.dart';
import 'package:algoriza_internship_todo/views/screens/schedule/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';

class ScheduleCubit extends Cubit<ScheduleStates> {
  ScheduleCubit() : super(ScheduleInitialState());

  static ScheduleCubit get(context) => BlocProvider.of(context);

  int _selectedYear = DateTime.now().year;
  int get selectedYear => _selectedYear;
  changeSelectedYear(int selectedYear) {
    _selectedYear = selectedYear;
    emit(ScheduleSelectedYearState());
  }

  int _selectedDateInMilliSeconds = DateTime.now().millisecondsSinceEpoch;
  int get selectedDateInMilliSeconds => _selectedDateInMilliSeconds;
  changeSelectedDateInMilliSeconds(int selectedDateInMilliSeconds) {
    _selectedDateInMilliSeconds = selectedDateInMilliSeconds;
    emit(ScheduleSelectedDateInMilliSecondsState());
  }

  showDatePicker({required BuildContext context, required ScrollController scrollController, required int calendarWidth, required int calendarSeparatedWidth}) async {
    DateTime? dateTime = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime(_selectedYear),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      dateFormat: "yyyy",
      reverse: true,
      itemTextStyle: const TextStyle(color: ColorManager.green, fontWeight: FontWeight.bold),
      textColor: ColorManager.green,
    );
    if(dateTime != null) {
      changeSelectedYear(dateTime.year);
      goToCurrentDay(
        context: context,
        scrollController: scrollController,
        calendarWidth: calendarWidth,
        calendarSeparatedWidth: calendarSeparatedWidth,
        year: dateTime.year,
      );
    }
  }

  Future<void> goToCurrentDay({required BuildContext context, required ScrollController scrollController, required int calendarWidth, required int calendarSeparatedWidth, required int year}) async {
    DateTime now = DateTime.now();
    int dayInYear;

    if (year == now.year) {
      dayInYear = (int.parse(DateFormat('D').format(now)) - 1);
      changeSelectedDateInMilliSeconds(DateTime(now.year, now.month, now.day).millisecondsSinceEpoch);
    }
    else {
      dayInYear = 0;
      changeSelectedDateInMilliSeconds(DateTime(year,1,1).millisecondsSinceEpoch);
    }

    await scrollController.animateTo(
      (((calendarWidth + calendarSeparatedWidth) * dayInYear).toDouble()) - ((MediaQuery.of(context).size.width - 32 - calendarWidth)/2),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
    );
  }
  
  bool isSameTime(int index) {
    return DateTime.fromMillisecondsSinceEpoch(_selectedDateInMilliSeconds).isAtSameMomentAs(DateTime(_selectedYear, 1, 1).add(Duration(days: index)));
  }

  onBackPressed(BuildContext context) {
    changeSelectedYear(DateTime.now().year);
    changeSelectedDateInMilliSeconds(DateTime.now().millisecondsSinceEpoch);
    Navigator.pop(context);
  }
}