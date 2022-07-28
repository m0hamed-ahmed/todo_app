import 'package:algoriza_internship_todo/cubit/cubit.dart';
import 'package:algoriza_internship_todo/cubit/states.dart';
import 'package:algoriza_internship_todo/resources/color_manager.dart';
import 'package:algoriza_internship_todo/resources/enums.dart';
import 'package:algoriza_internship_todo/resources/routes_manager.dart';
import 'package:algoriza_internship_todo/resources/string_manager.dart';
import 'package:algoriza_internship_todo/resources/values_manager.dart';
import 'package:algoriza_internship_todo/views/modules/all_tasks.dart';
import 'package:algoriza_internship_todo/views/modules/completed_tasks.dart';
import 'package:algoriza_internship_todo/views/modules/favorite_tasks.dart';
import 'package:algoriza_internship_todo/views/modules/uncompleted_tasks.dart';
import 'package:algoriza_internship_todo/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(StringManager.board),
              actions: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, Routes.scheduleRoute),
                  icon: const Icon(Icons.calendar_month),
                )
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(AppSize.s60),
                child: Column(
                  children: const [
                    Divider(color: ColorManager.grey1, thickness: AppSize.s2),
                    SizedBox(
                      width: double.infinity,
                      child: TabBar(
                        isScrollable: true,
                        unselectedLabelColor: ColorManager.grey2,
                        labelColor: ColorManager.black,
                        indicatorColor: ColorManager.black,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelPadding: EdgeInsets.symmetric(vertical: AppPadding.p16, horizontal: AppPadding.p16),
                        tabs: [
                          Text(StringManager.all),
                          Text(StringManager.completed),
                          Text(StringManager.uncompleted),
                          Text(StringManager.favorite),
                        ],
                      ),
                    ),
                    Divider(color: ColorManager.grey1, thickness: AppSize.s2, height: AppSize.s2),
                  ],
                ),
              ),
            ),
            body: state is AppLoadingState ? const Center(child: CircularProgressIndicator()) : Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      AllTasksPage(tasks: cubit.tasks),
                      CompletedTasksPage(tasks: cubit.tasks.where((element) => element.isComplected == true).toList()),
                      UncompletedTasksPage(tasks: cubit.tasks.where((element) => element.isComplected == false).toList()),
                      FavoriteTasksPage(tasks: cubit.tasks.where((element) => element.isFavorite == true).toList()),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(AppMargin.m16),
                  child: CustomButton(
                    onPressed: () => Navigator.pushNamed(context, Routes.addEditTaskRoute, arguments: {'addEdit': AddEdit.add}),
                    text: StringManager.addATask,
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