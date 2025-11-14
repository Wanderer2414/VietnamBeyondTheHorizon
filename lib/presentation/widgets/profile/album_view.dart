import 'package:flutter/material.dart';

class AlbumView extends StatelessWidget {
  const AlbumView({required this.photos});

  final List<String> photos;

  @override
  Widget build(BuildContext context) {
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
