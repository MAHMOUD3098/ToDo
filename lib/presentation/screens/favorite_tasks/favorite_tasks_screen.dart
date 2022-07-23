import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/repositories/todo_app_repository.dart';
import 'package:todo/domain/blocs/app_bloc/cubit.dart';
import 'package:todo/domain/blocs/app_bloc/states.dart';
import 'package:todo/presentation/utils/locator.dart';
import 'package:todo/presentation/widgets/task_item.dart';

class FavoriteTasksScreen extends StatelessWidget {
  const FavoriteTasksScreen({Key? key, required this.toDoAppCubit}) : super(key: key);
  final ToDoAppCubit toDoAppCubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
      listener: (context, state) => {},
      builder: (context, state) {
        return Column(
          children: [
            locator.get<ToDoAppRepository>().favoriteTasks.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'No favorite tasks exists',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                : Container(),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: locator.get<ToDoAppRepository>().favoriteTasks.length,
                itemBuilder: (context, index) {
                  TaskItem taskItem = TaskItem(
                    id: locator.get<ToDoAppRepository>().favoriteTasks[index]['id'],
                    taskTitle: locator.get<ToDoAppRepository>().favoriteTasks[index]['title'],
                    priority: locator.get<ToDoAppRepository>().favoriteTasks[index]['priority'],
                    isCompleted: locator.get<ToDoAppRepository>().favoriteTasks[index]['is_completed'] == 1 ? true : false,
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
