import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/domain/blocs/app_bloc/cubit.dart';
import 'package:todo/presentation/utils/colors.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          dismissible: DismissiblePane(
            onDismissed: () {
              ToDoAppCubit().deleteTask(id);
            },
          ),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(5),
              label: 'delete',
              backgroundColor: Colors.red,
              icon: Icons.delete,
              onPressed: (_) {
                ToDoAppCubit().deleteTask(id);
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
                    value: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    side: BorderSide(
                      color: CustomColors.kBlueColor,
                      width: 1.5,
                    ),
                    onChanged: (val) {},
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
