import 'package:flutter/material.dart';
import 'package:todo/presentation/utils/navigation.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    required this.hasActions,
    this.actions,
    this.hasBackIcon = false,
  }) : super(key: key);

  final String title;
  final bool hasActions, hasBackIcon;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
      ),
      leading: hasBackIcon
          ? InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                NavigationHelper.goBackToHome(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
            )
          : null,
      actions: hasActions ? actions : null,
    );
  }
}
