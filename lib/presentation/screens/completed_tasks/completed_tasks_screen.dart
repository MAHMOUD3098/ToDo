import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/repositories/todo_app_repository.dart';
import 'package:todo/domain/blocs/app_bloc/cubit.dart';
import 'package:todo/domain/blocs/app_bloc/states.dart';
import 'package:todo/presentation/utils/locator.dart';
import 'package:todo/presentation/widgets/task_item.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({Key? key, required this.toDoAppCubit}) : super(key: key);

  final ToDoAppCubit toDoAppCubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
      listener: (context, state) => {},
      builder: (context, state) {
        return Column(
          children: [
            locator.get<ToDoAppRepository>().completedTasks.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'No completed tasks exists',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                : Container(),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: locator.get<ToDoAppRepository>().completedTasks.length,
                itemBuilder: (context, index) {
                  TaskItem taskItem = TaskItem(
                    id: locator.get<ToDoAppRepository>().completedTasks[index]['id'],
                    taskTitle: locator.get<ToDoAppRepository>().completedTasks[index]['title'],
                    priority: locator.get<ToDoAppRepository>().completedTasks[index]['priority'],
                    isCompleted: locator.get<ToDoAppRepository>().completedTasks[index]['is_completed'] == 1 ? true : false,
                  );
                  return taskItem;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
