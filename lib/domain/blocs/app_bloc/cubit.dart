import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/data/repositories/local_notification_repository.dart';
import 'package:todo/data/repositories/todo_app_repository.dart';
import 'package:todo/domain/blocs/app_bloc/states.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/locator.dart';
import 'package:workmanager/workmanager.dart';

class ToDoAppCubit extends Cubit<ToDoAppStates> {
  ToDoAppCubit() : super(ToDoAppInitialState());

  static ToDoAppCubit get(context) => BlocProvider.of<ToDoAppCubit>(context);

  // --------------------- UI --------------------- //

  void tapBarTapped(int index) {
    locator.get<ToDoAppRepository>().controller.index = index;
    emit(TapBarTappedState());
  }

  Future<void> changeCheckBoxValue(bool value, int id) async {
    locator.get<ToDoAppRepository>().allTasks.forEach((element) async {
      if (element['id'] == id) {
        await locator.get<ToDoAppRepository>().database.rawUpdate('UPDATE Tasks SET is_completed = ? WHERE id = ?', [(value ? 1 : 0), '$id']);
        emit(ChangedTaskItemCheckBoxValueState());
        await getData(locator.get<ToDoAppRepository>().database);
      }
    });
  }

  HexColor getCheckBoxColor(int id) {
    HexColor checkboxColor = CustomColors.kInputFieldsBackgroundColor;
    locator.get<ToDoAppRepository>().allTasks.forEach((element) {
      if (element['id'] == id) {
        switch (element['priority']) {
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
      }
    });
    return checkboxColor;
  }
  // --------------------- UI --------------------- //

  // ---------------------DB interactions--------------------- //

  String path = '';
  Future<void> createDatabase() async {
    String databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'TodoApp.db');

    openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) {
        db
            .execute(
          'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, start_time TEXT, end_time TEXT, remind TEXT, repeat TEXT, priority INTEGER, is_completed INTEGER, is_favorite INTEGER)',
        )
            .then((value) {
          emit(CreateDatabaseState());
        });
      },
      onOpen: (db) {
        emit(OpenDatabaseState());
        getData(db);
      },
    ).then((value) {
      locator.get<ToDoAppRepository>().database = value;
    });
  }

  Future<void> getAllTasks(Database db) async {
    locator.get<ToDoAppRepository>().allTasks = await db.rawQuery('SELECT * FROM Tasks');
  }

  Future<void> getData(Database db) async {
    await getAllTasks(db);

    getCompletedTasks(locator.get<ToDoAppRepository>().allTasks);

    getUnCompletedTasks(locator.get<ToDoAppRepository>().allTasks);

    getFavoriteTasks(locator.get<ToDoAppRepository>().allTasks);

    emit(GetDataState());
  }

  Future<int> addTask(Task task) async {
    late int id;
    await locator.get<ToDoAppRepository>().database.transaction((txn) async {
      id = await txn.rawInsert(
        'INSERT INTO Tasks(title, date, start_time, end_time, remind, repeat, priority, is_completed, is_favorite) VALUES("${task.taskTitle}", "${task.taskDate}", "${task.startTime}", "${task.endTime}", "${task.remind}", "${task.repeat}", ${task.priority}, 0, 0)',
      );
    });

    await getData(locator.get<ToDoAppRepository>().database);
    emit(AddTaskState());
    return id;
  }

  Future<void> toggleFavorite(int id) async {
    locator.get<ToDoAppRepository>().allTasks.forEach((element) async {
      if (element['id'] == id) {
        await locator
            .get<ToDoAppRepository>()
            .database
            .rawUpdate('UPDATE Tasks SET is_favorite = ? WHERE id = ?', [(element['is_favorite'] == 0 ? 1 : 0), '$id']);
        emit(AddToFavoriteButtonPressedState());
        await getData(locator.get<ToDoAppRepository>().database);
      }
    });
  }

  Future<void> deleteTask(int id) async {
    await locator.get<ToDoAppRepository>().database.rawDelete('DELETE FROM Tasks WHERE id = ?', ['$id']);
    emit(DeleteTaskState());
    await getData(locator.get<ToDoAppRepository>().database);
  }

  Future<void> dropDatabase() async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'TodoApp.db');
    await deleteDatabase(path);
    emit(DropDatabaseState());
  }

  void getCompletedTasks(List<Map<dynamic, dynamic>> allTasks) {
    locator.get<ToDoAppRepository>().completedTasks.clear();
    for (var element in allTasks) {
      if (element['is_completed'] == 1) {
        locator.get<ToDoAppRepository>().completedTasks.add(element);
      }
    }
  }

  void getFavoriteTasks(List<Map<dynamic, dynamic>> allTasks) {
    locator.get<ToDoAppRepository>().favoriteTasks.clear();
    for (var element in allTasks) {
      if (element['is_favorite'] == 1) {
        locator.get<ToDoAppRepository>().favoriteTasks.add(element);
      }
    }
  }

  void getUnCompletedTasks(List<Map<dynamic, dynamic>> allTasks) {
    locator.get<ToDoAppRepository>().unCompletedTasks.clear();
    for (var element in allTasks) {
      if (element['is_completed'] == 0) {
        locator.get<ToDoAppRepository>().unCompletedTasks.add(element);
      }
    }
  }

  Duration getTaskRepeatFrequency(Map task) {
    Duration frequency = Duration();

    switch (task['repeat']) {
      case 'Daily':
        frequency = Duration(days: 1);
        break;

      case 'Weekly':
        frequency = Duration(days: 7);
        break;

      case 'Monthly':
        frequency = Duration(days: 30);
        break;

      case 'Yearly':
        frequency = Duration(days: 365);
        break;
      default:
    }
    return frequency;
  }

  Duration getTaskReminderTime(String remind) {
    Duration remindTime = Duration();

    switch (remind) {
      case '1 day before':
        remindTime = Duration(days: 1);
        break;

      case '1 hour before':
        remindTime = Duration(hours: 1);
        break;

      case '30 min before':
        remindTime = Duration(minutes: 30);
        break;

      case '10 min before':
        remindTime = Duration(minutes: 10);
        break;
      default:
    }
    return remindTime;
  }

  Future<void> setTaskRepeatFrequency(int taskId) async {
    Map task = locator.get<ToDoAppRepository>().allTasks.where((element) => element['id'] == taskId).first;

    await Workmanager().registerPeriodicTask(
      taskId.toString(),
      'Repeat',
      inputData: <String, dynamic>{
        'id': taskId,
        'title': 'repeat freq',
        'is_scheduled': true,
      },
      initialDelay: getTaskRepeatFrequency(task),
      frequency: getTaskRepeatFrequency(task),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
  }

  Future<void> setTaskReminder(int taskId) async {
    Map task = locator.get<ToDoAppRepository>().allTasks.where((element) => element['id'] == taskId).first;

    await locator.get<LocalNotificationRepository>().localNotificationService.showScheduledNotification(
          id: taskId,
          title: 'Reminder',
          body: 'Reminder of ' + task['title'],
          runAfter: getReminderDate(task['start_time'], task['date'], task['remind']).difference(DateTime.now()),
        );
  }

  Future<void> setTaskLocalNotification(int taskId) async {
    Map task = locator.get<ToDoAppRepository>().allTasks.where((element) => element['id'] == taskId).first;

    await locator.get<LocalNotificationRepository>().localNotificationService.showScheduledNotification(
          id: taskId,
          title: task['title'],
          body: task['date'],
          runAfter: getTaskDate(task['start_time'], task['date']).difference(DateTime.now()),
        );
  }

  DateTime getTaskDate(String startTime, String date) {
    int hours = int.parse(startTime.split(':')[0]);
    int minutes = int.parse(startTime.split(':')[1]);
    int year = int.parse(date.split('-')[0]);
    int month = int.parse(date.split('-')[1]);
    int day = int.parse(date.split('-')[2]);

    return DateTime(year, month, day, hours, minutes);
  }

  DateTime getReminderDate(String startTime, String date, String remind) {
    DateTime taskDate = getTaskDate(startTime, date);
    DateTime remindDate = taskDate.subtract(getTaskReminderTime(remind));

    return remindDate;
  }

  bool checkTaskTimes(String startTime, String endTime) {
    if (startTime.isEmpty && endTime.isEmpty) return false;

    int startTimeHour = int.parse(startTime.split(':')[0]);
    int startTimeMinutes = int.parse(startTime.split(':')[1]);

    int endTimeHour = int.parse(endTime.split(':')[0]);
    int endTimeMinutes = int.parse(endTime.split(':')[1]);

    if (startTimeHour > endTimeHour)
      return false;
    else if (startTimeHour == endTimeHour) {
      if (startTimeMinutes >= endTimeMinutes) return false;
    }

    return true;
  }

  bool checkTaskStartTime(String startTime, String taskDate) {
    DateTime date = DateTime(
      int.parse(taskDate.split('-')[0]),
      int.parse(taskDate.split('-')[1]),
      int.parse(taskDate.split('-')[2]),
      int.parse(startTime.split(':')[0]),
      int.parse(startTime.split(':')[1]),
    );
    if (date.difference(DateTime.now()).isNegative) {
      return false;
    }
    return true;
  }

  bool checkReminderAvailability(String startTime, String date, String remind) {
    DateTime remindDate = getReminderDate(startTime, date, remind);

    if (remindDate.difference(DateTime.now()).isNegative || remindDate.difference(DateTime.now()) == Duration.zero) {
      return false;
    }
    return true;
  }
}
