import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo/presentation/utils/colors.dart';

class AddTaskRepository {
  int selectedPriority = 0;

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
}
