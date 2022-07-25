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

  void getScheduledItems() {
    List<Map> tasksToMap = [];
    String currentDate = '';
    for (var day in locator.get<ScheduleScreenRepository>().weekDays) {
      tasksToMap = [];
      currentDate = '';
      for (var task in locator.get<ToDoAppRepository>().allTasks) {
        if (matchDates(day, task['date'])) {
          currentDate = task['date'];
          tasksToMap.add(task);
        }
      }
      locator.get<ScheduleScreenRepository>().scheduledTasks.add({currentDate: tasksToMap});
    }
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

  List<Widget> getBarViews() {
    List<Widget> barViews = [];
    late Day weekDay;
    for (int i = 0; i < locator.get<ScheduleScreenRepository>().weekDays.length; i++) {
      weekDay = locator.get<ScheduleScreenRepository>().weekDays[i];
      barViews.add(
        CustomBarView(
          dayName: locator.get<ScheduleScreenRepository>().weekDays[i].dayName,
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
