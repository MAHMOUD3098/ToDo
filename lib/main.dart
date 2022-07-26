import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/repositories/local_notification_repository.dart';
import 'package:todo/domain/blocs/add_task_bloc/cubit.dart';
import 'package:todo/domain/blocs/app_bloc/cubit.dart';
import 'package:todo/domain/blocs/tasks_schedule_bloc/cubit.dart';
import 'package:todo/presentation/screens/board_layout/board_layout.dart';
import 'package:todo/presentation/utils/locator.dart';
import 'package:todo/presentation/utils/themes.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    setup();
    locator.get<LocalNotificationRepository>().localNotificationService.initialize();

    if (inputData != null && inputData.isNotEmpty) {
      if (inputData['is_scheduled'] == true) {
        locator.get<LocalNotificationRepository>().localNotificationService.showScheduledNotification(
              id: 1,
              title: inputData['title'],
              body: 'freq body',
              runAfter: Duration(seconds: 0),
            );
      }
    }
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //setup the singletone concept for the project
  setup();

  // initialize local notification service
  locator.get<LocalNotificationRepository>().localNotificationService.initialize();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return ToDoAppCubit()..createDatabase();
          },
        ),
        BlocProvider(
          create: (context) {
            return AddTaskCubit();
          },
        ),
        BlocProvider(
          create: (context) {
            return TasksScheduleCubit();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: Themes.lightTheme,
        home: const BoardLayout(),
      ),
    );
  }
}
