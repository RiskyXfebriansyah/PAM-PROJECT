import 'package:flutter/material.dart';
import 'article_detail_screen.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final Map<String, dynamic> featuredArticle = {
    'title': '5 Cara Mengelola Stres di Tempat Kerja',
    'description': 'Temukan strategi efektif untuk menjaga ketenangan Anda...',
    'icon': Icons.work,
    'color': Color(0xFF4A90A4),
    'imagePath': 'assets/images/meditasi_stress_tempat_kerja.jpg',
    'content': '''
Stres di tempat kerja adalah hal yang umum terjadi. Tuntutan pekerjaan, tenggat waktu yang ketat, dan dinamika interpersonal dapat memicu tekanan. Namun, ada strategi efektif untuk mengelolanya.
(Konten artikel Anda di sini...)
'''
  };

  final List<Map<String, dynamic>> otherArticles = [
    {
      'title': 'Mengenal Mindfulness',
      'description': 'Latihan sederhana untuk memulai hari dengan tenang.',
      'icon': Icons.spa,
      'color': const Color(0xFF8FAD88),
      'imagePath': 'assets/images/Mengenal_Mindfulness.jpg',
      'content':
          'Mindfulness adalah praktik menyadari momen saat ini tanpa penilaian...'
    },
    {
      'title': 'Manfaat Menulis Jurnal',
      'description': 'Ekspresikan perasaan dan temukan pola pikir positif.',
      'icon': Icons.book,
      'color': const Color(0xFFD4A574),
      'imagePath': 'assets/images/Menulis_Jurnal.jpg',
      'content':
          'Menulis jurnal setiap hari dapat menjadi alat terapi yang kuat...'
    },
    {
      'title': 'Membangun Hubungan Sehat',
      'description': 'Tips komunikasi untuk koneksi yang lebih dalam.',
      'icon': Icons.people,
      'color': const Color(0xFF8B9D77),
      'imagePath': 'assets/images/Hubungan_Sehat.jpg',
      'content':
          'Hubungan yang sehat dibangun di atas komunikasi yang jujur dan empati...'
    },
    {
      'title': 'Mengatasi Kecemasan Sosial',
      'description': 'Langkah kecil untuk merasa lebih nyaman di keramaian.',
      'icon': Icons.forum,
      'color': const Color(0xFF7D3C98),
      'imagePath': 'assets/images/Kecemasan_Sosial.jpg',
      'content':
          'Kecemasan sosial lebih dari sekadar rasa malu. Ini adalah ketakutan yang intens...'
    },
    {
      'title': 'Pentingnya Tidur Berkualitas',
      'description': 'Bagaimana tidur memengaruhi kesehatan mental Anda.',
      'icon': Icons.bedtime,
      'color': const Color(0xFF34495E),
      'imagePath': 'assets/images/Tidur_Berkualitas.webp',
      'content':
          'Tidur bukan hanya istirahat fisik. Selama tidur, otak Anda memproses emosi...'
    },
    {
      'title': 'Meditasi emang berpengaruh ya ?',
      'description': 'Menyelami manfaat meditasi untuk kesehatan mental.',
      'icon': Icons.bedtime,
      'color': const Color(0xFF34495E),
      'imagePath': 'assets/images/Meditasi_emang_berpengaruh.webp',
      'content':
          'Meditasi adalah praktik yang telah digunakan selama ribuan tahun untuk meningkatkan kesehatan mental dan fisik. Dengan meditasi, kita dapat mengurangi stres, meningkatkan konsentrasi, dan meningkatkan kesadaran diri. Berikut beberapa manfaat meditasi untuk kesehatan mental'
    },
    {
      'title': 'Lakukan Meditasi Sebelum Belajar Agar Bisa Meningkatkan Fokus',
      'description': 'Bagaimana meditasi dapat membantu meningkatkan fokus saat belajar.',
      'icon': Icons.bedtime,
      'color': const Color(0xFF34495E),
      'imagePath': 'assets/images/Lakukan_Meditasi_Sebelum_Belajar.webp',
      'content':
          'Meditasi sebelum belajar dapat membantu menenangkan pikiran dan meningkatkan konsentrasi. Dengan meluangkan waktu sejenak untuk bermeditasi, Anda dapat mempersiapkan diri secara mental untuk sesi belajar yang lebih produktif.'
    },
    {
      'title': 'Pengaruh Meditasi Terhadap Penyembuhan Penyakit: Menjelajahi Kekuatan Pikiran dan Tubuh',
      'description': 'Bagaimana meditasi dapat memengaruhi proses penyembuhan.',
      'icon': Icons.bedtime,
      'color': const Color(0xFF34495E),
      'imagePath': 'assets/images/Meditasi_Penyembuhan_Penyakit.jpg',
      'content':
          'Meditasi telah terbukti memiliki dampak positif pada kesehatan fisik dan mental. Dengan mengurangi stres dan meningkatkan relaksasi, meditasi dapat mempercepat proses penyembuhan dan meningkatkan kualitas hidup secara keseluruhan.'
    },
  ];

  List<Map<String, dynamic>> get filteredOtherArticles {
    if (searchQuery.isEmpty) {
      return otherArticles;
    }
    return otherArticles.where((article) {
      final titleLower = article['title'].toLowerCase();
      final searchLower = searchQuery.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFD0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Text(
                  'Artikel',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Search Bar - TANPA BORDER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
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
                            hintText: 'Cari artikel...',
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
              ),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kartu Unggulan
                    _buildArticleBannerCard(
                      context,
                      featuredArticle,
                      isFeatured: true,
                    ),

                    // Section Title
                    const Padding(
                      padding: EdgeInsets.only(top: 24, bottom: 16),
                      child: Text(
                        'Bacaan Lainnya',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    // Daftar Artikel
                    Column(
                      children: filteredOtherArticles.map((article) {
                        return _buildArticleBannerCard(
                          context,
                          article,
                          isFeatured: false,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleBannerCard(
    BuildContext context,
    Map<String, dynamic> article, {
    bool isFeatured = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(article: article),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 200,
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
                    article['imagePath'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[600],
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
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isFeatured)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Unggulan',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        if (isFeatured) const SizedBox(height: 8),
                        Text(
                          article['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          article['description'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}