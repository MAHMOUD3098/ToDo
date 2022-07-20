import 'package:flutter/material.dart';
import 'package:todo/presentation/utils/colors.dart';
import 'package:todo/presentation/utils/styles.dart';
import 'package:todo/presentation/widgets/custom_button.dart';
import 'package:todo/presentation/widgets/task_item.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({Key? key}) : super(key: key);

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
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.dehaze_rounded),
                onPressed: () {},
              ),
            ],
          )
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          // TaskItem taskItem = TaskItem(
                          //   id: cubit.tasks[index]['id'],
                          //   taskName: cubit.tasks[index]['name'],
                          //   taskDate: cubit.tasks[index]['date'],
                          //   priority: int.parse(cubit.tasks[index]['priority'].toString()),
                          //   isCompleted: cubit.tasks[index]['completed'] == 1 ? true : false,
                          // );
                          return const TaskItem(
                            id: 1,
                            isCompleted: true,
                            priority: 1,
                            taskTitle: 'Design team meeting',
                          );
                        },
                      ),
                    ),
                  ),
                  const CustomButton(text: 'Add a task')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
