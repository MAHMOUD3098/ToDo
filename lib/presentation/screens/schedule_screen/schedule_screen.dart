import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/repositories/schedule_screen_repository.dart';
import 'package:todo/domain/blocs/tasks_schedule_bloc/cubit.dart';
import 'package:todo/domain/blocs/tasks_schedule_bloc/states.dart';
import 'package:todo/presentation/utils/locator.dart';
import 'package:todo/presentation/widgets/custom_app_bar.dart';
import 'package:todo/presentation/widgets/custom_weekday_tab_bar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with SingleTickerProviderStateMixin {
  late TasksScheduleCubit tasksScheduleCubit;

  @override
  void initState() {
    super.initState();
    tasksScheduleCubit = TasksScheduleCubit.get(context);

    locator.get<ScheduleScreenRepository>().weekDays = tasksScheduleCubit.getNextWeek(DateTime(2022,2,27));
    tasksScheduleCubit.controller = TabController(length: locator.get<ScheduleScreenRepository>().weekDays.length, vsync: this);
    tasksScheduleCubit.getBarViews();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksScheduleCubit, TasksScheduleStates>(
      listener: (context, state) => {},
      builder: (context, state) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Schedule', hasActions: false),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWeekDaysTabBar(tasksScheduleCubit: tasksScheduleCubit),
              Expanded(
                child: TabBarView(
                  controller: tasksScheduleCubit.controller,
                  physics: const BouncingScrollPhysics(),
                  children: tasksScheduleCubit.barViews,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
