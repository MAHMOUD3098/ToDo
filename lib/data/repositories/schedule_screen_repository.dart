import 'package:flutter/material.dart';
import 'package:todo/data/models/day.dart';
import 'package:todo/presentation/widgets/task_item.dart';

class ScheduleScreenRepository {
  late TabController controller;
  List<Day> weekDays = [];

  List<Widget> barViews = [];
  List<TaskItem> scheduledTasksItems = const [];

  List<Map<String, List<Map>>> scheduledTasks = [];
}
