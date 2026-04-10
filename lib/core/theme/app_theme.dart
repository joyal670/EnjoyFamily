import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const charcoal = Color(0xFF1A1A1A);
  static const saffron = Color(0xFFE67E22);
  static const warmBone = Color(0xFFF9F7F2);
  static const saffronDark = Color(0xFFCF6D17);
  static const saffronLight = Color(0xFFF39C12);
  static const glassWhite = Color(0x1AFFFFFF);
  static const glassBorder = Color(0x33FFFFFF);
  static const darkSurface = Color(0xFF242424);
  static const darkCard = Color(0xFF2D2D2D);
  static const textMuted = Color(0xFF9E9E9E);
}

class AppTextStyles {
  static TextStyle heroHeadline = GoogleFonts.playfairDisplay(
    fontSize: 64,
    fontWeight: FontWeight.w700,
    color: AppColors.warmBone,
    height: 1.1,
    letterSpacing: -1,
  );

  static TextStyle heroHeadlineMobile = GoogleFonts.playfairDisplay(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.warmBone,
    height: 1.15,
  );

  static TextStyle heroSubheadline = GoogleFonts.montserrat(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: AppColors.warmBone.withOpacity(0.85),
    height: 1.65,
  );

  static TextStyle heroSubheadlineMobile = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.warmBone.withOpacity(0.85),
    height: 1.65,
  );

  static TextStyle sectionTitle = GoogleFonts.playfairDisplay(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    color: AppColors.warmBone,
    height: 1.2,
  );

  static TextStyle sectionTitleDark = GoogleFonts.playfairDisplay(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    color: AppColors.charcoal,
    height: 1.2,
  );

  static TextStyle sectionTitleMobile = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.warmBone,
    height: 1.2,
  );

  static TextStyle sectionTitleMobileDark = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.charcoal,
    height: 1.2,
  );

  static TextStyle cardTitle = GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.warmBone,
  );

  static TextStyle cardBody = GoogleFonts.montserrat(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.warmBone.withOpacity(0.75),
    height: 1.6,
  );

  static TextStyle body = GoogleFonts.montserrat(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.charcoal.withOpacity(0.8),
    height: 1.7,
  );

  static TextStyle label = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.saffron,
    letterSpacing: 2.5,
  );

  static TextStyle navItem = GoogleFonts.montserrat(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.warmBone,
    letterSpacing: 0.5,
  );

  static TextStyle footerText = GoogleFonts.montserrat(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.warmBone.withOpacity(0.6),
    height: 1.6,
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.charcoal,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.saffron,
      surface: AppColors.darkSurface,
    ),
    textTheme: GoogleFonts.montserratTextTheme().apply(
      bodyColor: AppColors.warmBone,
      displayColor: AppColors.warmBone,
    ),
    useMaterial3: true,
  );
}
