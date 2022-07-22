import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/domain/blocs/app_bloc/states.dart';

class ToDoAppCubit extends Cubit<ToDoAppStates> {
  ToDoAppCubit() : super(ToDoAppInitialState());

  static ToDoAppCubit get(context) => BlocProvider.of<ToDoAppCubit>(context);

  // --------------------- UI --------------------- //

  late TabController controller;

  void tapBarTapped(int index) {
    controller.index = index;
    emit(TapBarTappedState());
  }
  // --------------------- UI --------------------- //

  // ---------------------DB interactions--------------------- //
  late Database database;
  List<Map> allTasks = [];
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
          'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, start_time TEXT, end_time TEXT, remind TEXT, repeat TEXT, priority INTEGER, is_completed INTEGER)',
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
      database = value;
    });
  }

  void getData(Database db) async {
    emit(LoadingState());
    allTasks = await db.rawQuery('SELECT * FROM Tasks');
    emit(GetDataState());
  }

  void addTask(Task task) {
    database.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO Tasks(title, date, start_time, end_time, remind, repeat, priority, is_completed) VALUES("${task.taskTitle}", "${task.taskDate}", ${task.startTime}, ${task.endTime}, ${task.remind}, ${task.repeat}  ${task.priority}, 0)',
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
    await deleteDatabase(path).then((value) => {emit(DropDatabaseState())});
  }
}
