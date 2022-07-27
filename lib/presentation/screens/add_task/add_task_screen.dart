import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/models/task.dart';
import 'package:todo/data/repositories/add_task_repository.dart';
import 'package:todo/domain/blocs/add_task_bloc/cubit.dart';
import 'package:todo/domain/blocs/add_task_bloc/states.dart';
import 'package:todo/domain/blocs/app_bloc/cubit.dart';
import 'package:todo/presentation/utils/constants.dart';
import 'package:todo/presentation/utils/locator.dart';
import 'package:todo/presentation/widgets/custom_app_bar.dart';
import 'package:todo/presentation/widgets/custom_button.dart';
import 'package:todo/presentation/widgets/custom_divider.dart';
import 'package:todo/presentation/widgets/custom_dropdown_menu.dart';
import 'package:todo/presentation/widgets/custom_text_form_field.dart';
import 'package:todo/presentation/widgets/priorities_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _addTaskFormKey = GlobalKey<FormState>();

  late AddTaskCubit addTaskCubit;

  @override
  void initState() {
    super.initState();
    addTaskCubit = AddTaskCubit.get(context);
    addTaskCubit.resetAddTaskScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTaskCubit, AddTaskStates>(
      listener: (context, state) => {
        debugPrint(state.toString()),
      },
      builder: (context, state) {
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
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: locator.get<AddTaskRepository>().titleController,
                          title: 'Title',
                          hintText: 'title',
                          validationErrorMessage: 'validationErrorMessage',
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          controller: locator.get<AddTaskRepository>().dateController,
                          title: 'Date',
                          hintText: 'date',
                          isDateField: true,
                          validationErrorMessage: 'validationErrorMessage',
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: locator.get<AddTaskRepository>().startTimeController,
                                title: 'Start Time',
                                hintText: 'start time',
                                isTimeField: true,
                                validationErrorMessage: 'validationErrorMessage',
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: CustomTextFormField(
                                controller: locator.get<AddTaskRepository>().endTimeController,
                                title: 'End Time',
                                hintText: 'end time',
                                isTimeField: true,
                                validationErrorMessage: 'validationErrorMessage',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const CustomDropDownMenu(
                          title: 'Remind',
                          hint: 'reminder',
                          items: [
                            'Never',
                            '1 day before',
                            '1 hour before',
                            '30 min before',
                            '10 min before',
                          ],
                          isRemindField: true,
                          validationErrorMessage: 'validationErrorMessage',
                        ),
                        const SizedBox(height: 10),
                        const CustomDropDownMenu(
                          title: 'Repeat',
                          hint: 'repeat',
                          items: [
                            'Never',
                            'Daily',
                            'Weekly',
                            'Monthly',
                            'Yearly',
                          ],
                          isRepeatField: true,
                          validationErrorMessage: 'validationErrorMessage',
                        ),
                        const SizedBox(height: 20),
                        const PrioritiesField(),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Create Task',
                          onPressed: () async {
                            ToDoAppCubit cubit = ToDoAppCubit.get(context);
                            if (_addTaskFormKey.currentState!.validate()) {
                              String remind = locator.get<AddTaskRepository>().remindDropDownChosenValue;
                              String repeat = locator.get<AddTaskRepository>().repeatDropDownChosenValue;
                              if (cubit.validateData(context)) {
                                int addedTaskId = await cubit.addTask(
                                  Task(
                                    locator.get<AddTaskRepository>().titleController.text,
                                    locator.get<AddTaskRepository>().dateController.text,
                                    locator.get<AddTaskRepository>().startTimeController.text,
                                    locator.get<AddTaskRepository>().endTimeController.text,
                                    locator.get<AddTaskRepository>().remindDropDownChosenValue,
                                    locator.get<AddTaskRepository>().repeatDropDownChosenValue,
                                    locator.get<AddTaskRepository>().selectedPriority,
                                  ),
                                );
                                if (addedTaskId != 0) {
                                  await cubit.setTaskLocalNotification(addedTaskId);
                                  if (remind != 'Never') {
                                    await cubit.setTaskReminder(addedTaskId);
                                  }
                                  if (repeat != 'Never') {
                                    await cubit.setTaskRepeatFrequency(addedTaskId);
                                  }
                                  Navigator.pop(context);
                                } else {
                                  Constants.showSnackBar(context, 'Task could not be added !!');
                                }
                              }
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
