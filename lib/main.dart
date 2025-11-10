import 'package:flutter/material.dart';
import 'dart:ui'; // Untuk BackdropFilter (efek blur)
// (Pastikan semua import screen Anda sudah benar)
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/meditation_screen.dart';
import 'screens/counseling_screen.dart';
import 'screens/article_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const SereneApp());
}

class SereneApp extends StatelessWidget {
  const SereneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serene',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFE8E8E8), 
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF1F2937),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const MainScreen(),
        '/meditation': (context) => const MeditationScreen(),
        '/counseling': (context) => const CounselingScreen(),
        '/article': (context) => ArticleScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MeditationScreen(),
    const CounselingScreen(),
    ArticleScreen(), 
    const ProfileScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.self_improvement_outlined,
    Icons.psychology_outlined,
    Icons.article_outlined,
    Icons.person_outline,
  ];

  final List<String> _labels = [
    'Home',
    'Meditasi',
    'Konseling',
    'Artikel',
    'Profil',
  ];

  // WARNA NAVBAR - HIJAU KREM SEPERTI BACKGROUND HOME
  // Semua screen menggunakan warna yang sama
  final Color _navbarColor = const Color(0xFFEBE8DC); // Krem kekuningan seperti gambar
  final Color _accentColor = const Color(0xFF5A7C5C); // Hijau gelap untuk icon & kapsul aktif

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 65,
                decoration: BoxDecoration(
                  // Navbar warna hijau krem konsisten
                  color: _navbarColor.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: _accentColor.withOpacity(0.25),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _accentColor.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_icons.length, (index) {
                    return _buildNavItem(
                      index,
                      _icons[index],
                      _labels[index],
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;

    return Expanded(
      flex: isSelected ? 2 : 1,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), 
              decoration: BoxDecoration(
                // Kapsul aktif warna hijau gelap
                color: isSelected 
                    ? _accentColor.withOpacity(0.9)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: _accentColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isSelected 
                        ? Colors.white 
                        : _accentColor.withOpacity(0.6),
                    size: 24,
                  ),
                  
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Padding(
                      padding: EdgeInsets.only(left: isSelected ? 6.0 : 0), 
                      child: Text(
                        isSelected ? label : "",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}