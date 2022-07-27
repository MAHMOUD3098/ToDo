// ignore_for_file: unnecessary_statements

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/repositories/add_task_repository.dart';
import 'package:todo/domain/blocs/add_task_bloc/states.dart';
import 'package:todo/presentation/utils/locator.dart';

class AddTaskCubit extends Cubit<AddTaskStates> {
  AddTaskCubit() : super(AddTaskInitialState());

  static AddTaskCubit get(context) => BlocProvider.of<AddTaskCubit>(context);

  void resetAddTaskScreen() {
    resetPriority();
    locator.get<AddTaskRepository>().titleController = TextEditingController();
    locator.get<AddTaskRepository>().dateController = TextEditingController();
    locator.get<AddTaskRepository>().startTimeController = TextEditingController();
    locator.get<AddTaskRepository>().endTimeController = TextEditingController();
    locator.get<AddTaskRepository>().remindDropDownChosenValue = '';
    locator.get<AddTaskRepository>().repeatDropDownChosenValue = '';
  }

  void resetPriority() {
    locator.get<AddTaskRepository>().isLowPrioritySelected = false;
    locator.get<AddTaskRepository>().isMediumPrioritySelected = false;
    locator.get<AddTaskRepository>().isHighPrioritySelected = false;
    locator.get<AddTaskRepository>().isCriticalPrioritySelected = false;
  }

  void selectPriority(int priority) {
    // priority 1:low, 2:medium, 3:high, 4:critical
    resetPriority();
    priority == 1 ? locator.get<AddTaskRepository>().isLowPrioritySelected = true : false;
    priority == 2 ? locator.get<AddTaskRepository>().isMediumPrioritySelected = true : false;
    priority == 3 ? locator.get<AddTaskRepository>().isHighPrioritySelected = true : false;
    priority == 4 ? locator.get<AddTaskRepository>().isCriticalPrioritySelected = true : false;
    emit(PriorityButtonPressedState());
  }
}
