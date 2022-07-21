import 'package:flutter/material.dart';
import 'package:todo/presentation/widgets/custom_app_bar.dart';
import 'package:todo/presentation/widgets/custom_button.dart';
import 'package:todo/presentation/widgets/custom_divider.dart';
import 'package:todo/presentation/widgets/custom_dropdown_menu.dart';
import 'package:todo/presentation/widgets/custom_text_form_field.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({Key? key}) : super(key: key);

  final _addTaskFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                      controller: TextEditingController(),
                      title: 'Title',
                      hintText: 'please type title',
                      validationErrorMessage: 'validationErrorMessage',
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      controller: TextEditingController(),
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
                            controller: TextEditingController(),
                            title: 'Start Time',
                            hintText: ' -- : -- ',
                            isTimeField: true,
                            validationErrorMessage: 'validationErrorMessage',
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: CustomTextFormField(
                            controller: TextEditingController(),
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
                    CustomButton(
                      text: 'Create Task',
                      onPressed: () {
                        if (_addTaskFormKey.currentState!.validate()) {}
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
  }
}
