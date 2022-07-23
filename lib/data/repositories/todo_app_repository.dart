import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ToDoAppRepository {
  late Database database;
  List<Map> allTasks = [];
  List<Map> completedTasks = [];
  List<Map> unCompletedTasks = [];
  List<Map> favoriteTasks = [];

  late TabController controller;
}
