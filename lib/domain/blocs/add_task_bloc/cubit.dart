import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo/domain/blocs/add_task_bloc/states.dart';
import 'package:todo/presentation/utils/colors.dart';

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
    resetPriority();
    priority == 1 ? isLowPrioritySelected = true : false;
    priority == 2 ? isMediumPrioritySelected = true : false;
    priority == 3 ? isHighPrioritySelected = true : false;
    priority == 4 ? isCriticalPrioritySelected = true : false;
    emit(CreateTaskButtonPressedState());
  }

  // ---------------------DB interactions--------------------- //

  // ---------------------DB interactions--------------------- //

}
