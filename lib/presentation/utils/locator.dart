import 'package:get_it/get_it.dart';
import 'package:todo/data/repositories/schedule_screen_repository.dart';
import 'package:todo/data/repositories/todo_app_repository.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<ToDoAppRepository>(() => ToDoAppRepository());
  locator.registerLazySingleton<ScheduleScreenRepository>(() => ScheduleScreenRepository());
}
