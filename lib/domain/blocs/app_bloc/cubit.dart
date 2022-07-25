import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/data/repositories/todo_app_repository.dart';
import 'package:todo/domain/blocs/app_bloc/states.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/locator.dart';

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

  Future<bool> addTask(Task task) async {
    late int id;
    await locator.get<ToDoAppRepository>().database.transaction((txn) async {
      id = await txn.rawInsert(
        'INSERT INTO Tasks(title, date, start_time, end_time, remind, repeat, priority, is_completed, is_favorite) VALUES("${task.taskTitle}", "${task.taskDate}", "${task.startTime}", "${task.endTime}", "${task.remind}", "${task.repeat}", ${task.priority}, 0, 0)',
      );
    });

    await getData(locator.get<ToDoAppRepository>().database);
    print(locator.get<ToDoAppRepository>().allTasks.where((element) => element['id'] == id.toString()));
    emit(AddTaskState());

    return id != 0;
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
}
