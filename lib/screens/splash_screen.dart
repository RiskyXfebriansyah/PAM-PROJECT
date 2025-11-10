import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Untuk afterFirstFrame

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Durasi animasi
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Jalankan animasi setelah frame pertama render
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- BACKGROUND BARU ---
      // Warna putih-mint yang sangat pucat, serasi dengan logo teal
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),

                // --- LOGO BARU ANDA ---
                Image.asset(
                  'assets/images/LOGO.webp', // <-- Pastikan namanya sesuai!
                  height: 250, // Sesuaikan tinggi logo jika perlu
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey[400],
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(flex: 1),

                // --- TEKS JUDUL BARU ---
                Text(
                  'Selamat Datang di Serene',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    // Warna abu-abu gelap kebiruan (dari palet logo)
                    color: const Color(0xFF1A3F42), 
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),

                // --- TEKS SUBJUDUL BARU ---
                Text(
                  'Temukan ketenangan batin Anda dan bangun kebiasaan positif.\nMulailah perjalanan mindfulness Anda sekarang.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    // Warna abu-abu lembut kebiruan (dari palet logo)
                    color: const Color(0xFF4A6B6D), 
                    height: 1.6,
                  ),
                ),

                const Spacer(flex: 2),

                // --- TOMBOL BARU ---
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    // Warna teal/biru-hijau cerah dari logo
                    backgroundColor: const Color(0xFF007A7C), 
                    foregroundColor: Colors.white,
                    elevation: 8,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: const Color(0xFF007A7C).withOpacity(0.3),
                  ),
                  child: const Text(
                    'Mulai Sekarang',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                
                const SizedBox(height: 10), // Padding dari bawah
              ],
            ),
          ),
        ),
      ),
    );
  }
}