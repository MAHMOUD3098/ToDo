import 'package:flutter/cupertino.dart';

abstract class AddTaskStates {}

class AddTaskInitialState extends AddTaskStates {}

class PriorityButtonPressedState extends AddTaskStates {}

class CreateTaskButtonPressedState extends AddTaskStates {}
