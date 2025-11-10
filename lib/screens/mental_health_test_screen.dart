import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/test_result_screen.dart';
import 'test_result_screen.dart';

class MentalHealthTestScreen extends StatefulWidget {
  const MentalHealthTestScreen({Key? key}) : super(key: key);

  @override
  State<MentalHealthTestScreen> createState() => _MentalHealthTestScreenState();
}

class _MentalHealthTestScreenState extends State<MentalHealthTestScreen> {
  int currentQuestion = 0;
  Map<int, int> answers = {};

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Seberapa sering Anda merasa sedih atau murung dalam 2 minggu terakhir?',
      'options': [
        'Tidak pernah',
        'Beberapa hari',
        'Lebih dari seminggu',
        'Hampir setiap hari'
      ],
    },
    {
      'question': 'Apakah Anda mengalami kesulitan tidur atau tidur berlebihan?',
      'options': [
        'Tidak',
        'Kadang-kadang',
        'Sering',
        'Sangat sering'
      ],
    },
    {
      'question': 'Seberapa sering Anda merasa lelah atau kehilangan energi?',
      'options': [
        'Jarang',
        'Kadang-kadang',
        'Sering',
        'Hampir setiap hari'
      ],
    },
    {
      'question': 'Apakah Anda kehilangan minat pada aktivitas yang biasanya Anda nikmati?',
      'options': [
        'Tidak sama sekali',
        'Sedikit',
        'Cukup banyak',
        'Sangat banyak'
      ],
    },
    {
      'question': 'Seberapa sering Anda merasa cemas atau khawatir berlebihan?',
      'options': [
        'Tidak pernah',
        'Beberapa kali',
        'Sering',
        'Hampir setiap saat'
      ],
    },
    {
      'question': 'Apakah Anda mengalami kesulitan berkonsentrasi atau membuat keputusan?',
      'options': [
        'Tidak',
        'Kadang-kadang',
        'Sering',
        'Sangat sering'
      ],
    },
    {
      'question': 'Seberapa sering Anda merasa tidak berharga atau bersalah?',
      'options': [
        'Tidak pernah',
        'Jarang',
        'Kadang-kadang',
        'Sering'
      ],
    },
    {
      'question': 'Apakah Anda mengalami perubahan nafsu makan yang signifikan?',
      'options': [
        'Tidak',
        'Sedikit perubahan',
        'Perubahan sedang',
        'Perubahan drastis'
      ],
    },
    {
      'question': 'Seberapa sering Anda merasa tegang atau gelisah secara fisik?',
      'options': [
        'Tidak pernah',
        'Kadang-kadang',
        'Sering',
        'Hampir selalu'
      ],
    },
    {
      'question': 'Apakah Anda pernah berpikir untuk menyakiti diri sendiri atau lebih baik tidak ada?',
      'options': [
        'Tidak pernah',
        'Sangat jarang',
        'Kadang-kadang',
        'Sering'
      ],
    },
  ];

  void _selectAnswer(int optionIndex) {
    setState(() {
      answers[currentQuestion] = optionIndex;
    });
  }

  void _nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      _submitTest();
    }
  }

  void _previousQuestion() {
    if (currentQuestion > 0) {
      setState(() {
        currentQuestion--;
      });
    }
  }

  void _submitTest() {
    int totalScore = 0;
    answers.forEach((key, value) {
      totalScore += value;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TestResultScreen(
          score: totalScore,
          maxScore: questions.length * 3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastQuestion = currentQuestion == questions.length - 1;
    final hasAnswer = answers.containsKey(currentQuestion);

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tes Kesehatan Mental',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pertanyaan ${currentQuestion + 1} dari ${questions.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${((currentQuestion + 1) / questions.length * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2D4A3E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (currentQuestion + 1) / questions.length,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2D4A3E)),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
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
                    child: Text(
                      questions[currentQuestion]['question'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Options
                  ...List.generate(
                    questions[currentQuestion]['options'].length,
                    (index) {
                      final isSelected = answers[currentQuestion] == index;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _selectAnswer(index),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFE6E0F8)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF2D4A3E)
                                    : const Color(0xFFE5E7EB),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF2D4A3E)
                                          : const Color(0xFFE5E7EB),
                                      width: 2,
                                    ),
                                    color: isSelected
                                        ? const Color(0xFF2D4A3E)
                                        : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    questions[currentQuestion]['options'][index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSelected
                                          ? const Color(0xFF1F2937)
                                          : const Color(0xFF6B7280),
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (currentQuestion > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousQuestion,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2D4A3E),
                        side: const BorderSide(color: Color(0xFF2D4A3E)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Kembali',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (currentQuestion > 0) const SizedBox(width: 12),
                Expanded(
                  flex: currentQuestion > 0 ? 1 : 1,
                  child: ElevatedButton(
                    onPressed: hasAnswer ? _nextQuestion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D4A3E),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFE5E7EB),
                      disabledForegroundColor: const Color(0xFF9CA3AF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isLastQuestion ? 'Selesai' : 'Lanjut',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}