import 'package:flutter/material.dart';

class XFarmTheme {
  // XFarm Agricultural Color Palette - Based on real agricultural platform design
  static const Color primaryGreen = Color(0xFF4CAF50); // XFarm signature green
  static const Color darkGreen = Color(0xFF388E3C); // Deep forest green
  static const Color lightGreen = Color(0xFFE8F5E8); // Light green background
  static const Color accentGreen = Color(0xFF81C784); // Accent green
  
  static const Color farmBlue = Color(0xFF2196F3); // Sky/water blue
  static const Color earthBrown = Color(0xFF8D6E63); // Soil brown
  static const Color sunYellow = Color(0xFFFFC107); // Sunshine yellow
  static const Color cropOrange = Color(0xFFFF9800); // Harvest orange
  
  // Status Colors
  static const Color healthyGreen = Color(0xFF4CAF50);
  static const Color warningAmber = Color(0xFFFFC107);
  static const Color criticalRed = Color(0xFFF44336);
  static const Color infoBlue = Color(0xFF2196F3);
  
  // Neutral Farm Colors
  static const Color lightBackground = Color(0xFFF8FAF8); // Very light green tint
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color shadowColor = Color(0x1A000000);
  
    // Text Colors
  static const Color textPrimary = Color(0xFF1A4A3A);
  static const Color textSecondary = Color(0xFF4A7C59);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textHint = Color(0xFFBDBDBD);
  
  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);
  static const Color dividerColor = Color(0xFFEEEEEE);

  // Standard naming aliases for compatibility
  static const Color primaryText = textPrimary;
  static const Color secondaryText = textSecondary;
  static const Color lightText = textLight;
  static const Color hintText = textHint;
  static const Color errorRed = criticalRed;
  static const Color earthGreen = primaryGreen;
  
  // XFarm Signature Gradients
  static const LinearGradient farmGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient skyGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient earthGradient = LinearGradient(
    colors: [Color(0xFF8D6E63), Color(0xFFBCAAA4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF9800), Color(0xFFFFC107)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Standard aliases for compatibility
  static const LinearGradient primaryGradient = farmGradient;

  // Agricultural Icons Theme
  static const IconThemeData farmIconTheme = IconThemeData(
    color: primaryGreen,
    size: 24,
  );

  // XFarm Typography (Agricultural/Modern)
  static const TextStyle farmHeadingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: primaryText,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle farmHeadingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: primaryText,
    letterSpacing: -0.25,
    height: 1.3,
  );

  static const TextStyle farmHeadingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: primaryText,
    height: 1.4,
  );

  static const TextStyle farmBodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: primaryText,
    height: 1.5,
  );

  static const TextStyle farmBodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: primaryText,
    height: 1.4,
  );

  static const TextStyle farmBodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: secondaryText,
    height: 1.3,
  );

  static const TextStyle farmLabelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: primaryText,
  );

  static const TextStyle farmLabelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: primaryText,
  );

  static const TextStyle farmLabelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: secondaryText,
  );

  // Standard aliases for compatibility
  static const TextStyle headingLarge = farmHeadingLarge;
  static const TextStyle headingMedium = farmHeadingMedium;
  static const TextStyle headingSmall = farmHeadingSmall;
  static const TextStyle bodyLarge = farmBodyLarge;
  static const TextStyle bodyMedium = farmBodyMedium;
  static const TextStyle bodySmall = farmBodySmall;
  static const TextStyle labelLarge = farmLabelLarge;
  static const TextStyle labelMedium = farmLabelMedium;

  // Standard sizing aliases
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;

  // Border radius aliases
  static const BorderRadius borderRadiusSmall = BorderRadius.all(Radius.circular(radiusSmall));
  static const BorderRadius borderRadiusMedium = BorderRadius.all(Radius.circular(radiusMedium));
  static const BorderRadius borderRadiusLarge = BorderRadius.all(Radius.circular(radiusLarge));
  static const BorderRadius borderRadiusXLarge = BorderRadius.all(Radius.circular(radiusXLarge));

  // Agricultural Design Constants
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  static const double spacingTiny = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 48.0;

  // XFarm Shadows
  static const List<BoxShadow> farmCardShadow = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 8,
      spreadRadius: 0,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> farmElevatedShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 16,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
  ];

  // XFarm Theme Data
  static ThemeData get xfarmTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: farmBlue,
        tertiary: sunYellow,
        surface: cardBackground,
        background: lightBackground,
        error: criticalRed,
        onPrimary: lightText,
        onSecondary: lightText,
        onSurface: primaryText,
        onBackground: primaryText,
        onError: lightText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: lightText,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightText,
        ),
      ),
      cardTheme: const CardThemeData(
        color: cardBackground,
        elevation: 2,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusMedium)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: lightText,
          elevation: 2,
          shadowColor: shadowColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radiusSmall)),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLarge,
            vertical: spacingMedium,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: primaryGreen, width: 2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radiusSmall)),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLarge,
            vertical: spacingMedium,
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusSmall)),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusSmall)),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusSmall)),
          borderSide: BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusSmall)),
          borderSide: BorderSide(color: criticalRed),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacingMedium,
          vertical: spacingMedium,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderColor,
        thickness: 1,
        space: spacingMedium,
      ),
    );
  }
}

// XFarm Agricultural Icons
class XFarmIcons {
  static const IconData farm = Icons.agriculture;
  static const IconData livestock = Icons.pets;
  static const IconData crops = Icons.grass;
  static const IconData tractor = Icons.agriculture;
  static const IconData weather = Icons.wb_sunny;
  static const IconData soil = Icons.landscape;
  static const IconData water = Icons.water_drop;
  static const IconData seeds = Icons.eco;
  static const IconData harvest = Icons.agriculture;
  static const IconData storage = Icons.warehouse;
  static const IconData analytics = Icons.analytics;
  static const IconData health = Icons.health_and_safety;
  static const IconData feed = Icons.restaurant;
  static const IconData calendar = Icons.calendar_today;
  static const IconData location = Icons.location_on;
  static const IconData temperature = Icons.thermostat;
  static const IconData money = Icons.attach_money;
}