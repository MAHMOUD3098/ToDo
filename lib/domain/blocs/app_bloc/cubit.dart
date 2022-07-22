import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/data/repositories/todo_app_repository.dart';
import 'package:todo/domain/blocs/app_bloc/states.dart';
import 'package:todo/presentation/utils/locator.dart';

class ToDoAppCubit extends Cubit<ToDoAppStates> {
  ToDoAppCubit() : super(ToDoAppInitialState());

  static ToDoAppCubit get(context) => BlocProvider.of<ToDoAppCubit>(context);

  // --------------------- UI --------------------- //

  void tapBarTapped(int index) {
    locator.get<ToDoAppRepository>().controller.index = index;
    emit(TapBarTappedState());
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
      locator.get<ToDoAppRepository>().database = value;
    });
  }

  void getData(Database db) async {
    locator.get<ToDoAppRepository>().allTasks = await db.rawQuery('SELECT * FROM Tasks');
    emit(GetDataState());
  }

  void addTask(Task task) {
    locator.get<ToDoAppRepository>().database.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO Tasks(title, date, start_time, end_time, remind, repeat, priority, is_completed) VALUES("${task.taskTitle}", "${task.taskDate}", "${task.startTime}", "${task.endTime}", "${task.remind}", "${task.repeat}", ${task.priority}, 0)',
      )
          .then((value) {
        getData(locator.get<ToDoAppRepository>().database);
        emit(AddTaskState());
      });
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
}
