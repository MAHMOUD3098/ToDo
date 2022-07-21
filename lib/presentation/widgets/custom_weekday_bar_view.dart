import 'package:flutter/cupertino.dart';
import 'package:todo/presentation/widgets/scheduled_task_item.dart';

class CustomWeekDayBarView extends StatelessWidget {
  const CustomWeekDayBarView({
    Key? key,
    required this.dayName,
    required this.dayDate,
  }) : super(key: key);

  final String dayName, dayDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(dayName), Text(dayDate)],
          ),
          Column(
            children: [
              ScheduledTaskItem(),
            ],
          )
        ],
      ),
    );
  }
}
