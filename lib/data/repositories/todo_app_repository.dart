import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ToDoAppRepository {
  late Database database;
  List<Map> allTasks = [];

  late TabController controller;
}
