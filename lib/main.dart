import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/domain/blocs/tasks_schedule_bloc/cubit.dart';
import 'package:todo/presentation/screens/board_layout/board_layout.dart';
import 'package:todo/presentation/utils/themes.dart';

void main() {
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
