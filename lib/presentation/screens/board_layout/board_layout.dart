import 'package:flutter/material.dart';
import 'package:todo/presentation/screens/all_tasks/all_tasks_screen.dart';
import 'package:todo/presentation/screens/completed_tasks/completed_tasks_screen.dart';
import 'package:todo/presentation/screens/favorite_tasks/favorite_tasks_screen.dart';
import 'package:todo/presentation/screens/uncompleted_tasks/uncompleted_tasks_screen.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/styles.dart';

class BoardLayout extends StatefulWidget {
  const BoardLayout({Key? key}) : super(key: key);

  @override
  State<BoardLayout> createState() => _BoardLayoutState();
}

class _BoardLayoutState extends State<BoardLayout> with SingleTickerProviderStateMixin {
  List<Widget> screens = const [
    AllTasksScreen(),
    CompletedTasksScreen(),
    UncompletedTasksScreen(),
    FavoriteTasksScreen(),
  ];

  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: screens.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Board',
        ),
        leading: const Icon(
          Icons.arrow_back_ios_new_rounded,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            enableFeedback: false,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          DefaultTabController(
            length: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Divider(height: 1, color: CustomColors.kTabBarBorderColor),
                  TabBar(
                    onTap: (value) {
                      controller.index = value;
                    },
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
                  Divider(height: 1, color: CustomColors.kTabBarBorderColor),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: screens,
            ),
          ),
        ],
      ),
    );
  }
}