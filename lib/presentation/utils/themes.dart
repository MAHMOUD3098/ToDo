import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/presentation/utils/colors.dart';

class Themes {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: CustomColors.kWhiteColor,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: CustomColors.kWhiteColor,
      elevation: 0.0,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 25.0,
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    // scaffoldBackgroundColor: CustomColors.kDarkBackGroundColor,
    colorScheme: ColorScheme.dark(),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 25.0,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  );
}
