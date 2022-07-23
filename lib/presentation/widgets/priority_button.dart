import 'package:flutter/material.dart';
import 'package:todo/presentation/utils/styles.dart';

class PriorityButton extends StatelessWidget {
  final Color priorityColor, priorityTextColor;
  final String priorityText;
  final void Function()? onTap;

  const PriorityButton({
    Key? key,
    required this.priorityColor,
    required this.priorityText,
    this.onTap,
    required this.priorityTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          decoration: BoxDecoration(
            color: priorityColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Center(
              child: Text(
                priorityText,
                style: CustomStyles.priorityButtonTextStyle.copyWith(color: priorityTextColor),
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
