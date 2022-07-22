import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/data/repositories/todo_app_repository.dart';
import 'package:todo/domain/blocs/add_task_bloc/states.dart';
import 'package:todo/domain/blocs/app_bloc/cubit.dart';

import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/locator.dart';
import 'package:todo/presentation/utils/navigation.dart';

class AddTaskCubit extends Cubit<AddTaskStates> {
  AddTaskCubit() : super(AddTaskInitialState());

  static AddTaskCubit get(context) => BlocProvider.of<AddTaskCubit>(context);

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  String remindDropDownChosenValue = '';
  String repeatDropDownChosenValue = '';

  bool isLowPrioritySelected = false;
  bool isMediumPrioritySelected = false;
  bool isHighPrioritySelected = false;
  bool isCriticalPrioritySelected = false;

  HexColor lowPriorityColor = CustomColors.kBlueColor;
  HexColor mediumPriorityColor = CustomColors.kYellowColor;
  HexColor highPriorityColor = CustomColors.kOrangeColor;
  HexColor criticalPriorityColor = CustomColors.kRedColor;

  void resetPriority() {
    isLowPrioritySelected = false;
    isMediumPrioritySelected = false;
    isHighPrioritySelected = false;
    isCriticalPrioritySelected = false;
  }

  void selectPriority(int priority) {
    // priority 1:low, 2:medium, 3:high, 4:critical
    print(priority);
    resetPriority();
    priority == 1 ? isLowPrioritySelected = true : false;
    priority == 2 ? isMediumPrioritySelected = true : false;
    priority == 3 ? isHighPrioritySelected = true : false;
    priority == 4 ? isCriticalPrioritySelected = true : false;
    emit(CreateTaskButtonPressedState());
  }

  // ---------------------DB interactions--------------------- //

  void addTask(Task task) {
    // 'INSERT INTO Tasks(title, date, start_time, end_time, remind, repeat, priority, is_completed) VALUES("${task.taskTitle}", "${task.taskDate}", ${task.startTime}, ${task.endTime}, ${task.remind}, ${task.repeat}  ${task.priority}, 0)',

    locator.get<ToDoAppRepository>().database.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO Tasks(title, date, start_time, end_time, remind, repeat, priority, is_completed) VALUES("tt", "tt", "tt", "tt", "tt", "tt", 1, 0)',
      )
          .then((value) {
        emit(CreateTaskButtonPressedState());
        ToDoAppCubit().getData(locator.get<ToDoAppRepository>().database);
      });
    });
  }
  // ---------------------DB interactions--------------------- //

}
