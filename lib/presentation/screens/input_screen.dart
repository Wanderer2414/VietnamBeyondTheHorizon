import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/animations/screen/transitionRL.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/map_screen.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController(
    text: '20\$',
  );
  final TextEditingController _durationController = TextEditingController(
    text: '2 days',
  );

  Map<String, bool> interests = {
    'Attractions': true,
    'Culture': true,
    'Food': true,
    'Entertainment': true,
  };

  @override
  void dispose() {
    _locationController.dispose();
    _budgetController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF0E8), Color(0xFFB8F5F0), Color(0xFFFFF9C4)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Back button
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 32,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),

              // Main content
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 24.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth > 500
                                ? 500
                                : constraints.maxWidth,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth > 400 ? 28 : 20,
                            vertical: 36,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Plan Your Trip Button
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF8A5B),
                                      Color(0xFFFF6B6B),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFF8A5B,
                                      ).withOpacity(0.4),
                                      blurRadius: 15,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'PLAN YOUR TRIP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 40),

                              // Location Field
                              _buildInputField(
                                'Location',
                                '(GPS)',
                                _locationController,
                              ),

                              const SizedBox(height: 20),

                              // Budget Field
                              _buildInputField(
                                'Budget',
                                '20\$',
                                _budgetController,
                              ),

                              const SizedBox(height: 20),

                              // Interest Field
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Interest',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ...interests.entries.map((entry) {
                                      bool isOrange =
                                          entry.key == 'Culture' ||
                                          entry.key == 'Entertainment';
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12.0,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              interests[entry.key] =
                                                  !entry.value;
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 26,
                                                height: 26,
                                                decoration: BoxDecoration(
                                                  color: entry.value
                                                      ? (isOrange
                                                            ? const Color(
                                                                0xFFFF9800,
                                                              )
                                                            : Colors.black)
                                                      : Colors.white,
                                                  border: Border.all(
                                                    color: entry.value
                                                        ? (isOrange
                                                              ? const Color(
                                                                  0xFFFF9800,
                                                                )
                                                              : Colors.black)
                                                        : Colors.grey.shade400,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: entry.value
                                                    ? const Icon(
                                                        Icons.check,
                                                        size: 18,
                                                        color: Colors.white,
                                                      )
                                                    : null,
                                              ),
                                              const SizedBox(width: 14),
                                              Expanded(
                                                child: Text(
                                                  entry.key,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Duration Field
                              _buildInputField(
                                'Duration',
                                '2 days',
                                _durationController,
                              ),

                              const SizedBox(height: 50),

                              // Next Button
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    TransitionRLPageRoute(
                                      nextScreen: MapScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 50,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFF59E0B),
                                        Color(0xFFFF6B6B),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFF59E0B,
                                        ).withOpacity(0.4),
                                        blurRadius: 15,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'NEXT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
