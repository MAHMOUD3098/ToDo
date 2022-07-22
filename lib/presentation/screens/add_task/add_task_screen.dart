import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/domain/blocs/add_task_bloc/cubit.dart';
import 'package:todo/domain/blocs/add_task_bloc/states.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/widgets/custom_app_bar.dart';
import 'package:todo/presentation/widgets/custom_button.dart';
import 'package:todo/presentation/widgets/custom_divider.dart';
import 'package:todo/presentation/widgets/custom_dropdown_menu.dart';
import 'package:todo/presentation/widgets/custom_text_form_field.dart';
import 'package:todo/presentation/widgets/priority_button.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({Key? key}) : super(key: key);

  final _addTaskFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTaskCubit, AddTaskStates>(
      listener: (context, state) => {
        debugPrint(state.toString()),
      },
      builder: (context, state) {
        AddTaskCubit addTaskCubit = AddTaskCubit.get(context);
        return Scaffold(
          appBar: const CustomAppBar(
            title: 'Add Task',
            hasActions: false,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const CustomDivider(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: Form(
                    key: _addTaskFormKey,
                    // autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: addTaskCubit.titleController,
                          title: 'Title',
                          hintText: 'please type title',
                          validationErrorMessage: 'validationErrorMessage',
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          controller: addTaskCubit.dateController,
                          title: 'Date',
                          hintText: 'please type title',
                          isDateField: true,
                          validationErrorMessage: 'validationErrorMessage',
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: addTaskCubit.startTimeController,
                                title: 'Start Time',
                                hintText: ' -- : -- ',
                                isTimeField: true,
                                validationErrorMessage: 'validationErrorMessage',
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: CustomTextFormField(
                                controller: addTaskCubit.endTimeController,
                                title: 'End Time',
                                hintText: ' -- : -- ',
                                isTimeField: true,
                                validationErrorMessage: 'validationErrorMessage',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const CustomDropDownMenu(
                          title: 'Remind',
                          hint: 'Please choose reminder time',
                          items: [
                            '1 day before',
                            '1 hour before',
                            '30 min before',
                            '10 min before',
                          ],
                          validationErrorMessage: 'validationErrorMessage',
                        ),
                        const SizedBox(height: 10),
                        const CustomDropDownMenu(
                          title: 'Repeat',
                          hint: 'Please choose repeat',
                          items: [
                            'Daily',
                            'Weekly',
                            'Monthly',
                            'Yearly',
                          ],
                          validationErrorMessage: 'validationErrorMessage',
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: PriorityButton(
                                onTap: () {
                                  addTaskCubit.selectPriority(1);
                                  // selectedPriority = 1;
                                  // setState(() {});
                                },
                                priorityColor:
                                    addTaskCubit.isLowPrioritySelected ? CustomColors.kBlueColor : CustomColors.kInputFieldsBackgroundColor,
                                priorityText: 'Low',
                              ),
                            ),
                            Expanded(
                              child: PriorityButton(
                                onTap: () {
                                  addTaskCubit.selectPriority(2);
                                  // selectedPriority = 1;
                                  // setState(() {});
                                },
                                priorityColor:
                                    addTaskCubit.isMediumPrioritySelected ? CustomColors.kYellowColor : CustomColors.kInputFieldsBackgroundColor,
                                priorityText: 'Medium',
                              ),
                            ),
                            Expanded(
                              child: PriorityButton(
                                onTap: () {
                                  addTaskCubit.selectPriority(3); // selectedPriority = 1;
                                  // setState(() {});
                                },
                                priorityColor:
                                    addTaskCubit.isHighPrioritySelected ? CustomColors.kOrangeColor : CustomColors.kInputFieldsBackgroundColor,
                                priorityText: 'High',
                              ),
                            ),
                            Expanded(
                              child: PriorityButton(
                                onTap: () {
                                  addTaskCubit.selectPriority(4);
                                  // selectedPriority = 1;
                                  // setState(() {});
                                },
                                priorityColor:
                                    addTaskCubit.isCriticalPrioritySelected ? CustomColors.kRedColor : CustomColors.kInputFieldsBackgroundColor,
                                priorityText: 'Critical',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Create Task',
                          onPressed: () {
                            if (_addTaskFormKey.currentState!.validate()) {
                              addTaskCubit.addTask(
                                Task(
                                  addTaskCubit.titleController.text,
                                  addTaskCubit.dateController.text,
                                  addTaskCubit.startTimeController.text,
                                  addTaskCubit.endTimeController.text,
                                  addTaskCubit.remindDropDownChosenValue,
                                  addTaskCubit.repeatDropDownChosenValue,
                                  '1',
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
