import 'package:flutter/material.dart';
import 'package:todo/presentation/utils/colors.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Divider(
        height: 2,
        color: CustomColors.kTabBarBorderColor,
      );
}
