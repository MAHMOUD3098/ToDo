import 'package:flutter/material.dart';
import 'package:todo/presentation/utils/navigation.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    required this.hasActions,
    this.actions,
  }) : super(key: key);

  final String title;
  final bool hasActions;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
      ),
      leading: InkWell(
        onTap: () {
          NavigationHelper.goBackToHome(context);
        },
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
        ),
      ),
      actions: hasActions ? actions : null,
    );
  }
}
