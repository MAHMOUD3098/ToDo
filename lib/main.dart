import 'package:flutter/material.dart';
import 'package:todo/presentation/screens/board_layout/board_layout.dart';
import 'package:todo/presentation/utils/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      home: const BoardLayout(),
    );
  }
}
