import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/animations/screen/transitionRL.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/gen_routes_algo_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/screens/map_screen.dart';

// Class lưu trữ thông tin đầu vào của user
class UserInput {
  LatLng? gpsLocation; // GPS (địa điểm)
  double budget; // Tiền (VNĐ)
  int durationDays; // Duration (Ngày)
  Map<String, bool> interests; // Interest (Yes/No cho attraction, food, culture, entertainment)
  final MyMapController myMapController = MyMapController();

  UserInput({
    this.gpsLocation,
    this.budget = 0.0,
    this.durationDays = 0,
    Map<String, bool>? interests,
  }) : interests = interests ??
            {
              'Attractions': true,
              'Culture': true,
              'Food': true,
              'Entertainment': true,
            };

  // Lấy danh sách các interests được chọn
  List<String> getSelectedInterests() {
    return interests.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key.toLowerCase())
        .toList();
  }

  // Parse budget từ string (có thể có đơn vị $)
  static double parseBudget(String budgetText) {
    String cleaned = budgetText.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  // Parse duration từ string (có thể có từ "days")
  static int parseDuration(String durationText) {
    String cleaned = durationText.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(cleaned) ?? 0;
  }

  @override
  String toString() {
    return 'UserInput{gpsLocation: $gpsLocation, budget: $budget, durationDays: $durationDays, interests: $interests}';
  }
}

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController _budgetController = TextEditingController(
    text: '20\$',
  );
  final TextEditingController _durationController = TextEditingController(
    text: '2 days',
  );

  // UserInput instance để lưu trữ dữ liệu
  late UserInput userInput;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    userInput = UserInput(
      budget: 20.0,
      durationDays: 2,
    );
  }

  final RoutePlannerService _routePlanner = RoutePlannerService();

  @override
  void dispose() {
    _budgetController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  // Hàm xử lý khi nhấn nút NEXT
  void _handleNext() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Lấy GPS location khi nhấn nút NEXT
      await userInput.myMapController.initLocation();
      
      if (userInput.myMapController.value.currentLocation != null) {
        userInput.gpsLocation = userInput.myMapController.value.currentLocation!;
        
        // Cập nhật UserInput với dữ liệu từ các controllers
        userInput.budget = UserInput.parseBudget(_budgetController.text);
        userInput.durationDays = UserInput.parseDuration(_durationController.text);

        // Debug: In ra thông tin
        print('User Input: ${userInput.toString()}');
        print('GPS Location: ${userInput.gpsLocation}');
        print('Selected Interests: ${userInput.getSelectedInterests()}');

        // TODO: Gửi User.input, Maplist.input -> Xử lý -> output list
        // Ví dụ: gọi controller để xử lý
        // GenRoutesAlgoController.processUserInput(userInput);

        // ====== PHẦN MỚI: GỌI THUẬT TOÁN TÌM ĐƯỜNG ======
        
        // Lấy danh sách locations và missions từ controller
        List<LocationModel> allLocations = userInput.myMapController.locationsList;
        List<MissionModel> allMissions = userInput.myMapController.missionList;
        
        // Gọi thuật toán để tạo route
        List<LocationModel> selectedRoute = await _routePlanner.generateRouteFromUserInput(
          userGPS: userInput.gpsLocation!,
          selectedInterests: userInput.getSelectedInterests(),
          budget: userInput.budget,
          durationDays: userInput.durationDays,
          allLocations: allLocations,
          allMissions: allMissions,
        );
        
        print('\n=== SELECTED ROUTE ===');
        print('Found ${selectedRoute.length} locations');
        for (int i = 0; i < selectedRoute.length; i++) {
          print('${i + 1}. ${selectedRoute[i].name} (${selectedRoute[i].type})');
        }
        
        // Vẽ đường đi trên bản đồ
        if (selectedRoute.isNotEmpty) {
          await userInput.myMapController.fetchFullRoute(selectedRoute);
          print('Route drawn on map successfully!');
        } else {
          print('No suitable locations found for your criteria');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No suitable locations found. Please adjust your criteria.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
        
        // ====== KẾT THÚC PHẦN XỬ LÝ THUẬT TOÁN ======


        // Chuyển hướng sang MapScreen
        if (mounted) {
          Navigator.of(context).push(
            TransitionRLPageRoute(
              nextScreen: const MapScreen(),
            ),
          );
        }
      } else {
        // Không lấy được location
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to get your location. Please enable GPS.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                                    ...userInput.interests.entries.map((entry) {
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
                                              userInput.interests[entry.key] =
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
                                onTap: _isLoading ? null : _handleNext,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 50,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _isLoading
                                          ? [
                                              Colors.grey.shade400,
                                              Colors.grey.shade500,
                                            ]
                                          : [
                                              const Color(0xFFF59E0B),
                                              const Color(0xFFFF6B6B),
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _isLoading
                                            ? Colors.grey.withOpacity(0.4)
                                            : const Color(0xFFF59E0B)
                                                .withOpacity(0.4),
                                        blurRadius: 15,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                      : const Text(
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