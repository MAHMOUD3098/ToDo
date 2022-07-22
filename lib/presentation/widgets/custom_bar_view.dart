import 'package:flutter/cupertino.dart';
import 'package:todo/presentation/widgets/scheduled_task_item.dart';
import 'package:todo/presentation/widgets/task_item.dart';

class CustomBarView extends StatelessWidget {
  const CustomBarView({
    Key? key,
    required this.dayName,
    required this.dayDate,
    required this.tasks,
  }) : super(key: key);

  final String dayName, dayDate;
  final List<TaskItem> tasks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dayName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(dayDate),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return const ScheduledTaskItem();
              },
            ),
          )
        ],
      ),
    );
  }
}
