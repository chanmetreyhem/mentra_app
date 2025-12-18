import 'package:flutter/material.dart';

class AppTheme {

  static final dark = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(

        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        //  selectedItemColor: Colors.black
      ),
      fontFamily: 'googlesans' ,
      useMaterial3: true,
      primaryColor: Colors.white,
      primaryColorDark: Colors.white,
      textTheme: TextTheme(

        bodyMedium: TextStyle(fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontWeight: FontWeight.w700),
      )

  );

  static final light = ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(

      backgroundColor: Colors.white,
    //  selectedItemColor: Colors.black
    )
      ,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    fontFamily: 'googlesans',
    useMaterial3: true,
    primaryColor: Colors.black,
    primaryColorLight: Colors.black,
    textTheme: TextTheme(

      bodyMedium: TextStyle(fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontWeight: FontWeight.w700),
    )
  );
}