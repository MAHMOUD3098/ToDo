import 'package:flutter/cupertino.dart';
import 'package:todo/data/repositories/schedule_screen_repository.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/constants.dart';
import 'package:todo/presentation/utils/locator.dart';

class CustomWeekDayContainer extends StatelessWidget {
  const CustomWeekDayContainer({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: locator.get<ScheduleScreenRepository>().controller.index == index ? CustomColors.kGreenColor : CustomColors.kWhiteColor,
        borderRadius: Constants.kWeekDayContainerBorderRadius,
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              locator.get<ScheduleScreenRepository>().weekDays[index].dayName,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            Text(
              locator.get<ScheduleScreenRepository>().weekDays[index].dayNumber.toString(),
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
