import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TestResultScreen extends StatefulWidget {
  final int score;
  final int maxScore;

  const TestResultScreen({
    Key? key,
    required this.score,
    required this.maxScore,
  }) : super(key: key);

  @override
  State<TestResultScreen> createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> {
  @override
  void initState() {
    super.initState();
    _saveResult();
  }

  Future<void> _saveResult() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedHistory = prefs.getStringList('test_history') ?? [];
    
    Map<String, dynamic> result = {
      'score': widget.score,
      'maxScore': widget.maxScore,
      'date': DateTime.now().toIso8601String(),
      'category': _getCategory(),
    };
    
    savedHistory.insert(0, jsonEncode(result));
    
    // Simpan maksimal 10 riwayat terakhir
    if (savedHistory.length > 10) {
      savedHistory = savedHistory.sublist(0, 10);
    }
    
    await prefs.setStringList('test_history', savedHistory);
  }

  String _getCategory() {
    final percentage = (widget.score / widget.maxScore) * 100;
    
    if (percentage < 25) {
      return 'Sangat Baik';
    } else if (percentage < 45) {
      return 'Baik';
    } else if (percentage < 65) {
      return 'Perlu Perhatian';
    } else {
      return 'Perlu Bantuan Profesional';
    }
  }

  Color _getCategoryColor() {
    final percentage = (widget.score / widget.maxScore) * 100;
    
    if (percentage < 25) {
      return const Color(0xFF10B981);
    } else if (percentage < 45) {
      return const Color(0xFF3B82F6);
    } else if (percentage < 65) {
      return const Color(0xFFF59E0B);
    } else {
      return const Color(0xFFEF4444);
    }
  }

  String _getAdvice() {
    final percentage = (widget.score / widget.maxScore) * 100;
    
    if (percentage < 25) {
      return 'Kondisi mental Anda sangat baik! Terus pertahankan pola hidup sehat, olahraga teratur, dan jaga keseimbangan hidup Anda.';
    } else if (percentage < 45) {
      return 'Kondisi mental Anda cukup baik. Lakukan meditasi rutin, jaga pola tidur, dan luangkan waktu untuk diri sendiri.';
    } else if (percentage < 65) {
      return 'Anda mungkin mengalami stres atau tekanan. Pertimbangkan untuk berbicara dengan orang terdekat, lakukan aktivitas yang menenangkan, dan jangan ragu mencari bantuan profesional jika diperlukan.';
    } else {
      return 'Hasil tes menunjukkan Anda mungkin memerlukan bantuan profesional. Sangat disarankan untuk berkonsultasi dengan psikolog atau psikiater untuk mendapatkan penanganan yang tepat.';
    }
  }

  IconData _getCategoryIcon() {
    final percentage = (widget.score / widget.maxScore) * 100;
    
    if (percentage < 25) {
      return Icons.sentiment_very_satisfied;
    } else if (percentage < 45) {
      return Icons.sentiment_satisfied;
    } else if (percentage < 65) {
      return Icons.sentiment_neutral;
    } else {
      return Icons.sentiment_dissatisfied;
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.score / widget.maxScore) * 100;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: const Text(
          'Hasil Tes',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Result card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getCategoryColor().withOpacity(0.1),
                    _getCategoryColor().withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getCategoryColor().withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _getCategoryIcon(),
                    size: 80,
                    color: _getCategoryColor(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _getCategory(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _getCategoryColor(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Skor: ${widget.score} dari ${widget.maxScore}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${percentage.toInt()}%',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: _getCategoryColor(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Advice card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Color(0xFFF59E0B),
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Saran untuk Anda',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getAdvice(),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF6B7280),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Info text - riwayat dipindah ke home
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF5A7B6A).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.info_outline,
                    color: Color(0xFF5A7B6A),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Lihat riwayat tes lengkap di Akses Cepat pada halaman beranda',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF2D4A3E),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D4A3E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kembali ke Beranda',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}