import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/data/models/day.dart';
import 'package:todo/data/repositories/schedule_screen_repository.dart';
import 'package:todo/domain/blocs/tasks_schedule_bloc/states.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/constants.dart';
import 'package:todo/presentation/utils/locator.dart';
import 'package:todo/presentation/widgets/custom_bar_view.dart';
import 'package:todo/presentation/widgets/task_item.dart';

class TasksScheduleCubit extends Cubit<TasksScheduleStates> {
  TasksScheduleCubit() : super(TasksScheduleInitState());

  static TasksScheduleCubit get(context) => BlocProvider.of<TasksScheduleCubit>(context);

  late TabController controller;
  List<Widget> barViews = [];
  List<TaskItem> taskItems = const [
    TaskItem(id: 1, taskTitle: ' taskTitle', priority: 1, isCompleted: true),
    TaskItem(id: 1, taskTitle: ' taskTitle', priority: 1, isCompleted: true),
    TaskItem(id: 1, taskTitle: ' taskTitle', priority: 1, isCompleted: true),
    TaskItem(id: 1, taskTitle: ' taskTitle', priority: 1, isCompleted: true),
    TaskItem(id: 1, taskTitle: ' taskTitle', priority: 1, isCompleted: true),
  ];

  void tapWeekDay(int index) {
    controller.index = index;
    emit(WeekDayTappedState());
  }

  List<Widget> getBarViews() {
    if (barViews.isEmpty) {
      for (int i = 0; i < locator.get<ScheduleScreenRepository>().weekDays.length; i++) {
        barViews.add(
          CustomBarView(
            dayName: 'day.dayName',
            dayDate: 'day.dayNumber.toString()',
            tasks: taskItems,
          ),
        );
      }
    }
    return barViews;
  }

  List<Widget> getWeekDaysContainers(List<Day> weekDays) {
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

  Day getDay(DateTime date) {
    List<String> dateParts = date.toString().split(' ')[0].split('-');
    int day = int.parse(dateParts[2]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[0]);

    var dateTime = DateTime(year, month, day);

    return Day(DateFormat('EEEE').format(dateTime).substring(0, 3), day);
  }

  int getNumOfDays(int month) {
    int numOfDays = 0;
    for (DateTime indexDay = DateTime(2022, month, 1); indexDay.month == month; indexDay = indexDay.add(const Duration(days: 1))) {
      numOfDays++;
    }
    return numOfDays;
  }

  List<Day> getNextWeek(DateTime date) {
    List<Day> nextWeekDays = [];

    DateTime currentDate = date;
    DateTime today = currentDate;

    int day = today.day - 1;
    int month = today.month;
    int year = today.year;

    int numOfDaysInCurrentMonth = getNumOfDays(month);

    DateTime nextDayDate = DateTime(year, month, day);
    for (int i = 0; i < 7; i++) {
      year = nextDayDate.year;
      month = nextDayDate.month;
      day = nextDayDate.day;

      if (day > numOfDaysInCurrentMonth) {
        day = 1;
        month++;
      }
      if (month > 12) {
        month = 1;
        year++;
      }

      day++;
      nextDayDate = DateTime(year, month, day);
      Day d = getDay(nextDayDate);
      nextWeekDays.add(d);
    }
    return nextWeekDays;
  }
}
