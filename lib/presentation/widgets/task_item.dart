import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/domain/blocs/app_bloc/cubit.dart';
import 'package:todo/presentation/utils/styles.dart';

class TaskItem extends StatelessWidget {
  final int id;
  final String taskTitle;
  final int priority;
  final bool isCompleted;

  const TaskItem({
    Key? key,
    required this.id,
    required this.taskTitle,
    required this.priority,
    required this.isCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ToDoAppCubit toDoAppCubit = ToDoAppCubit.get(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          dismissible: DismissiblePane(
            onDismissed: () {
              toDoAppCubit.deleteTask(id);
            },
          ),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(5),
              label: 'delete',
              backgroundColor: Colors.red,
              icon: Icons.delete,
              onPressed: (_) {
                toDoAppCubit.deleteTask(id);
              },
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          width: double.infinity,
          child: Row(
            children: [
              SizedBox(
                width: 15,
                height: 15,
                child: Transform.scale(
                  scale: 1.4,
                  child: Checkbox(
                    value: isCompleted,
                    fillColor: MaterialStateProperty.all(toDoAppCubit.getCheckBoxColor(id)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    side: BorderSide(
                      color: toDoAppCubit.getCheckBoxColor(id),
                      width: 1.5,
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        toDoAppCubit.changeCheckBoxValue(value, id);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                child: Text(
                  taskTitle,
                  style: CustomStyles.customTaskTitleStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
