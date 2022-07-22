import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/domain/blocs/app_bloc/cubit.dart';
import 'package:todo/domain/blocs/app_bloc/states.dart';
import 'package:todo/presentation/widgets/task_item.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({Key? key, required this.toDoAppCubit}) : super(key: key);

  final ToDoAppCubit toDoAppCubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
      listener: (context, state) => {},
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: toDoAppCubit.allTasks.length,
                itemBuilder: (context, index) {
                  // TaskItem taskItem = TaskItem(
                  //   id: cubit.tasks[index]['id'],
                  //   taskName: cubit.tasks[index]['name'],
                  //   taskDate: cubit.tasks[index]['date'],
                  //   priority: int.parse(cubit.tasks[index]['priority'].toString()),
                  //   isCompleted: cubit.tasks[index]['completed'] == 1 ? true : false,
                  // );
                  return const TaskItem(
                    id: 1,
                    isCompleted: true,
                    priority: 1,
                    taskTitle: 'Design team meeting',
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
