import 'package:algoriza_internship_todo/app/methods.dart';
import 'package:algoriza_internship_todo/app/sqflite.dart';
import 'package:algoriza_internship_todo/cubit/states.dart';
import 'package:algoriza_internship_todo/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  MyDatabase myDatabase = MyDatabase();
  List<TaskModel> tasks = [];
  
  getData() {
    emit(AppLoadingState());
    String sql = "SELECT * FROM tasks";
    myDatabase.selectData(sql).then((value) {
      tasks = TaskModel.fromJsonList(value);
      emit(AppGetDataState());
    });
  }
  
  Future insertData(BuildContext context, TaskModel taskModel) async {
    emit(AppLoadingState());
    String sql = "INSERT INTO tasks (id, title, body, dateInMilliseconds, startTime, endTime, reminder, color, isComplected, isFavorite) VALUES ('${taskModel.id}', '${taskModel.title}', ${taskModel.body == null ? null : '"${taskModel.body}"'}, ${taskModel.dateInMilliseconds}, '${taskModel.startTime}', '${taskModel.endTime}', '${taskModel.reminder}', ${taskModel.color}, '${taskModel.isComplected}', '${taskModel.isFavorite}')";
    await myDatabase.insertData(sql).then((value) {
      tasks.add(taskModel);
      emit(AppInsertDataState());
      Methods.showToast('Added Successfully');
      Navigator.pop(context);
    });
  }

  updateData(TaskModel taskModel) {
    emit(AppLoadingState());
    String sql = "UPDATE tasks SET title = '${taskModel.title}', body = ${taskModel.body == null ? null : '"${taskModel.body}"'}, dateInMilliseconds = ${taskModel.dateInMilliseconds}, startTime = '${taskModel.startTime}', endTime = '${taskModel.endTime}', reminder = '${taskModel.reminder}', color = ${taskModel.color}, isComplected = '${taskModel.isComplected}', isFavorite = '${taskModel.isFavorite}' WHERE id = '${taskModel.id}'";
    myDatabase.updateData(sql).then((value) {
      int index = tasks.indexWhere((element) => element.id == taskModel.id);
      tasks[index] = taskModel;
      emit(AppUpdateDataState());
      Methods.showToast('Updated Successfully');
    });
  }

  deleteData(String id) {
    emit(AppLoadingState());
    String sql = "DELETE FROM tasks WHERE id = '$id'";
    myDatabase.deleteData(sql).then((value) {
      int index = tasks.indexWhere((element) => element.id == id);
      tasks.removeAt(index);
      emit(AppDeleteDataState());
      Methods.showToast('Deleted Successfully');
    });
  }

  updateIsComplected(String id, bool isComplected) {
    emit(AppLoadingState());
    String sql = "UPDATE tasks SET isComplected = '$isComplected' WHERE id = '$id'";
    myDatabase.updateData(sql).then((value) {
      int index = tasks.indexWhere((element) => element.id == id);
      tasks[index].isComplected = isComplected;
      emit(AppUpdateDataState());
    });
  }

  updateIsFavorite(String id, bool isFavorite) {
    emit(AppLoadingState());
    String sql = "UPDATE tasks SET isFavorite = '$isFavorite' WHERE id = '$id'";
    myDatabase.updateData(sql).then((value) {
      int index = tasks.indexWhere((element) => element.id == id);
      tasks[index].isFavorite = isFavorite;
      emit(AppUpdateDataState());
    });
  }
}