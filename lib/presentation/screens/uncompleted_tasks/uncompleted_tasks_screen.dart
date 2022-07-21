import 'package:flutter/material.dart';

class UncompletedTasksScreen extends StatelessWidget {
  const UncompletedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Center(child: Text('Uncompleted')),
      ],
    );
  }
}
