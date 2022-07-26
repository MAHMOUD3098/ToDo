import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/constants.dart';
import 'package:todo/presentation/utils/styles.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText, validationErrorMessage, title;
  final bool isTimeField, isDateField;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.title,
    required this.hintText,
    this.isDateField = false,
    this.isTimeField = false,
    required this.validationErrorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomStyles.customInputFieldTextStyle,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            readOnly: isDateField || isTimeField,
            onTap: isDateField
                ? () async {
                    final DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100, 7),
                      helpText: 'Select a date',
                    );
                    if (newDate != null) {
                      controller.text = newDate.toString().split(' ')[0];
                    }
                  }
                : isTimeField
                    ? () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
                        ).then(
                          (value) {
                            if (value != null) {
                              DateTime date = DateFormat.jm().parse(value.format(context));
                              controller.text = DateFormat("HH:mm").format(date);
                            }
                          },
                        );
                      }
                    : () {},
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              hintText: hintText,
              filled: true,
              fillColor: CustomColors.kInputFieldsBackgroundColor,
              suffixIcon: isTimeField
                  ? Icon(
                      Icons.schedule,
                      color: CustomColors.kInputFieldsTextColor,
                    )
                  : isDateField
                      ? Icon(
                          Icons.calendar_month,
                          color: CustomColors.kInputFieldsTextColor,
                        )
                      : null,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.kInputFieldsBackgroundColor,
                  // width: 2.0,
                ),
                borderRadius: Constants.kInputFieldBorderRadius,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: Constants.kInputFieldBorderRadius,
                borderSide: BorderSide(
                  color: CustomColors.kInputFieldsBackgroundColor,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: Constants.kInputFieldBorderRadius,
                borderSide: const BorderSide(color: Colors.red),
              ),
              border: OutlineInputBorder(
                borderRadius: Constants.kInputFieldBorderRadius,
              ),
            ),
            validator: (String? val) {
              if (val != null) {
                if (val.isEmpty) {
                  return validationErrorMessage;
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
