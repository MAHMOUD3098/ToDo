import 'package:flutter/material.dart';
import 'package:todo/domain/blocs/add_task_bloc/cubit.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/constants.dart';
import 'package:todo/presentation/utils/styles.dart';

class CustomDropDownMenu extends StatefulWidget {
  const CustomDropDownMenu({
    Key? key,
    required this.title,
    required this.items,
    required this.hint,
    required this.validationErrorMessage,
  }) : super(key: key);

  final String title, hint, validationErrorMessage;
  final List<String> items;

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  String? _chosenValue;
  Color errorBorderColor = CustomColors.kInputFieldsBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: CustomStyles.customInputFieldTextStyle,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: CustomColors.kInputFieldsBackgroundColor,
              borderRadius: Constants.kInputFieldBorderRadius,
              border: Border.all(color: errorBorderColor),
            ),
            child: DropdownButtonFormField<String>(
              // autovalidateMode: AutovalidateMode.always,
              decoration: const InputDecoration.collapsed(
                hintText: '',
              ),
              value: _chosenValue,
              validator: (value) {
                if (value == null) {
                  errorBorderColor = Colors.red;
                  setState(() {});
                  return widget.validationErrorMessage;
                } else {
                  errorBorderColor = CustomColors.kInputFieldsBackgroundColor;
                  setState(() {});
                }
                return null;
              },
              focusColor: Colors.white,
              isExpanded: true,
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              items: widget.items.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                },
              ).toList(),
              hint: Text(
                widget.hint,
              ),
              onChanged: (String? value) {
                setState(() {
                  _chosenValue = value;
                  // AddTaskCubit()..remindDropDownChosenValue = value!;
                  // print(AddTaskCubit()..remindDropDownChosenValue.toString());
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
