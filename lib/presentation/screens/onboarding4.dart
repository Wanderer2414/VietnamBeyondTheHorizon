import 'package:flutter/material.dart';

class Onboarding4 extends StatelessWidget {
  const Onboarding4 ({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.pexels.com/photos/29223474/pexels-photo-29223474.jpeg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08,
                vertical: size.height * 0.04,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Text
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  
                  // Vietnam BeyondTheHorizon
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Vietnam',
                          style: TextStyle(
                            color: const Color(0xFFFDB913),
                            fontSize: size.width * 0.08,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        TextSpan(
                          text: '\nBeyond The Horizon',
                          style: TextStyle(
                            color: const Color(0xFFFDB913),
                            fontSize: size.width * 0.065,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),
                  
                  // Subtitle
                  Text(
                    'The best traveling game to boost\nyour experience in Vietnam',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: size.height * 0.06),
                  
                  // Buttons
                  Row(
                    children: [
                      // Sign Up Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Navigate to sign up page
                            // Navigator.pushNamed(context, MainRoute.signUp);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white, width: 2),
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.02,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.04),
                      
                      // Log In Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to login page or main map
                            // Navigator.pushNamed(context, MainRoute.map);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     //builder: (context) => const OpenStreetMapScreen(),
                            //   ),
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFDB913),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.02,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'LOG IN',
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}