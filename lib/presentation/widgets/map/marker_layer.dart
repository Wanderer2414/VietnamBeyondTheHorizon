import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';

class MarkerAppearance {
  Color color;
  double size;
  bool shouldPulse;
  IconData icon;
  final int? sequenceNumber;
  MarkerAppearance({
    this.color = Colors.black,
    this.size = 45,
    this.shouldPulse = false,
    this.icon = Icons.location_pin,
    this.sequenceNumber,
  });
}

class LocationMarker extends Marker {
  LocationMarker(
    BuildContext context,
    LocationModel loc,
    MarkerAppearance appear,
    Function(LocationModel loc, BuildContext context) onMarkerTap,
  ) : super(
        point: loc.coordinates,
        width: 60,
        height: 60,
        rotate: true,
        child: GestureDetector(
          onTap: () {
            onMarkerTap(loc, context);
            // onMovingToLocation(loc.coordinates, 15);
          },
          child: PulsingWrapper(
            isPulsing: appear.shouldPulse,
            color: appear.color,
            size: appear.size,
            child: Stack(
              children: [
                Icon(appear.icon, color: appear.color, size: appear.size),
                if (appear.sequenceNumber != null)
                  Positioned(
                    top: appear.size * 0.15,
                    child: Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${appear.sequenceNumber}",
                        style: TextStyle(
                          color: appear.color,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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

class PulsingWrapper extends StatefulWidget {
  final Widget child;
  final bool isPulsing;
  final Color color;
  final double size;

  const PulsingWrapper({
    super.key,
    required this.child,
    this.isPulsing = false,
    this.color = Colors.red,
    this.size = 40,
  });

  @override
  State<PulsingWrapper> createState() => _PulsingWrapperState();
}

class _PulsingWrapperState extends State<PulsingWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 2.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0.6,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.isPulsing) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant PulsingWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPulsing != oldWidget.isPulsing) {
      if (widget.isPulsing) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        if (widget.isPulsing)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withOpacity(0.7),
                    ),
                  ),
                ),
              );
            },
          ),

        widget.child,
      ],
    );
  }
}
