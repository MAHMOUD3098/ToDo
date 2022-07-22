import 'package:flutter/material.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/constants.dart';

class ScheduledTaskItem extends StatelessWidget {
  const ScheduledTaskItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: CustomColors.kOrangeColor,
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
                  '09:00 AM',
                  style: TextStyle(color: CustomColors.kWhiteColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  'Design Team Meeting',
                  style: TextStyle(color: CustomColors.kWhiteColor),
                ),
              ],
            ),
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: true,
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
