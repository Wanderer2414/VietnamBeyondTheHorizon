import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: const Color(0xFF6E6F41),
      body: SafeArea(
        child: Center(
          child: Container(
            width: screenWidth * 0.9, // 90% chiều rộng màn hình
            height: screenHeight * 0.85, // 85% chiều cao màn hình
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE2DFC5), Color(0xFFF3A29A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo tròn (biểu tượng ngọn núi và ngôi sao)
                Container(
                  width: screenWidth * 0.25, // 25% chiều rộng màn hình
                  height: screenWidth * 0.25,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6F61), Color(0xFFE35040)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(2, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Hình núi
                        CustomPaint(
                          size: Size(screenWidth * 0.15, screenWidth * 0.15),
                          painter: MountainPainter(),
                        ),
                        // Ngôi sao
                        Positioned(
                          top: screenWidth * 0.055,
                          child: Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: screenWidth * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "V I E T N A M",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: const Color(0xFFB67900),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Beyond The Horizon",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB67900),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/Page2onBoarding');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB67900),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                      vertical: screenHeight * 0.015,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.white,
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

// Custom painter để vẽ ngọn núi
class MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.3, size.height * 0.4);
    path.lineTo(size.width * 0.5, size.height * 0.65);
    path.lineTo(size.width * 0.7, size.height * 0.3);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}