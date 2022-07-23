import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/data/models/day.dart';
import 'package:todo/data/repositories/schedule_screen_repository.dart';
import 'package:todo/domain/blocs/tasks_schedule_bloc/states.dart';
import 'package:todo/presentation/utils/locator.dart';
import 'package:todo/presentation/widgets/custom_bar_view.dart';
import 'package:todo/presentation/widgets/custom_weekday_container.dart';
import 'package:todo/presentation/widgets/task_item.dart';

class TasksScheduleCubit extends Cubit<TasksScheduleStates> {
  TasksScheduleCubit() : super(TasksScheduleInitState());

  static TasksScheduleCubit get(context) => BlocProvider.of<TasksScheduleCubit>(context);

  List<Widget> barViews = [];
  List<TaskItem> taskItems = const [];

  void tapWeekDay(int index) {
    locator.get<ScheduleScreenRepository>().controller.index = index;

    emit(WeekDayTappedState());
  }

  String getMonthName(int monthNum) {
    Map<int, String> months = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec'
    };
    return months[monthNum]!;
  }

  String getDate(int index) {
    int dayNum = locator.get<ScheduleScreenRepository>().weekDays[index].dayNumber;
    String monthName = getMonthName(locator.get<ScheduleScreenRepository>().weekDays[index].monthOfDay);
    int year = locator.get<ScheduleScreenRepository>().weekDays[index].yearOfDay;

    return '$dayNum $monthName, $year';
  }

  List<Widget> getBarViews() {
    if (barViews.isEmpty) {
      for (int i = 0; i < locator.get<ScheduleScreenRepository>().weekDays.length; i++) {
        barViews.add(
          CustomBarView(
            dayName: locator.get<ScheduleScreenRepository>().weekDays[i].dayName,
            dayDate: getDate(i),
            tasks: taskItems,
          ),
        );
      }
    }
    return barViews;
  }

  List<Widget> getWeekDaysContainers(List<Day> weekDays) {
    List<Widget> list = [];
    for (int i = 0; i < weekDays.length; i++) {
      list.add(CustomWeekDayContainer(index: i));
    }
    return list;
  }

  Day getDay(DateTime date) {
    List<String> dateParts = date.toString().split(' ')[0].split('-');
    int day = int.parse(dateParts[2]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[0]);

    var dateTime = DateTime(year, month, day);

    return Day(DateFormat('EEEE').format(dateTime).substring(0, 3), day, month, year);
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
