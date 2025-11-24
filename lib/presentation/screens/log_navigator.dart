import 'package:flutter/material.dart';

class LogNavigatorScreen extends StatelessWidget {
  const LogNavigatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/backgrounds/log_navigator.png"),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black26, Colors.black54],
              ),
            ),
            alignment: Alignment.bottomCenter,
          ),

          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(0, 0, 0, 0),
                  Color.fromARGB(255, 0, 0, 0),
                ],
              ),
            ),
            alignment: Alignment.bottomCenter,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size.width * 0.8,
              height: size.height * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vietnam BeyondTheHorizon
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          // Welcome Text
                          TextSpan(
                            text: 'Welcome to\n',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontFamily: "Kay Pho Du",
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.2,
                            ),
                          ),
                          TextSpan(
                            text: 'Vietnam\nBeyond The Horizon\n\n',
                            style: TextStyle(
                              color: const Color(0xFFFDB913),
                              fontSize: 35,
                              fontFamily: "Kay Pho Du",
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          // Subtitle
                          TextSpan(
                            text:
                                'The best traveling game to boost\nyour experience in Vietnam',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: "Jost",
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: size.width * 0.1,

                    children: [
                      // Sign Up Button
                      SizedBox(
                        width: size.width * 0.3,
                        height: size.height * 0.06,
                        child: TextButton(
                          onPressed: () {
                            // Navigate to sign up page
                            Navigator.of(
                              context,
                            ).pushReplacementNamed("register");
                          },
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "Jost",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Log In Button
                      SizedBox(
                        width: size.width * 0.3,
                        height: size.height * 0.06,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed("login");
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFFDB913),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'LOG IN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "Jost",
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }
}
