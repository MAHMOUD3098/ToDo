import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/repositories/todo_app_repository.dart';
import 'package:todo/domain/blocs/app_bloc/cubit.dart';
import 'package:todo/domain/blocs/app_bloc/states.dart';
import 'package:todo/presentation/screens/add_task/add_task_screen.dart';
import 'package:todo/presentation/screens/all_tasks/all_tasks_screen.dart';
import 'package:todo/presentation/screens/completed_tasks/completed_tasks_screen.dart';
import 'package:todo/presentation/screens/favorite_tasks/favorite_tasks_screen.dart';
import 'package:todo/presentation/screens/schedule_screen/schedule_screen.dart';
import 'package:todo/presentation/screens/uncompleted_tasks/uncompleted_tasks_screen.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/locator.dart';
import 'package:todo/presentation/utils/navigation.dart';
import 'package:todo/presentation/utils/styles.dart';
import 'package:todo/presentation/widgets/custom_app_bar.dart';
import 'package:todo/presentation/widgets/custom_button.dart';
import 'package:todo/presentation/widgets/custom_divider.dart';

class BoardLayout extends StatefulWidget {
  const BoardLayout({Key? key}) : super(key: key);

  @override
  State<BoardLayout> createState() => _BoardLayoutState();
}

class _BoardLayoutState extends State<BoardLayout> with SingleTickerProviderStateMixin {
  late ToDoAppCubit toDoAppCubit;
  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();

    toDoAppCubit = ToDoAppCubit.get(context);

    screens = [
      AllTasksScreen(toDoAppCubit: toDoAppCubit),
      CompletedTasksScreen(toDoAppCubit: toDoAppCubit),
      UncompletedTasksScreen(toDoAppCubit: toDoAppCubit),
      FavoriteTasksScreen(toDoAppCubit: toDoAppCubit),
    ];

    locator.get<ToDoAppRepository>().controller = TabController(vsync: this, length: screens.length);
  }

  @override
  void dispose() {
    locator.get<ToDoAppRepository>().controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Board',
            hasBackIcon: false,
            hasActions: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_month_outlined),
                enableFeedback: false,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  NavigationHelper.navigateTo(context, const ScheduleScreen());
                },
              ),
            ],
          ),
          body: Column(
            children: [
              DefaultTabController(
                length: screens.length,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      const CustomDivider(),
                      TabBar(
                        controller: locator.get<ToDoAppRepository>().controller,
                        onTap: (value) {
                          toDoAppCubit.tapBarTapped(value);
                        },
                        unselectedLabelColor: CustomColors.kInputFieldsTextColor,
                        isScrollable: true,
                        enableFeedback: false,
                        splashBorderRadius: BorderRadius.zero,
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        physics: const BouncingScrollPhysics(),
                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                          insets: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        labelColor: Colors.black,
                        labelStyle: CustomStyles.customTabBarLabelStyle,
                        tabs: const [
                          Tab(text: 'All'),
                          Tab(text: 'Completed'),
                          Tab(text: 'Uncompleted'),
                          Tab(text: 'Favorites'),
                        ],
                      ),
                      const CustomDivider(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          controller: locator.get<ToDoAppRepository>().controller,
                          children: screens,
                        ),
                      ),
                      CustomButton(
                        text: 'Add a task',
                        onPressed: () {
                          NavigationHelper.navigateTo(context, const AddTaskScreen());
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
