import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text(
                  'Profil',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Profile Header
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  // --- PERUBAHAN DI SINI: ATUR RATA TENGAH ---
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- PERUBAHAN DI SINI: BUNGKUS TEKS AGAR BISA RATA TENGAH ---
                    const SizedBox(
                      width: double.infinity, // Paksa widget ambil lebar penuh
                      child: Text(
                        'Profil Saya',
                        textAlign: TextAlign.center, // Ratakan teks ke tengah
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CustomPaint(
                          painter: ProfileAvatarPainter(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Amelia Chen',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'amelia.chen@example.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu Items
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      Icons.person_outline,
                      'Edit Profil',
                      () {},
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      Icons.bar_chart_outlined,
                      'Statistik Saya',
                      () {},
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      Icons.notifications_outlined,
                      'Pengaturan Notifikasi',
                      () {},
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      Icons.help_outline,
                      'Pusat Bantuan',
                      () {},
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      Icons.logout,
                      'Keluar',
                      () {},
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color color = Colors.black87,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color == Colors.red
                    ? Colors.red.withOpacity(0.1)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color == Colors.red ? Colors.red : const Color(0xFF6B9080),
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: color == Colors.red ? Colors.red : Colors.black26,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileAvatarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Background gradient
    paint.shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFE8D5E8), Color(0xFFD5E8E8)],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    paint.shader = null;

    // Face
    paint.color = const Color(0xFFFFDBB5);
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.42),
      size.width * 0.28,
      paint,
    );

    // Eyes
    paint.color = const Color(0xFF2C3E50);
    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.4),
      size.width * 0.045,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.6, size.height * 0.4),
      size.width * 0.045,
      paint,
    );

    // Smile
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.strokeCap = StrokeCap.round;
    final smilePath = Path();
    smilePath.moveTo(size.width * 0.38, size.height * 0.5);
    smilePath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.55,
      size.width * 0.62,
      size.height * 0.5,
    );
    canvas.drawPath(smilePath, paint);

    // Hair
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFF2C2416);
    
    // Top of hair
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.3),
        width: size.width * 0.6,
        height: size.height * 0.4,
      ),
      paint,
    );

    // Long hair sides
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.45,
        size.width * 0.6,
        size.height * 0.35,
      ),
      paint,
    );

    // Shirt
    paint.color = const Color(0xFF6B8E9D);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.15,
        size.height * 0.68,
        size.width * 0.7,
        size.height * 0.32,
      ),
      paint,
    );

    // Collar
    paint.color = const Color(0xFF5A7B8A);
    final collarPath = Path();
    collarPath.moveTo(size.width * 0.4, size.height * 0.68);
    collarPath.lineTo(size.width * 0.35, size.height * 0.78);
    collarPath.lineTo(size.width * 0.5, size.height * 0.78);
    collarPath.close();
    canvas.drawPath(collarPath, paint);
    
    final collarPath2 = Path();
    collarPath2.moveTo(size.width * 0.6, size.height * 0.68);
    collarPath2.lineTo(size.width * 0.65, size.height * 0.78);
    collarPath2.lineTo(size.width * 0.5, size.height * 0.78);
    collarPath2.close();
    canvas.drawPath(collarPath2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}