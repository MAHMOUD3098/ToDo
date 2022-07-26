import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/constants.dart';

class ScheduledTaskItem extends StatelessWidget {
  const ScheduledTaskItem({
    Key? key,
    required this.priorityColor,
    required this.title,
    required this.date,
    required this.isCompleted,
  }) : super(key: key);

  final HexColor priorityColor;
  final String title, date;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: priorityColor,
          borderRadius: Constants.kWeekDayContainerBorderRadius,
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(color: CustomColors.kWhiteColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: TextStyle(color: CustomColors.kWhiteColor),
                ),
              ],
            ),
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: isCompleted,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                fillColor: MaterialStateProperty.all(Colors.transparent),
                onChanged: (value) {},
                shape: const CircleBorder(),
                side: MaterialStateBorderSide.resolveWith(
                  (states) => const BorderSide(width: 1.5, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
