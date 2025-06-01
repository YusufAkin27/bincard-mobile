import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Ana renkler
  static const Color primaryColor = Color(0xFF1E88E5); // Mavi
  static const Color secondaryColor = Color(0xFF26C6DA); // Turkuaz
  static const Color accentColor = Color(0xFFFFB300); // Amber
  static const Color backgroundColor = Color(0xFFF5F7FA); // Açık gri-mavi

  // Metin renkleri
  static const Color textPrimaryColor = Color(0xFF2D3748); // Koyu mavi-gri
  static const Color textSecondaryColor = Color(0xFF718096); // Orta gri
  static const Color textLightColor = Color(0xFFFAFAFA); // Beyaz

  // Durum renkleri
  static const Color successColor = Color(0xFF48BB78); // Yeşil
  static const Color errorColor = Color(0xFFE53E3E); // Kırmızı
  static const Color warningColor = Color(0xFFECC94B); // Sarı
  static const Color infoColor = Color(0xFF4299E1); // Mavi

  // Kart renkleri
  static const Color cardColor = Color(0xFFFFFFFF); // Beyaz
  static const Color cardShadowColor = Color(0x1A000000); // Transparan siyah

  // Arka plan varyasyonları
  static const Color backgroundVariant1 = Color(0xFFEBF4FF); // Açık mavi
  static const Color backgroundVariant2 = Color(0xFFFFF9EB); // Açık amber

  // Gradient renkler
  static const List<Color> blueGradient = [
    Color(0xFF2979FF),
    Color(0xFF1565C0),
  ];
  static const List<Color> greenGradient = [
    Color(0xFF4CAF50),
    Color(0xFF2E7D32),
  ];
  static const List<Color> amberGradient = [
    Color(0xFFFFB300),
    Color(0xFFFFA000),
  ];
  static const List<Color> purpleGradient = [
    Color(0xFF9C27B0),
    Color(0xFF7B1FA2),
  ];

  // Temaları oluştur
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        background: backgroundColor,
        error: errorColor,
        surface: cardColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textLightColor,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          color: textPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.poppins(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.poppins(color: textPrimaryColor, fontSize: 16),
        bodyMedium: GoogleFonts.poppins(
          color: textSecondaryColor,
          fontSize: 14,
        ),
        labelLarge: GoogleFonts.poppins(
          color: textLightColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textLightColor,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 2,
        shadowColor: cardShadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: textLightColor,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE2E8F0),
        thickness: 1,
      ),
      iconTheme: const IconThemeData(color: primaryColor, size: 24),
    );
  }

  // Koyu tema
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        background: const Color(0xFF1A202C),
        error: errorColor,
        surface: const Color(0xFF2D3748),
      ),
      scaffoldBackgroundColor: const Color(0xFF1A202C),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2D3748),
        foregroundColor: textLightColor,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          color: textLightColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.poppins(
          color: textLightColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.poppins(color: textLightColor, fontSize: 16),
        bodyMedium: GoogleFonts.poppins(color: Color(0xFFA0AEC0), fontSize: 14),
        labelLarge: GoogleFonts.poppins(
          color: textLightColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textLightColor,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF2D3748),
        elevation: 2,
        shadowColor: cardShadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF2D3748),
        selectedItemColor: secondaryColor,
        unselectedItemColor: Color(0xFFA0AEC0),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: textLightColor,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF4A5568),
        thickness: 1,
      ),
      iconTheme: const IconThemeData(color: Color(0xFFA0AEC0), size: 24),
    );
  }
}
