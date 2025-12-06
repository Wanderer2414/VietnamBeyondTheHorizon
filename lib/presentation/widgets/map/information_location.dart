import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/location_info/location_info.dart';

class InformationLocation extends StatelessWidget {
  // final MyMapController controller;
  final Function() onClose;
  final Function(LatLng) onNavigate;
  final LocationModel locationModel;
  const InformationLocation({
    super.key,
    required this.onClose,
    required this.onNavigate,
    required this.locationModel,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          children: [
            GestureDetector(onTap: () {
              Navigator.of(context).pop();
              onClose();
            },),
            Align(
              alignment: Alignment.bottomCenter,
              child: LocationInfoWidget(
                location: locationModel,
                onClose: () {
                  Navigator.of(context).pop();
                  onClose();
                },
                onNavigate: (loc) {
                  Navigator.of(context).pop();
                  onNavigate(loc);
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
