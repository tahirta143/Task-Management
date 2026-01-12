// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class AppTheme {
//   static const Color primaryColor = Color(0xFF4361EE);
//   static const Color secondaryColor = Color(0xFF3A0CA3);
//   static const Color accentColor = Color(0xFF7209B7);
//   static const Color successColor = Color(0xFF4CC9F0);
//   static const Color warningColor = Color(0xFFF72585);
//   static const Color infoColor = Color(0xFF4895EF);
//
//   static ThemeData lightTheme = ThemeData(
//     useMaterial3: true,
//     colorScheme: const ColorScheme.light(
//       primary: primaryColor,
//       secondary: secondaryColor,
//       surface: Colors.white,
//       background: Color(0xFFF8F9FA),
//       error: Color(0xFFE63946),
//     ),
//     scaffoldBackgroundColor: const Color(0xFFF8F9FA),
//     appBarTheme: AppBarTheme(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       centerTitle: true,
//       titleTextStyle: GoogleFonts.inter(
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//         color: Colors.black,
//       ),
//       iconTheme: const IconThemeData(color: Colors.black),
//     ),
//     textTheme: TextTheme(
//       displayLarge: GoogleFonts.inter(
//         fontSize: 32,
//         fontWeight: FontWeight.w700,
//         color: Colors.black,
//       ),
//       displayMedium: GoogleFonts.inter(
//         fontSize: 24,
//         fontWeight: FontWeight.w600,
//         color: Colors.black,
//       ),
//       displaySmall: GoogleFonts.inter(
//         fontSize: 18,
//         fontWeight: FontWeight.w600,
//         color: Colors.black,
//       ),
//       bodyLarge: GoogleFonts.inter(
//         fontSize: 16,
//         fontWeight: FontWeight.w400,
//         color: Colors.black87,
//       ),
//       bodyMedium: GoogleFonts.inter(
//         fontSize: 14,
//         fontWeight: FontWeight.w400,
//         color: Colors.black87,
//       ),
//       labelLarge: GoogleFonts.inter(
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         color: Colors.white,
//       ),
//     ),
//     cardTheme: CardTheme(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       color: Colors.white,
//     ),
//     buttonTheme: const ButtonThemeData(
//       buttonColor: primaryColor,
//       textTheme: ButtonTextTheme.primary,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         textStyle: GoogleFonts.inter(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: Colors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: primaryColor, width: 2),
//       ),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//     ),
//   );
//
//   static ThemeData darkTheme = ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.dark,
//     colorScheme: const ColorScheme.dark(
//       primary: primaryColor,
//       secondary: secondaryColor,
//       surface: Color(0xFF1E1E1E),
//       background: Color(0xFF121212),
//     ),
//     scaffoldBackgroundColor: const Color(0xFF121212),
//     appBarTheme: AppBarTheme(
//       backgroundColor: const Color(0xFF1E1E1E),
//       elevation: 0,
//       centerTitle: true,
//       titleTextStyle: GoogleFonts.inter(
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//         color: Colors.white,
//       ),
//     ),
//   );
// }



import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final Widget child;
  final String? value;
  final Color? color;
  final Color? textColor;
  final double? size;

  const CustomBadge({
    super.key,
    required this.child,
    this.value,
    this.color = Colors.red,
    this.textColor = Colors.white,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (value != null && value!.isNotEmpty)
          Positioned(
            top: -8,
            right: -8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: size!,
                minHeight: size!,
              ),
              child: Text(
                value!,
                style: TextStyle(
                  color: textColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}