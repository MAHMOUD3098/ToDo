import 'package:flutter/material.dart';
import 'package:todo/presentation/widgets/custom_button.dart';
import 'package:todo/presentation/widgets/task_item.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 12,
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
          ),
          const CustomButton(text: 'Add a task')
        ],
      ),
    );
  }
}
