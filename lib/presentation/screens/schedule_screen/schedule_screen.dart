import 'package:flutter/material.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/constants.dart';
import 'package:todo/presentation/utils/styles.dart';
import 'package:todo/presentation/widgets/custom_app_bar.dart';
import 'package:todo/presentation/widgets/custom_divider.dart';
import 'package:todo/presentation/widgets/custom_weekday_bar_view.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class Day {
  final String dayName;
  final int dayNumber;

  Day(this.dayName, this.dayNumber);
}

class _ScheduleScreenState extends State<ScheduleScreen> with SingleTickerProviderStateMixin {
  late TabController controller;

  List<Day> weekDays = [
    Day('Sun', 1),
    Day('Mon', 1),
    Day('Tue', 1),
    Day('Wed', 1),
    Day('Thu', 1),
    Day('Fri', 1),
    Day('Sat', 1),
  ];

  List<Widget> getWeekDaysContainers(List<Day> weekDays) {
    List<Widget> list = [];
    for (var day in weekDays) {
      list.add(
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: CustomColors.kWhiteColor,
            borderRadius: Constants.kWeekDayContainerBorderRadius,
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  day.dayName,
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  day.dayNumber.toString(),
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: weekDays.length);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> weekDaysContainers = getWeekDaysContainers(weekDays);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Schedule', hasActions: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomDivider(),
          DefaultTabController(
            length: weekDays.length,
            child: Column(
              children: [
                TabBar(
                  onTap: (value) {
                    controller.index = value;
                    setState(() {});
                  },
                  labelColor: CustomColors.kWhiteColor,
                  labelStyle: CustomStyles.customTabBarLabelStyle,
                  unselectedLabelColor: Colors.black,
                  isScrollable: true,
                  enableFeedback: false,
                  splashBorderRadius: BorderRadius.zero,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  physics: const BouncingScrollPhysics(),
                  indicatorColor: Colors.transparent,
                  tabs: weekDaysContainers,
                ),
              ],
            ),
          ),
          const CustomDivider(),
          Expanded(
            child: TabBarView(
              controller: controller,
              physics: const BouncingScrollPhysics(),
              children: [
                CustomWeekDayBarView(
                  dayName: weekDays[controller.index].dayName,
                  dayDate: weekDays[controller.index].dayNumber.toString(),
                ),
                CustomWeekDayBarView(
                  dayName: weekDays[controller.index].dayName,
                  dayDate: weekDays[controller.index].dayNumber.toString(),
                ),
                CustomWeekDayBarView(
                  dayName: weekDays[controller.index].dayName,
                  dayDate: weekDays[controller.index].dayNumber.toString(),
                ),
                CustomWeekDayBarView(
                  dayName: weekDays[controller.index].dayName,
                  dayDate: weekDays[controller.index].dayNumber.toString(),
                ),
                CustomWeekDayBarView(
                  dayName: weekDays[controller.index].dayName,
                  dayDate: weekDays[controller.index].dayNumber.toString(),
                ),
                CustomWeekDayBarView(
                  dayName: weekDays[controller.index].dayName,
                  dayDate: weekDays[controller.index].dayNumber.toString(),
                ),
                CustomWeekDayBarView(
                  dayName: weekDays[controller.index].dayName,
                  dayDate: weekDays[controller.index].dayNumber.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
