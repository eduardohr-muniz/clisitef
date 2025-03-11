import 'package:flutter/material.dart';

class ThemeBase {
  static ThemeData get themeData {
    return ThemeData(
      primarySwatch: Colors.red,
      primaryColorLight: const Color.fromARGB(255, 1, 165, 253),
      primaryColorDark: Colors.blue.shade700,
      primaryColor: const Color.fromARGB(255, 24, 14, 109),
      fontFamily: 'Montserrat',
      colorScheme: ColorScheme.fromSwatch().copyWith(
        background: Colors.grey.shade200,
        primary: Colors.blue,
        secondary: Colors.orange,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(Colors.blue),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      textTheme: TextTheme(
        displaySmall: TextStyle(
          color: Colors.blue.shade300,
          fontSize: 12,
        ),
        // displayMedium: const TextStyle(
        //   color: Colors.yellow,
        //   fontSize: 14,
        // ),
        displayLarge: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 40, 190, 255),
        ),
        headlineMedium: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: const TextStyle(
          color: Colors.indigo,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          color: Colors.grey.shade900,
          fontSize: 12,
        ),
        bodyLarge: const TextStyle(
          color: Color.fromARGB(255, 80, 187, 245),
          fontSize: 16,
        ),
        // titleLarge: const TextStyle(
        //   color: Colors.green,
        //   fontSize: 10,
        //   fontWeight: FontWeight.bold,
        // ),
      ),
    );
  }

  static ThemeData get themeDark {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColorLight: const Color.fromARGB(255, 1, 165, 253),
      primaryColorDark: Colors.blue.shade700,
      primaryColor: const Color.fromARGB(255, 9, 82, 192),
      fontFamily: 'Montserrat',
      colorScheme: ColorScheme.fromSwatch().copyWith(
        background: Colors.grey.shade900,
        brightness: Brightness.dark,
        primary: Colors.blue,
        onBackground: Colors.red,
        secondary: Colors.orange,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(Colors.blue),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      textTheme: TextTheme(
        displaySmall: TextStyle(
          color: Colors.blue.shade300,
          fontSize: 12,
        ),
        // displayMedium: const TextStyle(
        //   color: Colors.yellow,
        //   fontSize: 14,
        // ),
        displayLarge: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 40, 190, 255),
        ),
        headlineMedium: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        bodyLarge: const TextStyle(
          color: Color.fromARGB(255, 80, 187, 245),
          fontSize: 18,
        ),
        // titleLarge: const TextStyle(
        //   color: Colors.green,
        //   fontSize: 10,
        //   fontWeight: FontWeight.bold,
        // ),
      ),
    );
  }
}
