import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/data/repositories/local_notification_repository.dart';
import 'package:todo/data/repositories/todo_app_repository.dart';
import 'package:todo/domain/blocs/app_bloc/states.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/local_notification_service.dart';
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

  void changeCheckBoxValue(bool value, int id) {
    locator.get<ToDoAppRepository>().allTasks.forEach((element) {
      if (element['id'] == id) {
        locator.get<ToDoAppRepository>().database.rawUpdate('UPDATE Tasks SET is_completed = ? WHERE id = ?', [(value ? 1 : 0), '$id']).then((value) {
          emit(ChangedTaskItemCheckBoxValueState());
          getData(locator.get<ToDoAppRepository>().database);
        });
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
  void createDatabase() async {
    var databasesPath = await getDatabasesPath();
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

  Future<void> getCompletedTasks(List<Map<dynamic, dynamic>> allTasks) async {
    locator.get<ToDoAppRepository>().completedTasks.clear();
    for (var element in allTasks) {
      if (element['is_completed'] == 1) {
        locator.get<ToDoAppRepository>().completedTasks.add(element);
      }
    }
  }

  Future<void> getAllTasks(Database db) async {
    locator.get<ToDoAppRepository>().allTasks = await db.rawQuery('SELECT * FROM Tasks');
    // print(locator.get<ToDoAppRepository>().allTasks);
  }

  Future<void> getFavoriteTasks(List<Map<dynamic, dynamic>> allTasks) async {
    locator.get<ToDoAppRepository>().favoriteTasks.clear();
    for (var element in allTasks) {
      if (element['is_favorite'] == 1) {
        locator.get<ToDoAppRepository>().favoriteTasks.add(element);
      }
    }
  }

  Future<void> getUnCompletedTasks(List<Map<dynamic, dynamic>> allTasks) async {
    locator.get<ToDoAppRepository>().unCompletedTasks.clear();
    for (var element in allTasks) {
      if (element['is_completed'] == 0) {
        locator.get<ToDoAppRepository>().unCompletedTasks.add(element);
      }
    }
  }

  Future<void> getData(Database db) async {
    getAllTasks(db)
        .then(
          (value) => {
            getCompletedTasks(locator.get<ToDoAppRepository>().allTasks).then(
              (value) => {
                getUnCompletedTasks(locator.get<ToDoAppRepository>().allTasks).then(
                  (value) => {
                    getFavoriteTasks(locator.get<ToDoAppRepository>().allTasks),
                  },
                )
              },
            ),
          },
        )
        .then((value) => {emit(GetDataState())});
  }

  Future<bool> addTask(Task task) async {
    locator.get<ToDoAppRepository>().database.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO Tasks(title, date, start_time, end_time, remind, repeat, priority, is_completed, is_favorite) VALUES("${task.taskTitle}", "${task.taskDate}", "${task.startTime}", "${task.endTime}", "${task.remind}", "${task.repeat}", ${task.priority}, 0, 0)',
      )
          .then((id) async {
        if (id != 0) {
          await getData(locator.get<ToDoAppRepository>().database);
          // setTaskRepeatFrequency(id),
          // setTaskLocalNotification(id),
          emit(AddTaskState());

          Map task = locator.get<ToDoAppRepository>().allTasks.where((element) => element['id'] == id.toString()).first;
          print(task);

          return true;
        }
      });
    });
    return false;
  }

  void toggleFavorite(int id) {
    locator.get<ToDoAppRepository>().allTasks.forEach((element) {
      if (element['id'] == id) {
        locator
            .get<ToDoAppRepository>()
            .database
            .rawUpdate('UPDATE Tasks SET is_favorite = ? WHERE id = ?', [(element['is_favorite'] == 0 ? 1 : 0), '$id']).then((value) {
          emit(AddToFavoriteButtonPressedState());
          getData(locator.get<ToDoAppRepository>().database);
        });
      }
    });
  }

  void deleteTask(int id) {
    locator.get<ToDoAppRepository>().database.rawDelete('DELETE FROM Tasks WHERE id = ?', ['$id']).then((value) {
      emit(DeleteTaskState());
      getData(locator.get<ToDoAppRepository>().database);
    });
  }

  void dropDatabase() async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'TodoApp.db');
    await deleteDatabase(path).then((value) => {emit(DropDatabaseState())});
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

  Future<void> setTaskRepeatFrequency(int taskId) async {
    Map task = locator.get<ToDoAppRepository>().allTasks.where((element) => element['id'] == taskId.toString()).first;

    await Workmanager().registerPeriodicTask(
      taskId.toString(),
      task['title'],
      inputData: <String, dynamic>{
        'id': taskId,
        'title': task['title'],
      },
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

  void setTaskReminder(int taskId) async {
    Map task = locator.get<ToDoAppRepository>().allTasks.where((element) => element['id'] == taskId.toString()).first;

    await Workmanager().registerOneOffTask(
      taskId.toString(),
      'Reminder',
      inputData: <String, dynamic>{
        'id': taskId,
        'title': 'reminder of ' + task['title'],
      },
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
  }

  Future<void> setTaskLocalNotification(int taskId) async {
    Map task = locator.get<ToDoAppRepository>().allTasks.where((element) => element['id'] == taskId).first;

    await locator.get<LocalNotificationRepository>().localNotificationService.showScheduledNotification(
          id: taskId,
          title: task['title'],
          body: task['date'],
          duration: getLocalNotificationDuration(task),
        );
  }
}

Duration getLocalNotificationDuration(Map task) {
  int hours = int.parse(task['startTime'].split(':')[0]);
  int minutes = int.parse(task['startTime'].split(':')[1]);
  int year = int.parse(task['date'].split(':')[0]);
  int month = int.parse(task['date'].split(':')[1]);
  int day = int.parse(task['date'].split(':')[2]);

  DateTime taskDate = DateTime(year, month, day, hours, minutes);

  return taskDate.difference(DateTime.now());
}
