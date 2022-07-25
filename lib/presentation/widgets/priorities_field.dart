import 'package:flutter/material.dart';
import 'package:todo/data/repositories/add_task_repository.dart';
import 'package:todo/domain/blocs/add_task_bloc/cubit.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/locator.dart';
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
              locator.get<AddTaskRepository>().selectedPriority = 1;
              setState(() {});
            },
            priorityColor:
                locator.get<AddTaskRepository>().isLowPrioritySelected ? CustomColors.kBlueColor : CustomColors.kInputFieldsBackgroundColor,
            priorityText: 'Low',
            priorityTextColor: locator.get<AddTaskRepository>().isLowPrioritySelected ? CustomColors.kWhiteColor : Colors.black,
          ),
        ),
        Expanded(
          child: PriorityButton(
            onTap: () {
              addTaskCubit.selectPriority(2);
              locator.get<AddTaskRepository>().selectedPriority = 2;
              setState(() {});
            },
            priorityColor:
                locator.get<AddTaskRepository>().isMediumPrioritySelected ? CustomColors.kYellowColor : CustomColors.kInputFieldsBackgroundColor,
            priorityText: 'Medium',
            priorityTextColor: locator.get<AddTaskRepository>().isMediumPrioritySelected ? CustomColors.kWhiteColor : Colors.black,
          ),
        ),
        Expanded(
          child: PriorityButton(
            onTap: () {
              addTaskCubit.selectPriority(3);
              locator.get<AddTaskRepository>().selectedPriority = 3;
              setState(() {});
            },
            priorityColor:
                locator.get<AddTaskRepository>().isHighPrioritySelected ? CustomColors.kOrangeColor : CustomColors.kInputFieldsBackgroundColor,
            priorityText: 'High',
            priorityTextColor: locator.get<AddTaskRepository>().isHighPrioritySelected ? CustomColors.kWhiteColor : Colors.black,
          ),
        ),
        Expanded(
          child: PriorityButton(
            onTap: () {
              addTaskCubit.selectPriority(4);
              locator.get<AddTaskRepository>().selectedPriority = 4;
              setState(() {});
            },
            priorityColor:
                locator.get<AddTaskRepository>().isCriticalPrioritySelected ? CustomColors.kRedColor : CustomColors.kInputFieldsBackgroundColor,
            priorityText: 'Critical',
            priorityTextColor: locator.get<AddTaskRepository>().isCriticalPrioritySelected ? CustomColors.kWhiteColor : Colors.black,
          ),
        ),
      ],
    );
  }
}
