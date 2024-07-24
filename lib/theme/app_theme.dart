import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:olly_chat/theme/colors.dart';



ThemeData appTheme = ThemeData(
  textTheme: GoogleFonts.josefinSansTextTheme(),
  fontFamily: 'Nunito',
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    tertiary: AppColors.secondaryColor,
    background: AppColors.backgroundlight,
    onBackground: AppColors.onBackgroundlight,
  ),
);

ThemeData appThemeDark = ThemeData(
    textTheme: GoogleFonts.josefinSansTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  fontFamily: 'Nunito',
  useMaterial3: true,
  colorScheme:  ColorScheme.dark(
    
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    tertiary: AppColors.secondaryColor,
   
    background: AppColors.backgroundDark,
    onBackground: AppColors.onBackgroundDark,
  ),
);
