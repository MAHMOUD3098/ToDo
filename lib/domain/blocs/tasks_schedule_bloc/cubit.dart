import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:todo/data/models/day.dart';
import 'package:todo/data/repositories/schedule_screen_repository.dart';
import 'package:todo/data/repositories/todo_app_repository.dart';
import 'package:todo/domain/blocs/tasks_schedule_bloc/states.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/locator.dart';
import 'package:todo/presentation/widgets/custom_bar_view.dart';
import 'package:todo/presentation/widgets/custom_weekday_container.dart';

class TasksScheduleCubit extends Cubit<TasksScheduleStates> {
  TasksScheduleCubit() : super(TasksScheduleInitState());

  static TasksScheduleCubit get(context) => BlocProvider.of<TasksScheduleCubit>(context);

  bool matchDates(Day day, String date) {
    int dayNumber = day.dayNumber;
    int dayMonth = day.monthOfDay;
    int dayYear = day.yearOfDay;

    int dateNumber = int.parse(date.split('-')[2]);
    int dateMonth = int.parse(date.split('-')[1]);
    int dateYear = int.parse(date.split('-')[0]);

    return (dayNumber == dateNumber) && (dayMonth == dateMonth) && (dayYear == dateYear);
  }

  List<Map<String, List<Map>>> getScheduledItems() {
    List<Map<String, List<Map>>> scheduledTasks = [];
    List<Map> tasksToMap = [];
    late DateTime currentDate;
    for (var day in locator.get<ScheduleScreenRepository>().weekDays) {
      tasksToMap = [];
      currentDate = DateTime(day.yearOfDay, day.monthOfDay, day.dayNumber);
      for (var task in locator.get<ToDoAppRepository>().allTasks) {
        if (matchDates(day, task['date'])) {
          tasksToMap.add(task);
        } else if (task['repeat'] == 'Daily') {
          tasksToMap.add(task);
        } else if (task['repeat'] == 'Weekly') {
          DateTime taskDate = DateTime(
            int.parse(task['date'].toString().split('-')[0]),
            int.parse(task['date'].toString().split('-')[1]),
            int.parse(task['date'].toString().split('-')[2]),
          );
          if (currentDate.difference(taskDate).inDays == 7) {
            tasksToMap.add(task);
          }
        } else if (task['repeat'] == 'Monthly') {
          DateTime taskDate = DateTime(
            int.parse(task['date'].toString().split('-')[0]),
            int.parse(task['date'].toString().split('-')[1]),
            int.parse(task['date'].toString().split('-')[2]),
          );
          if (currentDate.difference(taskDate).inDays == 30) {
            tasksToMap.add(task);
          }
        }
      }
      scheduledTasks.add({currentDate.toString().split(' ')[0]: tasksToMap});
    }
    return scheduledTasks;
  }

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

  String getFullDayName(String shortenedWeekDayName) {
    Map<String, String> weekDays = {
      'Sun': 'Sunday',
      'Mon': 'Monday',
      'Tue': 'Tuesday',
      'Wed': 'Wednesday',
      'Thu': 'Thursday',
      'Fri': 'Friday',
      'Sat': 'Saturday',
    };
    return weekDays[shortenedWeekDayName]!;
  }

  List<Widget> getBarViews() {
    List<Widget> barViews = [];
    late Day weekDay;
    for (int i = 0; i < locator.get<ScheduleScreenRepository>().weekDays.length; i++) {
      weekDay = locator.get<ScheduleScreenRepository>().weekDays[i];
      barViews.add(
        CustomBarView(
          dayName: getFullDayName(locator.get<ScheduleScreenRepository>().weekDays[i].dayName),
          dayDate: getDate(i),
          scheduledTasks: locator.get<ScheduleScreenRepository>().scheduledTasks[i]
              [DateTime(weekDay.yearOfDay, weekDay.monthOfDay, weekDay.dayNumber).toString().split(' ')[0]],
        ),
      );
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

  int getNumOfDaysInMonth(int month) {
    int numOfDays = 0;
    for (DateTime indexDay = DateTime(2022, month, 1); indexDay.month == month; indexDay = indexDay.add(const Duration(days: 1))) {
      numOfDays++;
    }
    return numOfDays;
  }

  List<Day> getAllDays(DateTime date) {
    List<Day> allDays = [];
    int year = date.year;
    int month = date.month;
    int day = date.day;
    int numOfDays = 0;
    int daysPerYear = 0;

    for (int i = 1; i <= 2; i++) {
      daysPerYear = 0;
      for (int j = month; j <= 12; j++) {
        numOfDays = 0;
        for (DateTime indexDay = DateTime(year, j, day); indexDay.month == j; indexDay = indexDay.add(const Duration(days: 1))) {
          allDays.add(getDay(indexDay));
          numOfDays++;
        }
        daysPerYear += numOfDays;
        day = 1;
        month++;
      }
      month = 1;
      year++;
    }
    return allDays;
  }

  List<Day> getNextWeek(DateTime date) {
    List<Day> nextWeekDays = [];

    DateTime currentDate = date;
    DateTime today = currentDate;

    int day = today.day - 1;
    int month = today.month;
    int year = today.year;

    int numOfDaysInCurrentMonth = getNumOfDaysInMonth(month);

    DateTime nextDayDate = DateTime(year, month, day);
    for (int i = 0; i <= 7; i++) {
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

  HexColor getColor(int priority) {
    HexColor checkboxColor = CustomColors.kInputFieldsBackgroundColor;
    switch (priority) {
      case 1:
        checkboxColor = CustomColors.kBlueColor;
        break;

      case 2:
        checkboxColor = CustomColors.kYellowColor;
        break;

      case 3:
        checkboxColor = CustomColors.kOrangeColor;
        break;

      case 4:
        checkboxColor = CustomColors.kRedColor;
        break;

      default:
    }

    return checkboxColor;
  }
}
