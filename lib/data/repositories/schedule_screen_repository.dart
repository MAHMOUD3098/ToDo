import 'package:flutter/material.dart';
import 'package:todo/data/models/day.dart';

class ScheduleScreenRepository {
  late TabController controller;
  List<Day> weekDays = [];

  List<Map<dynamic, dynamic>> scheduledTasks = [];
}
