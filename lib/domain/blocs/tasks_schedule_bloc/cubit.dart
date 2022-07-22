import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/models/day.dart';
import 'package:todo/domain/blocs/tasks_schedule_bloc/states.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/constants.dart';
import 'package:todo/presentation/widgets/custom_bar_view.dart';
import 'package:todo/presentation/widgets/task_item.dart';

class TasksScheduleCubit extends Cubit<TasksScheduleStates> {
  TasksScheduleCubit() : super(TasksScheduleInitState());

  static TasksScheduleCubit get(context) => BlocProvider.of<TasksScheduleCubit>(context);

  late TabController controller;
  List<Day> weekDays = [
    Day('Sun', 1),
    Day('Mon', 1),
    Day('Tue', 1),
    Day('Wed', 1),
    Day('Thu', 1),
    Day('Fri', 1),
    Day('Sat', 1),
  ];
  List<Widget> getWeekDaysContainers(List<Day> weekDays, TabController controller) {
    List<Widget> list = [];
    for (var i = 0; i < weekDays.length; i++) {
      list.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: controller.index == i ? CustomColors.kGreenColor : CustomColors.kWhiteColor,
            borderRadius: Constants.kWeekDayContainerBorderRadius,
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  weekDays[i].dayName,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 10),
                Text(
                  weekDays[i].dayNumber.toString(),
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return list;
  }

  List<Widget> barViews = [];

  List<TaskItem> tasks = const [
    TaskItem(id: 1, taskTitle: ' taskTitle', priority: 1, isCompleted: true),
    TaskItem(id: 1, taskTitle: ' taskTitle', priority: 1, isCompleted: true),
    TaskItem(id: 1, taskTitle: ' taskTitle', priority: 1, isCompleted: true),
    TaskItem(id: 1, taskTitle: ' taskTitle', priority: 1, isCompleted: true),
    TaskItem(id: 1, taskTitle: ' taskTitle', priority: 1, isCompleted: true),
  ];

  List<Widget> getBarViews() {
    if (barViews.isEmpty) {
      for (int i = 0; i < weekDays.length; i++) {
        barViews.add(
          CustomBarView(
            dayName: 'day.dayName',
            dayDate: 'day.dayNumber.toString()',
            tasks: tasks,
          ),
        );
      }
    }
    return barViews;
  }

  void tapWeekDay(int index) {
    controller.index = index;
    emit(WeekDayTappedState());
  }
}
