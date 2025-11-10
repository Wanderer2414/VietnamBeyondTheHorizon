import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0; // 0: Info, 1: Album

  // Sample photo data for album view
  final List<String> photos = [
    'assets/images/photo1.jpg',
    'assets/images/photo2.jpg',
    'assets/images/photo3.jpg',
    'assets/images/photo4.jpg',
    'assets/images/photo5.jpg',
    'assets/images/photo6.jpg',
  ];

  @override
   Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with gradient + avatar stacked on top
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  Colors.white,
                  Colors.white,
                ],
              ),
            ),
            child: SafeArea(
              bottom: true,
              child: Column(
                children: [

                  // Avatar + half-circle decorative header (Stack)
                  Center(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        // Nửa hình tròn trang trí
                        Container(
                          width: size.width,                  // chiếm hết chiều ngang màn hình
                          height: size.height * 0.20, 
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFC371), Color(0xFFFF5F6D)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(size.width),
                              bottomRight: Radius.circular(size.width),
                            ),
                          ),
                        ),

                        // Avatar đè lên nửa hình tròn
                        Positioned(
                          bottom: -48,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 56,
                              backgroundColor: Color(0xFFE8E8E8),
                              child: Icon(
                                Icons.person,
                                size: 56,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 64),

                  // Name & Location
                  const Text(
                    'Nguyen Van A',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                      color: Colors.black87,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Thanh pho Ho Chi Minh',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      fontFamily: 'Courier',
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),

          // Stats Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('12', 'stars', Icons.star, Colors.amber),
                _buildStatCard('34', 'km long', null, Colors.blueGrey),
                _buildStatCard('3', 'missions\ncompleted', null, Colors.green),
              ],
            ),
          ),

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTabButton(
                    icon: Icons.person,
                    
                    isSelected: _selectedIndex == 0,
                    onTap: () => setState(() => _selectedIndex = 0),
                  ),
                ),
                Expanded(
                  child: _buildTabButton(
                    icon: Icons.grid_on,
                    isSelected: _selectedIndex == 1,
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                ),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: Container(
              color: _selectedIndex == 0 ? const Color(0xFFFFF9F0) : Colors.white,
              child: _selectedIndex == 0 ? _buildInfoView() : _buildAlbumView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData? icon,
    Color? iconColor,
  ) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              fontFamily: 'Courier',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          if (icon != null)
            Icon(icon, color: iconColor, size: 22)
          else if (label.isNotEmpty)
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontFamily: 'Courier',
                height: 1.2,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.black : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.grey[400],
          size: 28,
        ),
      ),
    );
  }

  Widget _buildInfoView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem(
            'E-mail',
            'nguyenvana@example.com',
          ),
          const SizedBox(height: 24),
          _buildInfoItem(
            'Member since',
            '29 Dec, 2025',
          ),
          const SizedBox(height: 24),
          _buildInfoItem(
            'Age',
            '20',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFFFB088),
            fontFamily: 'Courier',
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Courier',
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildAlbumView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month Label
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            'Nov',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
              fontFamily: 'Courier',
            ),
          ),
        ),
        // Photo Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.grey[200],
                  child: Image.asset(
                    photos[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      final colors = [
                        Colors.teal.shade300,
                        Colors.blue.shade300,
                        Colors.green.shade300,
                        Colors.purple.shade300,
                        Colors.orange.shade300,
                        Colors.pink.shade300,
                      ];
                      return Container(
                        color: colors[index % colors.length],
                        child: const Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}