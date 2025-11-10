import 'package:flutter/material.dart';
import 'meditation_detail_screen.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  String selectedCategory = 'Semua';
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final List<Map<String, dynamic>> allMeditations = [
    {
      'title': 'Tenang di Pagi Hari',
      'duration': '10 Menit',
      'imagePath': 'assets/images/Pagi_Hari.jpg',
      'color': Color(0xFFFFB84D),
      'category': 'Fokus',
      'description': 'Mulai hari Anda dengan ketenangan dan energi positif melalui meditasi pagi yang menyegarkan.',
      'benefits': ['Meningkatkan fokus', 'Energi positif', 'Mengurangi stres pagi'],
      'audioUrl': 'audio/sunday_driver_loop_401994.mp3',
    },
    {
      'title': 'Pengantar Tidur Lelap',
      'duration': '15 Menit',
      'imagePath': 'assets/images/Tidur_Lelap.webp',
      'color': Color(0xFF2C3E50),
      'category': 'Tidur',
      'description': 'Meditasi khusus untuk membantu Anda rileks dan mendapatkan tidur yang berkualitas.',
      'benefits': ['Tidur lebih nyenyak', 'Mengurangi insomnia', 'Relaksasi mendalam'],
      'audioUrl': 'audio/meditation-background-music-383120.mp3',
    },
    {
      'title': 'Fokus Sepenuhnya',
      'duration': '5 Menit',
      'imagePath': 'assets/images/Fokus_Sepenuhnya.jpg',
      'color': Color(0xFF6B9080),
      'category': 'Fokus',
      'description': 'Meditasi singkat untuk meningkatkan konsentrasi dan produktivitas Anda.',
      'benefits': ['Konsentrasi maksimal', 'Produktivitas meningkat', 'Pikiran jernih'],
      'audioUrl': 'audio/meditation-music-338902.mp3',
    },
    {
      'title': 'Meditasi Pemula',
      'duration': '10 Menit',
      'imagePath': 'assets/images/Meditasi_Pemula.jpg',
      'color': Color(0xFF8B9D77),
      'category': 'Semua',
      'description': 'Panduan meditasi untuk pemula yang ingin memulai perjalanan mindfulness.',
      'benefits': ['Mudah dipahami', 'Dasar meditasi', 'Relaksasi'],
      'audioUrl': 'audio/meditation-music-427644.mp3',
    },
    {
      'title': 'Mengatasi Kecemasan',
      'duration': '12 Menit',
      'imagePath': 'assets/images/Mengatasi_Kecemasan.jpg',
      'color': Color(0xFF9B6B9E),
      'category': 'Stres',
      'description': 'Teknik meditasi untuk meredakan kecemasan dan memberikan ketenangan pikiran.',
      'benefits': ['Mengurangi kecemasan', 'Pikiran tenang', 'Emosi stabil'],
      'audioUrl': 'audio/meditation-yoga-relaxing-music-380330.mp3',
    },
    {
      'title': 'Meditasi Pernapasan',
      'duration': '8 Menit',
      'imagePath': 'assets/images/Meditasi_Pernapasan.webp',
      'color': Color(0xFF5DADE2),
      'category': 'Stres',
      'description': 'Fokus pada pernapasan untuk mencapai ketenangan dan mengurangi stres.',
      'benefits': ['Pernapasan teratur', 'Stres berkurang', 'Relaksasi otot'],
      'audioUrl': 'audio/sleep-music-vol16-195422.mp3',
    },
    {
      'title': 'Energi Pagi',
      'duration': '7 Menit',
      'imagePath': 'assets/images/Energi_Pagi.jpg',
      'color': Color(0xFFF39C12),
      'category': 'Fokus',
      'description': 'Bangkitkan energi positif di pagi hari dengan meditasi yang membangkitkan semangat.',
      'benefits': ['Energi meningkat', 'Semangat pagi', 'Motivasi tinggi'],
      'audioUrl': 'audio/morning_energy.mp3',
    },
    {
      'title': 'Tidur Cepat',
      'duration': '10 Menit',
      'imagePath': 'assets/images/Tidur_Cepat.webp',
      'color': Color(0xFF34495E),
      'category': 'Tidur',
      'description': 'Meditasi singkat untuk membantu Anda tertidur dengan cepat dan nyenyak.',
      'benefits': ['Tertidur cepat', 'Tidur berkualitas', 'Mimpi indah'],
      'audioUrl': 'audio/quick_sleep.mp3',
    },
    {
      'title': 'Meditasi Gratitude',
      'duration': '12 Menit',
      'imagePath': 'assets/images/Meditasi_Gratitude.jpg',
      'color': Color(0xFFE74C3C),
      'category': 'Semua',
      'description': 'Latihan rasa syukur untuk meningkatkan kebahagiaan dan kepuasan hidup.',
      'benefits': ['Rasa syukur', 'Kebahagiaan', 'Positif thinking'],
      'audioUrl': 'audio/gratitude.mp3',
    },
    {
      'title': 'Konsentrasi Belajar',
      'duration': '15 Menit',
      'imagePath': 'assets/images/Konsentrasi_Belajar.jpg',
      'color': Color(0xFF16A085),
      'category': 'Fokus',
      'description': 'Meditasi untuk meningkatkan fokus dan daya ingat saat belajar atau bekerja.',
      'benefits': ['Fokus belajar', 'Daya ingat kuat', 'Efisiensi kerja'],
      'audioUrl': 'audio/study_focus.mp3',
    },
    {
      'title': 'Relaksasi Mendalam',
      'duration': '20 Menit',
      'imagePath': 'assets/images/Relaksasi_Mendalam.jpg',
      'color': Color(0xFF7D3C98),
      'category': 'Stres',
      'description': 'Meditasi relaksasi mendalam untuk melepaskan ketegangan tubuh dan pikiran.',
      'benefits': ['Relaksasi total', 'Ketegangan hilang', 'Damai'],
      'audioUrl': 'audio/deep_relaxation.mp3',
    },
    {
      'title': 'Tidur Restoratif',
      'duration': '18 Menit',
      'imagePath': 'assets/images/Tidur_Restoratif.jpg',
      'color': Color(0xFF1C2833),
      'category': 'Tidur',
      'description': 'Meditasi untuk tidur yang memulihkan dan menyegarkan tubuh sepenuhnya.',
      'benefits': ['Pemulihan tubuh', 'Tidur nyenyak', 'Segar bangun'],
      'audioUrl': 'audio/restorative_sleep.mp3',
    },
  ];

  List<Map<String, dynamic>> get filteredMeditations {
    return allMeditations.where((meditation) {
      final matchesCategory = selectedCategory == 'Semua' || 
                              meditation['category'] == selectedCategory;
      final matchesSearch = searchQuery.isEmpty ||
                           meditation['title'].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFD0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Meditasi',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Search Bar
                Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E4CC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.black54, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Cari meditasi...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 13,
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            filled: false,
                          ),
                        ),
                      ),
                      if (searchQuery.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              searchController.clear();
                              searchQuery = '';
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(Icons.clear, color: Colors.black54, size: 18),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Category Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('Semua'),
                      _buildCategoryChip('Tidur'),
                      _buildCategoryChip('Stres'),
                      _buildCategoryChip('Fokus'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Results count
                Text(
                  '${filteredMeditations.length} Meditasi',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                // Meditation Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredMeditations.length,
                  itemBuilder: (context, index) {
                    return _buildMeditationCard(filteredMeditations[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6B9080) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF6B9080) : Colors.black12,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeditationCard(Map<String, dynamic> meditation) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeditationDetailScreen(meditation: meditation),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  meditation['imagePath'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: meditation['color'],
                      child: Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meditation['title'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meditation['duration'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}