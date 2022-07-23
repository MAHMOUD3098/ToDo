import 'package:flutter/material.dart';
import 'package:todo/domain/blocs/add_task_bloc/cubit.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/widgets/priority_button.dart';

class PrioritiesField extends StatefulWidget {
  const PrioritiesField({Key? key}) : super(key: key);

  @override
  State<PrioritiesField> createState() => _PrioritiesFieldState();
}

class _PrioritiesFieldState extends State<PrioritiesField> {
  late AddTaskCubit addTaskCubit;
  @override
  void initState() {
    super.initState();
    addTaskCubit = AddTaskCubit.get(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PriorityButton(
            onTap: () {
              addTaskCubit.selectPriority(1);
              addTaskCubit.selectedPriority = 1;
              setState(() {});
            },
            priorityColor: addTaskCubit.isLowPrioritySelected ? CustomColors.kBlueColor : CustomColors.kInputFieldsBackgroundColor,
            priorityText: 'Low',
            priorityTextColor: addTaskCubit.isLowPrioritySelected ? CustomColors.kWhiteColor : Colors.black,
          ),
        ),
        Expanded(
          child: PriorityButton(
            onTap: () {
              addTaskCubit.selectPriority(2);
              addTaskCubit.selectedPriority = 2;
              setState(() {});
            },
            priorityColor: addTaskCubit.isMediumPrioritySelected ? CustomColors.kYellowColor : CustomColors.kInputFieldsBackgroundColor,
            priorityText: 'Medium',
            priorityTextColor: addTaskCubit.isMediumPrioritySelected ? CustomColors.kWhiteColor : Colors.black,
          ),
        ),
        Expanded(
          child: PriorityButton(
            onTap: () {
              addTaskCubit.selectPriority(3);
              addTaskCubit.selectedPriority = 3;
              setState(() {});
            },
            priorityColor: addTaskCubit.isHighPrioritySelected ? CustomColors.kOrangeColor : CustomColors.kInputFieldsBackgroundColor,
            priorityText: 'High',
            priorityTextColor: addTaskCubit.isHighPrioritySelected ? CustomColors.kWhiteColor : Colors.black,
          ),
        ),
        Expanded(
          child: PriorityButton(
            onTap: () {
              addTaskCubit.selectPriority(4);
              addTaskCubit.selectedPriority = 4;
              setState(() {});
            },
            priorityColor: addTaskCubit.isCriticalPrioritySelected ? CustomColors.kRedColor : CustomColors.kInputFieldsBackgroundColor,
            priorityText: 'Critical',
            priorityTextColor: addTaskCubit.isCriticalPrioritySelected ? CustomColors.kWhiteColor : Colors.black,
          ),
        ),
      ],
    );
  }
}
