import 'package:flutter/material.dart';
import 'package:e_commerce/constants/colors.dart';

class AppTheme {
  static ThemeData lightAppTheme = ThemeData(
    // Define text theme
    fontFamily: "Prompt",
    textTheme: textTheme,
    //define the default brightness and color
    colorScheme: _appColorScheme,
    // accentColor: secondaryColor,
    primaryColor: primaryColor,
    shadowColor: Colors.black45,
    // buttonColor: secondaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: surfaceColor,
    errorColor: errorColor,
    indicatorColor: whiteColor,
    iconTheme: const IconThemeData(color: Colors.black54),
    buttonTheme: const ButtonThemeData(
      colorScheme: _appColorScheme,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: primaryColor),
      titleSpacing: 10,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(16),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: outlineColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1.5,
            color: focusedOutlineColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: outlineColor,
          ),
        ),
        disabledBorder: InputBorder.none),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.black54,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 0,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      selectedIconTheme: IconThemeData(
        size: 24,
      ),
      unselectedIconTheme: IconThemeData(
        size: 24,
      ),
    ),
  );
}

//color scheme
const ColorScheme _appColorScheme = ColorScheme(
  primary: secondaryColor,
  primaryContainer: primaryDark,
  secondary: secondaryColor,
  secondaryContainer: secondaryLight,
  surface: surfaceColor,
  background: backgroundColor,
  error: errorColor,
  onPrimary: whiteColor,
  onSecondary: whiteColor,
  onSurface: secondaryColor,
  onBackground: secondaryColor,
  onError: whiteColor,
  brightness: Brightness.light,
);

//text theme
const TextTheme textTheme = TextTheme(
  headline1:
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
  headline2:
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
  headline3:
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
  headline4:
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
  headline5:
      TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
  bodyText1: TextStyle(
      fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
  bodyText2: TextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
  subtitle1: TextStyle(
      fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black54),
  subtitle2: TextStyle(
      fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black54),
  button: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  caption: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
  overline: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
);
