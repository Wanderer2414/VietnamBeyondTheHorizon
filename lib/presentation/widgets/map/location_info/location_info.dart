import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/presentation/constants/color_palette.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/location_info/description_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/location_info/overview_box.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/location_info/photo_box.dart';

class LocationInfoWidget extends StatelessWidget {
  final VoidCallback onClose;
  final MyMapController controller;
  final LocationModel location;

  const LocationInfoWidget({
    super.key,
    required this.location,
    required this.onClose,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  location.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              IconButton(
                icon: const Icon(
                  Icons.directions,
                  color: ColorPalette.primaryColor,
                  size: 35,
                ),
                onPressed: () {
                  controller.fetchRoute(
                    controller.value.currentLocation,
                    location.coordinates,
                  );
                },
              ),
              IconButton(
                onPressed: () => controller.toggleLocationInfoPanel(null),
                icon: Icon(
                  Icons.close_rounded,
                  size: 35,
                  color: ColorPalette.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(
            color: ColorPalette.dividerColor,
            thickness: 1,
            indent: screenSize.width * 0.1,
            endIndent: screenSize.width * 0.1,
          ),

          OverviewBox(
            address: location.address,
            cost: location.price,
            openTime: location.openTime,
            closeTime: location.closeTime,
          ),

          SizedBox(height: 8),
          Divider(
            color: ColorPalette.dividerColor,
            thickness: 1,
            indent: screenSize.width * 0.1,
            endIndent: screenSize.width * 0.1,
          ),

          PhotoBoxWidget(imageURLs: location.imageURLs),

          SizedBox(height: 8),
          Divider(
            color: ColorPalette.dividerColor,
            thickness: 1,
            indent: screenSize.width * 0.1,
            endIndent: screenSize.width * 0.1,
          ),

          DescriptionBox(description: location.description),
        ],
      ),
    );
  }
}
