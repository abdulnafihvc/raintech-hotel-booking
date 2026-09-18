import 'package:flutter/material.dart';
import 'screens/hotel_booking_screen.dart';

void main() {
  runApp(const NightOwlApp());
}

class NightOwlApp extends StatelessWidget {
  const NightOwlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NightOwl',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFF60A5FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1E3A8A),
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        fontFamily: 'Roboto',
      ),
      home: const HotelBookingScreen(),
    );
  }
}
