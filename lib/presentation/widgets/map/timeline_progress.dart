import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/constants/color_palette.dart';

class TimelineProgress extends StatelessWidget {
  final int currentIndex;
  final int totalSteps;

  const TimelineProgress({
    super.key,
    required this.currentIndex,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double stepWidth =
              (constraints.maxWidth - (30 * totalSteps)) / (totalSteps - 1);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps, (index) {
              bool isCompleted = index < currentIndex;
              bool isCurrent = index == currentIndex;
              bool isLast = index == totalSteps - 1;
              bool isLocked = index > currentIndex;

              return Expanded(
                flex: isLast ? 0 : 1,
                child: Row(
                  children: [
                    _buildNode(index, isCompleted, isCurrent, isLocked, isLast),

                    if (!isLast)
                      Expanded(
                        child: Container(
                          height: 4,
                          color: (index < currentIndex)
                              ? Colors.blue
                              : Colors.black87,
                        ),
                      ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildNode(
    int index,
    bool isCompleted,
    bool isCurrent,
    bool isLocked,
    bool isLast,
  ) {
    // Màu sắc
    Color bgColor = isCompleted || isCurrent ? Colors.blue : Colors.black87;
    Color iconColor = Colors.white;

    double size = isCurrent ? 34 : 28;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: isCurrent
            ? Border.all(color: Colors.blue.shade100, width: 3)
            : null,
      ),
      alignment: Alignment.center,
      child: _buildIconContent(index, isLocked, isLast),
    );
  }

  Widget _buildIconContent(int index, bool isLocked, bool isLast) {
    if (isLast) {
      return Icon(Icons.flag, size: 16, color: Colors.white);
    }

    if (isLocked) {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Text(
            "${index + 1}",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Positioned(
            bottom: -10,
            right: -10,
            child: Icon(Icons.lock, size: 14, color: const Color.fromARGB(255, 131, 131, 131)),
          ),
        ],
      );
    }

    return Text(
      "${index + 1}",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }
}
