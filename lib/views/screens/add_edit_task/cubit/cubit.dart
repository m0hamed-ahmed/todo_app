import 'package:algoriza_internship_todo/resources/color_manager.dart';
import 'package:algoriza_internship_todo/resources/string_manager.dart';
import 'package:algoriza_internship_todo/views/screens/add_edit_task/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class AddEditTaskCubit extends Cubit<AddEditTaskStates> {
  AddEditTaskCubit() : super(AddEditTaskInitialState());

  static AddEditTaskCubit get(context) => BlocProvider.of(context);

  bool _isClickButton = false;
  bool get isClickButton => _isClickButton;
  changeIsClickButton(bool isClickButton) {
    _isClickButton = isClickButton;
    emit(AddEditTaskIsClickButtonState());
  }

  DateTime? _date;
  DateTime? get date => _date;
  setDate(DateTime date) => _date = date;
  changeDate(DateTime? date) {
    _date = date;
    emit(AddEditTaskChangeDateState());
  }

  TimeOfDay? _startTimeOfDay;
  TimeOfDay? get startTimeOfDay => _startTimeOfDay;
  setStartTimeOfDay(TimeOfDay startTimeOfDay) => _startTimeOfDay = startTimeOfDay;
  changeStartTimeOfDay(TimeOfDay? startTimeOfDay) {
    _startTimeOfDay = startTimeOfDay;
    emit(AddEditTaskChangeStartTimeState());
  }

  TimeOfDay? _endTimeOfDay;
  TimeOfDay? get endTimeOfDay => _endTimeOfDay;
  setEndTimeOfDay(TimeOfDay endTimeOfDay) => _endTimeOfDay = endTimeOfDay;
  changeEndTimeOfDay(TimeOfDay? endTimeOfDay) {
    _endTimeOfDay = endTimeOfDay;
    emit(AddEditTaskChangeEndTimeState());
  }

  String? _reminder;
  String? get reminder => _reminder;
  setReminder(String reminder) => _reminder = reminder;
  changeReminder(String? reminder) {
    _reminder = reminder;
    emit(AddEditTaskChangeReminderState());
  }

  Color? _selectedColor;
  Color? get selectedColor => _selectedColor;
  setSelectedColor(Color selectedColor) => _selectedColor = selectedColor;
  changeSelectedColor(Color? selectedColor) {
    _selectedColor = selectedColor;
    emit(AddEditTaskChangeColorState());
  }

  showDatePicker(BuildContext context) async {
    DateTime now = DateTime.now();
    FocusScope.of(context).unfocus();
    DateTime? dateTime = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: _date == null
        ? now
        : DateTime(now.year, now.month, now.day).isAtSameMomentAs(DateTime(_date!.year, _date!.month, _date!.day)) ? _date : now,
      firstDate: now,
      lastDate: DateTime(2100, 12, 31),
      dateFormat: "dd-MMMM-yyyy",
      reverse: true,
      itemTextStyle: const TextStyle(color: ColorManager.green, fontWeight: FontWeight.bold),
      textColor: ColorManager.green,
    );
    if(dateTime != null) {
      changeDate(DateTime(dateTime.year, dateTime.month, dateTime.day));
    }
  }

  showStartTimePicker(BuildContext context) async {
    FocusScope.of(context).unfocus();
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: startTimeOfDay ?? TimeOfDay.now(),
      helpText: StringManager.selectStartTime,
    );
    if(timeOfDay != null) {
      changeStartTimeOfDay(timeOfDay);
    }
  }

  showEndTimePicker(BuildContext context) async {
    FocusScope.of(context).unfocus();
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: endTimeOfDay ?? TimeOfDay.now(),
      helpText: StringManager.selectEndTime,
    );
    if(timeOfDay != null) {
      changeEndTimeOfDay(timeOfDay);
    }
  }

  bool isTimeInPast() {
    if(_date != null) {
      DateTime dateTimeNow = DateTime.now();
      TimeOfDay timeOfDayNow = TimeOfDay.now();
      if(DateTime(dateTimeNow.year,dateTimeNow.month, dateTimeNow.day).isAtSameMomentAs(DateTime(_date!.year, _date!.month, _date!.day))) {
        if(_startTimeOfDay != null) {
          if(_startTimeOfDay!.hour < timeOfDayNow.hour) {
            return true;
          }
          if(_startTimeOfDay!.hour == timeOfDayNow.hour && _startTimeOfDay!.minute < timeOfDayNow.minute) {
            return true;
          }
        }
        else if(_endTimeOfDay != null) {
          if(_endTimeOfDay!.hour < timeOfDayNow.hour) {
            return true;
          }
          if(_endTimeOfDay!.hour == timeOfDayNow.hour && _endTimeOfDay!.minute < timeOfDayNow.minute) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool isTimeValidate() {
    if(_startTimeOfDay != null && _endTimeOfDay != null) {
      if(_startTimeOfDay!.hour > _endTimeOfDay!.hour) {
        return false;
      }
      if(_startTimeOfDay!.hour == _endTimeOfDay!.hour && _startTimeOfDay!.minute >= _endTimeOfDay!.minute) {
        return false;
      }
    }
    return true;
  }

  bool isAllValidate() {
    if(_date == null) {return false;}
    if(_startTimeOfDay == null) {return false;}
    if(_endTimeOfDay == null) {return false;}
    if(_reminder == null) {return false;}
    if(_selectedColor == null) {return false;}
    return true;
  }

  onBackPressed(BuildContext context) {
    changeIsClickButton(false);
    changeDate(null);
    changeStartTimeOfDay(null);
    changeEndTimeOfDay(null);
    changeReminder(null);
    changeSelectedColor(null);
    Navigator.pop(context);
  }
}