import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/domain/blocs/app_bloc/states.dart';
import 'package:todo/presentation/screens/all_tasks/all_tasks_screen.dart';
import 'package:todo/presentation/screens/completed_tasks/completed_tasks_screen.dart';
import 'package:todo/presentation/screens/favorite_tasks/favorite_tasks_screen.dart';
import 'package:todo/presentation/screens/uncompleted_tasks/uncompleted_tasks_screen.dart';

class ToDoAppCubit extends Cubit<ToDoAppStates> {
  ToDoAppCubit() : super(ToDoAppInitialState());

  static ToDoAppCubit get(context) => BlocProvider.of<ToDoAppCubit>(context);

  // --------------------- UI --------------------- //
  List<Widget> screens = const [
    AllTasksScreen(),
    CompletedTasksScreen(),
    UncompletedTasksScreen(),
    FavoriteTasksScreen(),
  ];

  late TabController controller;

  void tapBarTapped(int index) {
    controller.index = index;
    emit(TapBarTappedState());
  }

  // --------------------- UI --------------------- //

  // ---------------------DB interactions--------------------- //
  late Database database;
  List<Map> tasks = [];
  String path = '';

  // bool isLowPrioritySelected = false;
  // bool isMediumPrioritySelected = false;
  // bool isHighPrioritySelected = false;

  // HexColor lowPriorityColor = CustomColors.kLowPriorityColor;
  // HexColor mediumPriorityColor = CustomColors.kMediumPriorityColor;
  // HexColor highPriorityColor = CustomColors.kHighPriorityColor;

  // int getSelectedPriority(taskId) {
  //   int taskPriority = tasks.where((element) => element['id'] == taskId).first['priority'];
  //   switch (taskPriority) {
  //     case 1:
  //       isLowPrioritySelected = true;
  //       isMediumPrioritySelected = false;
  //       isHighPrioritySelected = false;
  //       break;

  //     case 2:
  //       isLowPrioritySelected = false;
  //       isMediumPrioritySelected = true;
  //       isHighPrioritySelected = false;
  //       break;

  //     case 3:
  //       isLowPrioritySelected = false;
  //       isMediumPrioritySelected = false;
  //       isHighPrioritySelected = true;
  //       break;

  //     default:
  //   }
  //   return taskPriority;
  // }

  // HexColor getPriorityColor(int priorityRank) {
  //   switch (priorityRank) {
  //     case 1:
  //       return CustomColors.kLowPriorityColor;
  //     case 2:
  //       return CustomColors.kMediumPriorityColor;
  //     case 3:
  //       return CustomColors.kHighPriorityColor;
  //     default:
  //       return CustomColors.kTaskItemBackgroundColor;
  //   }
  // }

  // void resetPriority() {
  //   isLowPrioritySelected = false;
  //   isMediumPrioritySelected = false;
  //   isHighPrioritySelected = false;
  // }

  // void selectPriority(int priority) {
  //   // priority 1:low, 2:medium, 3:high
  //   resetPriority();
  //   priority == 1 ? isLowPrioritySelected = true : false;
  //   priority == 2 ? isMediumPrioritySelected = true : false;
  //   priority == 3 ? isHighPrioritySelected = true : false;
  // }

  // void pressCheckBox(int id, bool newValue) {
  //   database.rawUpdate('UPDATE Tasks SET completed = ? WHERE id = ?', [(newValue ? '1' : '0'), '$id']).then((value) => null);
  //   emit(CheckBoxPressedState());
  //   getData(database);
  // }

  void createDatabase() async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'TodoApp.db');

    openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) {
        db.execute('CREATE TABLE Tasks (id INTEGER PRIMARY KEY, name TEXT, date TEXT, priority INTEGER, completed INTEGER)').then((value) {
          emit(CreateDatabaseState());
        });
      },
      onOpen: (db) {
        emit(OpenDatabaseState());
        getData(db);
      },
    ).then((value) {
      database = value;
    });
  }

  void getData(Database db) async {
    emit(LoadingState());
    tasks = await db.rawQuery('SELECT * FROM Tasks');
    emit(GetDataState());
  }

  void addTask(Task task) {
    database.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO Tasks(name, date, priority, completed) VALUES("${task.taskTitle}", "${task.taskDate}", ${task.priority}, 0)',
      )
          .then((value) {
        emit(AddTaskState());
        getData(database);
      });
    });
  }

  // void updateTask(Task task, int taskId) async {
  //   database.rawUpdate('UPDATE Tasks SET name = ?, date = ?, priority = ? WHERE id = ?', [task.taskName, task.taskDate, task.priority, taskId]).then(
  //       (value) => null);
  //   emit(UpdateTaskState());
  //   getData(database);
  // }

  void deleteTask(int id) {
    emit(LoadingState());
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', ['$id']).then((value) {
      emit(DeleteTaskState());
      getData(database);
    });
  }

  void dropDatabase() async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'TodoApp.db');
    await deleteDatabase(path).then((value) => {
      emit(DropDatabaseState())
    });
  }
}
