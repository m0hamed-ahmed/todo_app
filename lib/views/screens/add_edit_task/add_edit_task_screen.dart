import 'dart:math';
import 'package:algoriza_internship_todo/app/extensions.dart';
import 'package:algoriza_internship_todo/app/local_notification_service.dart';
import 'package:algoriza_internship_todo/app/methods.dart';
import 'package:algoriza_internship_todo/cubit/cubit.dart';
import 'package:algoriza_internship_todo/cubit/states.dart';
import 'package:algoriza_internship_todo/models/task_model.dart';
import 'package:algoriza_internship_todo/resources/color_manager.dart';
import 'package:algoriza_internship_todo/resources/enums.dart';
import 'package:algoriza_internship_todo/resources/string_manager.dart';
import 'package:algoriza_internship_todo/resources/values_manager.dart';
import 'package:algoriza_internship_todo/views/screens/add_edit_task/cubit/cubit.dart';
import 'package:algoriza_internship_todo/views/screens/add_edit_task/cubit/states.dart';
import 'package:algoriza_internship_todo/views/widgets/build_color_circle.dart';
import 'package:algoriza_internship_todo/views/widgets/custom_button.dart';
import 'package:algoriza_internship_todo/views/widgets/custom_drop_down.dart';
import 'package:algoriza_internship_todo/views/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddEditTaskScreen extends StatefulWidget {
  final AddEdit addEdit;
  final TaskModel? taskModel;

  const AddEditTaskScreen({Key? key, required this.addEdit, this.taskModel}) : super(key: key);

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  List<Color> colors = const [Color(0xff5c6bc0), Color(0xfffbc02d), Color(0xff29b6f6), Color(0xff66bb6a), Color(0xffe57373)];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.addEdit == AddEdit.edit) {
      titleController.text = widget.taskModel!.title;
      bodyController.text = widget.taskModel!.body == null ? '' : widget.taskModel!.body!;
      context.read<AddEditTaskCubit>().setDate(DateTime.fromMillisecondsSinceEpoch(widget.taskModel!.dateInMilliseconds));
      context.read<AddEditTaskCubit>().setStartTimeOfDay(TimeOfDay(hour: int.parse(widget.taskModel!.startTime.split('-')[0]), minute: int.parse(widget.taskModel!.startTime.split('-')[1])));
      context.read<AddEditTaskCubit>().setEndTimeOfDay(TimeOfDay(hour: int.parse(widget.taskModel!.endTime.split('-')[0]), minute: int.parse(widget.taskModel!.endTime.split('-')[1])));
      context.read<AddEditTaskCubit>().setReminder(widget.taskModel!.reminder);
      context.read<AddEditTaskCubit>().setSelectedColor(Color(widget.taskModel!.color));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.read<AddEditTaskCubit>().onBackPressed(context);
        return true as Future<bool>;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.addEdit == AddEdit.add ? StringManager.addTask : StringManager.editTask),
          leading: IconButton(
            onPressed: () => context.read<AddEditTaskCubit>().onBackPressed(context),
            icon: const Icon(Icons.arrow_back_ios_rounded, size: AppSize.s16),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(AppSize.s10),
            child: Container(
              width: double.infinity,
              height: AppSize.s2,
              color: ColorManager.grey1,
            ),
          ),
        ),
        body: BlocBuilder<AddEditTaskCubit, AddEditTaskStates>(
          builder: (context, state) {
            AddEditTaskCubit cubit = AddEditTaskCubit.get(context);
            return state is AppLoadingState ? const Center(child: CircularProgressIndicator()) : Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(AppPadding.p16),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('${StringManager.title} *', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: AppSize.s10),
                                  CustomTextFormField(
                                    controller: titleController,
                                    hintText: StringManager.writeYourTitleHere,
                                    isValidatorRequired: true,
                                    isSuffixClear: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSize.s20),

                              // Body
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(StringManager.body, style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: AppSize.s10),
                                  CustomTextFormField(
                                    controller: bodyController,
                                    textInputType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    maxLines: 5,
                                    hintText: StringManager.writeYourBodyHere,
                                    isSuffixClear: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSize.s20),

                              // Date
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('${StringManager.date} *', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: AppSize.s10),
                                  CustomButton(
                                    onPressed: () => cubit.showDatePicker(context),
                                    text: cubit.date == null ? '-- / -- / ----' : '${cubit.date!.day.addZeroFormat()} / ${cubit.date!.month.addZeroFormat()} / ${cubit.date!.year.addZeroFormat()}',
                                    buttonColor: ColorManager.grey3,
                                    borderColor: cubit.isClickButton && cubit.date == null ? ColorManager.red700 : ColorManager.grey1,
                                    spacerIcon: Icons.keyboard_arrow_down,
                                    spacerIconColor: ColorManager.grey4,
                                    textColor: cubit.date == null ? ColorManager.grey : ColorManager.black,
                                    elevation: AppSize.s0,
                                  ),
                                  if(cubit.isClickButton && cubit.date == null) Column(
                                    children: [
                                      const SizedBox(height: AppSize.s5),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(AppPadding.p10, AppPadding.p5, AppPadding.p0, AppPadding.p0),
                                        child: Text(StringManager.required, style: TextStyle(color: ColorManager.red700, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSize.s20),

                              // Time
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('${StringManager.startTime} *', style: TextStyle(fontWeight: FontWeight.bold)),
                                            const SizedBox(height: AppSize.s10),
                                            CustomButton(
                                              onPressed: () => cubit.showStartTimePicker(context),
                                              text: cubit.startTimeOfDay == null ? '--:-- --' : '${cubit.startTimeOfDay!.hour.convertHourToFormat12().addZeroFormat()}:${cubit.startTimeOfDay!.minute.addZeroFormat()} ${cubit.startTimeOfDay!.period == DayPeriod.am ? 'AM' : 'PM'}',
                                              buttonColor: ColorManager.grey3,
                                              borderColor: cubit.isClickButton && cubit.startTimeOfDay == null ? ColorManager.red700 : ColorManager.grey1,
                                              spacerIcon: Icons.access_time,
                                              spacerIconColor: ColorManager.grey,
                                              textColor: cubit.startTimeOfDay == null ? ColorManager.grey : ColorManager.black,
                                              elevation: AppSize.s0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: AppSize.s10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('${StringManager.endTime} *', style: TextStyle(fontWeight: FontWeight.bold)),
                                            const SizedBox(height: AppSize.s10),
                                            CustomButton(
                                              onPressed: () => cubit.showEndTimePicker(context),
                                              text: cubit.endTimeOfDay == null ? '--:-- --' : '${cubit.endTimeOfDay!.hour.convertHourToFormat12().addZeroFormat()}:${cubit.endTimeOfDay!.minute.addZeroFormat()} ${cubit.endTimeOfDay!.period == DayPeriod.am ? 'AM' : 'PM'}',
                                              buttonColor: ColorManager.grey3,
                                              borderColor: cubit.isClickButton && cubit.endTimeOfDay == null ? ColorManager.red700 : ColorManager.grey1,
                                              spacerIcon: Icons.access_time,
                                              spacerIconColor: ColorManager.grey,
                                              textColor: cubit.endTimeOfDay == null ? ColorManager.grey : ColorManager.black,
                                              elevation: AppSize.s0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: cubit.isClickButton && cubit.startTimeOfDay == null ?  Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: AppSize.s5),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(AppPadding.p10, AppPadding.p5, AppPadding.p0, AppPadding.p0),
                                              child: Text(StringManager.required, style: TextStyle(color: ColorManager.red700, fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ) : const SizedBox(),
                                      ),
                                      const SizedBox(width: AppSize.s10),
                                      Expanded(
                                        child: cubit.isClickButton && cubit.endTimeOfDay == null ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: AppSize.s5),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(AppPadding.p10, AppPadding.p5, AppPadding.p0, AppPadding.p0),
                                              child: Text(StringManager.required, style: TextStyle(color: ColorManager.red700, fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ) : const SizedBox()
                                      ),
                                    ],
                                  ),
                                  if(cubit.isClickButton && !cubit.isTimeValidate()) Column(
                                    children: [
                                      const SizedBox(height: AppSize.s5),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(AppPadding.p10, AppPadding.p5, AppPadding.p0, AppPadding.p0),
                                        child: Text(StringManager.endTimeMustBeAfterStartTime, style: TextStyle(color: ColorManager.red700, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  if(cubit.isClickButton && cubit.isTimeValidate() && cubit.isTimeInPast()) Column(
                                    children: [
                                      const SizedBox(height: AppSize.s5),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(AppPadding.p10, AppPadding.p5, AppPadding.p0, AppPadding.p0),
                                        child: Text(StringManager.notAllowedToUseTheTimeInThePast, style: TextStyle(color: ColorManager.red700, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSize.s20),

                              // Remind
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('${StringManager.remind} *', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: AppSize.s10),
                                  CustomDropDown(
                                    dropDownValue: cubit.reminder,
                                    values: const ['No reminder', '1 minute before', '10 minute before', '30 minute before', '1 hour before', '1 day before'],
                                    hintText: StringManager.chooseReminder,
                                    borderColor: cubit.isClickButton && cubit.reminder == null ? ColorManager.red700 : ColorManager.grey1,
                                    onChanged: (val) => cubit.changeReminder(val),
                                  ),
                                  if(cubit.isClickButton && cubit.reminder == null) Column(
                                    children: [
                                      const SizedBox(height: AppSize.s5),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(AppPadding.p10, AppPadding.p5, AppPadding.p0, AppPadding.p0),
                                        child: Text(StringManager.required, style: TextStyle(color: ColorManager.red700, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSize.s20),

                              // Color
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(StringManager.taskColor, style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: AppSize.s10),
                                  Row(
                                    children: [
                                      CustomButton(
                                        width: AppSize.s100,
                                        height: AppSize.s30,
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (context) => StatefulBuilder(
                                                builder: (context, setState) {
                                                  return AlertDialog(
                                                    title: Text(StringManager.chooseTheTaskColor, style: TextStyle(color: cubit.selectedColor??ColorManager.black)),
                                                    content: SingleChildScrollView(
                                                      child: MaterialPicker(
                                                        pickerColor: cubit.selectedColor??ColorManager.red,
                                                        onColorChanged: (color) => setState(() => cubit.changeSelectedColor(color)),
                                                        portraitOnly: true,
                                                      ),
                                                    ),
                                                    actions: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          CustomButton(
                                                            width: AppSize.s100,
                                                            height: AppSize.s35,
                                                            onPressed: () => Navigator.of(context).pop(),
                                                            buttonColor: cubit.selectedColor??ColorManager.white,
                                                            borderColor: cubit.selectedColor == null ? ColorManager.grey2 : Colors.transparent,
                                                            textColor: cubit.selectedColor == null ? ColorManager.black : ColorManager.white,
                                                            elevation: AppSize.s0,
                                                            radius: AppSize.s5,
                                                            text: StringManager.ok,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                }
                                            ),
                                          );
                                        },
                                        buttonColor: cubit.selectedColor??ColorManager.white,
                                        borderColor: cubit.selectedColor == null ? ColorManager.grey2 : Colors.transparent,
                                        textColor: cubit.selectedColor == null ? ColorManager.black : ColorManager.white,
                                        elevation: AppSize.s0,
                                        text: StringManager.chooseColor,
                                      ),
                                      const SizedBox(width: AppSize.s5),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: List.generate(colors.length, (index) => Flexible(
                                            child: BuildColorCircle(color: colors[index], isChecked: cubit.selectedColor == colors[index]),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if(cubit.isClickButton && cubit.selectedColor == null) Column(
                                    children: [
                                      const SizedBox(height: AppSize.s5),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(AppPadding.p10, AppPadding.p5, AppPadding.p0, AppPadding.p0),
                                        child: Text(StringManager.required, style: TextStyle(color: ColorManager.red700, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                ),
                Container(
                  margin: const EdgeInsets.all(AppMargin.m16),
                  child: CustomButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      cubit.changeIsClickButton(true);
                      if(formKey.currentState!.validate() && cubit.isAllValidate() && cubit.isTimeValidate() && !cubit.isTimeInPast()) {
                        if(widget.addEdit == AddEdit.add) {
                          TaskModel taskModel = TaskModel(
                            id: Methods.getRandomId(),
                            title: titleController.text.trim(),
                            body: bodyController.text.trim().isEmpty ? null : bodyController.text.trim(),
                            dateInMilliseconds: cubit.date!.millisecondsSinceEpoch,
                            startTime: '${cubit.startTimeOfDay!.hour}-${cubit.startTimeOfDay!.minute}',
                            endTime: '${cubit.endTimeOfDay!.hour}-${cubit.endTimeOfDay!.minute}',
                            reminder: cubit.reminder!,
                            color: cubit.selectedColor!.value,
                            isComplected: false,
                            isFavorite: false,
                          );
                          await context.read<AppCubit>().insertData(context, taskModel);

                          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(cubit.date!.millisecondsSinceEpoch);
                          DateTime scheduleDate = DateTime(dateTime.year, dateTime.month, dateTime.day, cubit.startTimeOfDay!.hour, cubit.startTimeOfDay!.minute);
                          LocalNotificationService.showScheduleNotification(id: Random().nextInt(2147483648), title: titleController.text.trim(), body: bodyController.text.trim(), dateTime: scheduleDate);

                          DateTime reminderDateTime = DateTime.fromMillisecondsSinceEpoch(cubit.date!.millisecondsSinceEpoch);
                          DateTime reminderScheduleDate = DateTime(reminderDateTime.year, reminderDateTime.month, reminderDateTime.day, cubit.startTimeOfDay!.hour, cubit.startTimeOfDay!.minute);
                          if(cubit.reminder! == '1 minute before') {reminderScheduleDate = reminderScheduleDate.subtract(const Duration(minutes: 1));}
                          else if(cubit.reminder! == '10 minute before') {reminderScheduleDate = reminderScheduleDate.subtract(const Duration(minutes: 10));}
                          else if(cubit.reminder! == '30 minute before') {reminderScheduleDate = reminderScheduleDate.subtract(const Duration(minutes: 30));}
                          else if(cubit.reminder! == '1 hour before') {reminderScheduleDate = reminderScheduleDate.subtract(const Duration(hours: 1));}
                          else if(cubit.reminder! == '1 day before') {reminderScheduleDate = reminderScheduleDate.subtract(const Duration(days: 1));}
                          LocalNotificationService.showScheduleNotification(id: Random().nextInt(2147483648), title: titleController.text.trim(), body: '${(cubit.reminder!.replaceAll(' before', ''))} and the task will start', dateTime: reminderScheduleDate);
                        }
                        else {
                          TaskModel taskModel = TaskModel(
                            id: widget.taskModel!.id,
                            title: titleController.text.trim(),
                            body: bodyController.text.trim().isEmpty ? null : bodyController.text.trim(),
                            dateInMilliseconds: cubit.date!.millisecondsSinceEpoch,
                            startTime: '${cubit.startTimeOfDay!.hour}-${cubit.startTimeOfDay!.minute}',
                            endTime: '${cubit.endTimeOfDay!.hour}-${cubit.endTimeOfDay!.minute}',
                            reminder: cubit.reminder!,
                            color: cubit.selectedColor!.value,
                            isComplected: widget.taskModel!.isComplected,
                            isFavorite: widget.taskModel!.isFavorite,
                          );
                          context.read<AppCubit>().updateData(taskModel);
                        }
                      }
                    },
                    text: widget.addEdit == AddEdit.add ? StringManager.createATask : StringManager.editATask,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }
}