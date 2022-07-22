import 'package:flutter/material.dart';
import 'package:todo/domain/blocs/app_bloc/cubit.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({Key? key, required this.toDoAppCubit}) : super(key: key);

  final ToDoAppCubit toDoAppCubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Center(child: Text('Completed')),
      ],
    );
  }
}
