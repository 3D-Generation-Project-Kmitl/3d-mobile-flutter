import 'package:flutter/material.dart';
import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/constants/styles.dart';

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
      iconTheme: IconThemeData(color: Colors.black87),
    ),
    inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
  headline1: h1Style,
  headline2: h2Style,
  headline3: h3Style,
  headline4: h4StyleLight,
  headline5: h5StyleLight,
  bodyText1: bodyText1,
  bodyText2: bodyText2,
  subtitle1: subtitleLight,
  button: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  caption:
      TextStyle(fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline:
      TextStyle(fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);
