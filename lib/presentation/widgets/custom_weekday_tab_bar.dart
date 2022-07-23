import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/repositories/schedule_screen_repository.dart';
import 'package:todo/domain/blocs/tasks_schedule_bloc/cubit.dart';
import 'package:todo/domain/blocs/tasks_schedule_bloc/states.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/locator.dart';
import 'package:todo/presentation/utils/styles.dart';
import 'package:todo/presentation/widgets/custom_divider.dart';

class CustomWeekDaysTabBar extends StatelessWidget {
  const CustomWeekDaysTabBar({Key? key, required this.tasksScheduleCubit}) : super(key: key);

  final TasksScheduleCubit tasksScheduleCubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksScheduleCubit, TasksScheduleStates>(
      listener: (context, state) => {debugPrint(state.toString())},
      builder: (context, state) {
        return DefaultTabController(
          length: locator.get<ScheduleScreenRepository>().weekDays.length,
          child: Column(
            children: [
              const CustomDivider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: TabBar(
                  controller: tasksScheduleCubit.controller,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                  onTap: (value) {
                    tasksScheduleCubit.tapWeekDay(value);
                  },
                  labelStyle: CustomStyles.customTabBarLabelStyle,
                  labelColor: CustomColors.kWhiteColor,
                  unselectedLabelColor: Colors.black,
                  isScrollable: true,
                  enableFeedback: false,
                  splashBorderRadius: BorderRadius.zero,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  physics: const BouncingScrollPhysics(),
                  indicatorColor: Colors.transparent,
                  tabs: tasksScheduleCubit.getWeekDaysContainers(locator.get<ScheduleScreenRepository>().weekDays),
                ),
              ),
              const CustomDivider(),
            ],
          ),
        );
      },
    );
  }
}
