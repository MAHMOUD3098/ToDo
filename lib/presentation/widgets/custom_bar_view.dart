import 'package:flutter/cupertino.dart';
import 'package:todo/presentation/widgets/scheduled_task_item.dart';

class CustomBarView extends StatelessWidget {
  const CustomBarView({
    Key? key,
    required this.dayName,
    required this.dayDate,
    required this.scheduledTasks,
  }) : super(key: key);

  final String dayName, dayDate;
  final List<Map>? scheduledTasks;

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
              itemCount: scheduledTasks == null ? 0 : scheduledTasks!.length,
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
